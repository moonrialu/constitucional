import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/battles.dart';
import '../data/cases.dart';
import '../engine/battle_engine.dart';
import '../engine/game_controller.dart';
import '../models/battle.dart';
import '../models/card.dart';
import '../models/content.dart';
import '../theme/app_theme.dart';
import '../widgets/app_menu.dart';
import '../widgets/card_view.dart';
import '../widgets/theory_sheet.dart';

/// Mesa de batalha em paisagem: tese adversa à esquerda, fundamentos no
/// centro e a mão da assessora na base.
class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key, required this.config, this.guide = false});

  final BattleConfig config;

  /// Modo tutorial: o Guia (a máquina) joga a partida de exemplo. A mão fica
  /// travada e a narração conduz o jogador passo a passo.
  final bool guide;

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late BattleEngine _engine;

  /// Cartas levantadas da mão: várias podem ficar abertas ao mesmo tempo.
  /// A última tocada é a que aparece na leitura da mesa.
  final LinkedHashSet<String> _lifted = LinkedHashSet<String>();
  String? _focusedId;
  bool _busy = false;

  /// Chave da objeção no centro da mesa: é o destino da carta jogada.
  final GlobalKey _objectionKey = GlobalKey();
  final List<OverlayEntry> _insertionEntries = [];
  final List<Timer> _insertionTimers = [];

  /// Janela do duplo toque (toque simples apenas revela a carta).
  DateTime? _lastTapAt;
  String? _lastTapId;
  bool _saved = false;
  bool _helpShown = false;

  /// Roteiro do Guia: passo atual, fala e rótulo do botão.
  int _guideStep = 0;
  String? _guideText;
  String _guideAction = 'Começar';

  List<ArgumentCard> _played = const [];
  int _floatDamage = 0;
  int _damageTick = 0;
  List<ArgumentCard> _newCards = const [];

  Timer? _playedTimer;
  Timer? _damageTimer;

  @override
  void initState() {
    super.initState();
    _engine = BattleEngine(config: widget.config);
    if (widget.guide) {
      _guideText =
          'Sou o Guia, a máquina que joga com você. Vou fazer uma partida de '
          'exemplo: leia, jogue e monte um conjunto de resposta comigo.';
      return;
    }
    final controller = context.read<GameController>();
    final firstTime =
        (controller.recordForBattle(widget.config.id)?.attempts ?? 0) == 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      controller.beginBattleAttempt(widget.config.id);
      if (firstTime) _autoShowHowTo();
    });
  }

  @override
  void dispose() {
    _playedTimer?.cancel();
    _damageTimer?.cancel();
    for (final entry in _insertionEntries) {
      entry.remove();
    }
    for (final timer in _insertionTimers) {
      timer.cancel();
    }
    super.dispose();
  }

  // --------------------------------------------------------------- jogadas

  /// A mão fica escondida na base: um toque levanta a carta para leitura e
  /// outro toque na mesma carta devolve à posição de descanso. Só o **duplo
  /// toque** coloca a carta no campo de batalha.
  void _select(ArgumentCard card, Rect? rect) {
    if (_busy || _engine.isOver || widget.guide) return;

    final now = DateTime.now();
    final isDouble =
        _lastTapId == card.id &&
        _lastTapAt != null &&
        now.difference(_lastTapAt!) <= const Duration(milliseconds: 400);

    if (isDouble) {
      _lastTapId = null;
      _lastTapAt = null;
      _play(_comboFor(card), fromRect: rect);
      return;
    }

    _lastTapId = card.id;
    _lastTapAt = now;

    setState(() {
      if (_lifted.remove(card.id)) {
        if (_focusedId == card.id) {
          _focusedId = _lifted.isEmpty ? null : _lifted.last;
        }
      } else {
        _lifted.add(card.id);
        _focusedId = card.id;
      }
    });
  }

  void _lowerAll() {
    setState(() {
      _lifted.clear();
      _focusedId = null;
    });
  }

  /// Cartas elevadas, na ordem da mão: formam o conjunto de resposta.
  List<ArgumentCard> get _comboCards => [
    for (final card in _engine.hand)
      if (_lifted.contains(card.id)) card,
  ];

  /// Conjunto a jogar: todas as elevadas mais a carta tocada, se ainda não
  /// estiver no conjunto.
  List<ArgumentCard> _comboFor(ArgumentCard tapped) => [
    for (final card in _engine.hand)
      if (_lifted.contains(card.id) || card.id == tapped.id) card,
  ];

  void _play(List<ArgumentCard> cards, {Rect? fromRect}) {
    if (_busy || _engine.isOver || cards.isEmpty) return;
    final cost = _engine.comboCost(cards);
    if (!_engine.canPlayCombo(cards)) {
      _toast(
        'Energia insuficiente para o conjunto: custo $cost, '
        'energia ${_engine.energy}.',
      );
      return;
    }

    final from = fromRect ?? _fallbackCardRect();
    final target = _objectionRect();

    _playedTimer?.cancel();
    _damageTimer?.cancel();
    setState(() {
      _busy = true;
      for (final card in cards) {
        _lifted.remove(card.id);
      }
      _focusedId = _lifted.isEmpty ? null : _lifted.last;
    });

    // Cada carta voa da mão até a objeção, em cascata. O efeito do conjunto
    // só é aplicado quando a última pousa.
    var pending = cards.length;
    for (var i = 0; i < cards.length; i++) {
      final card = cards[i];
      final timer = Timer(Duration(milliseconds: 150 * i), () {
        if (!mounted) return;
        _showInsertion(card, from.translate(i * 7, -i * 7), target, () {
          pending--;
          if (pending == 0) _applyCombo(cards);
        });
      });
      _insertionTimers.add(timer);
    }
  }

  void _applyCombo(List<ArgumentCard> cards) {
    if (!mounted) return;
    final outcome = _engine.playCombo(cards);
    if (outcome == null) {
      setState(() => _busy = false);
      return;
    }
    setState(() {
      _busy = false;
      _played = cards;
      _floatDamage = outcome.damage;
      _damageTick++;
    });
    _playedTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _played = const []);
    });
    _damageTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _floatDamage = 0);
    });

    if (_engine.isVictory) _finishBattle();
  }

  Rect _objectionRect() {
    final object = _objectionKey.currentContext?.findRenderObject();
    if (object is RenderBox && object.hasSize) {
      return object.localToGlobal(Offset.zero) & object.size;
    }
    final size = MediaQuery.of(context).size;
    return Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.4,
      height: 90,
    );
  }

  Rect _fallbackCardRect() {
    final size = MediaQuery.of(context).size;
    return Rect.fromLTWH(size.width / 2 - 45, size.height - 120, 90, 128);
  }

  void _showInsertion(
    ArgumentCard card,
    Rect from,
    Rect to,
    VoidCallback onDone,
  ) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _CardInsertion(
        card: card,
        from: from,
        to: to,
        onDone: () {
          entry.remove();
          _insertionEntries.remove(entry);
          onDone();
        },
      ),
    );
    _insertionEntries.add(entry);
    Overlay.of(context).insert(entry);
  }

  void _endTurn() {
    if (_busy || _engine.isOver) return;
    final before = _engine.playerConviction;
    setState(() {
      _busy = true;
      _lifted.clear();
      _focusedId = null;
    });

    Timer(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      _engine.endTurn();
      final damage = before - _engine.playerConviction;
      setState(() {
        _busy = false;
        if (damage > 0) {
          _floatDamage = damage;
          _damageTick++;
        }
      });
      if (damage > 0) {
        _damageTimer?.cancel();
        _damageTimer = Timer(const Duration(milliseconds: 1600), () {
          if (mounted) setState(() => _floatDamage = 0);
        });
      }
      if (_engine.isOver) _finishBattle();
    });
  }

  Future<void> _finishBattle() async {
    if (widget.guide || _saved) return;
    _saved = true;

    final controller = context.read<GameController>();
    final already = {for (final card in controller.unlockedCardList) card.id};
    final attempts =
        controller.recordForBattle(widget.config.id)?.attempts ?? 1;

    await controller.completeBattle(
      widget.config.id,
      _engine.toRecord(attempts: attempts, at: DateTime.now()),
    );
    if (!mounted) return;

    setState(() {
      _newCards = _engine.isVictory
          ? controller
                .newCardsFor(widget.config.id)
                .where((c) => !already.contains(c.id))
                .toList()
          : const [];
    });
  }

  void _retry() {
    final controller = context.read<GameController>();
    controller.beginBattleAttempt(widget.config.id);
    setState(() {
      _engine.reset();
      _saved = false;
      _lifted.clear();
      _focusedId = null;
      _played = const [];
      _newCards = const [];
      _floatDamage = 0;
      _busy = false;
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _autoShowHowTo() {
    if (_helpShown || widget.guide) return;
    _helpShown = true;
    _openGuideDemo();
  }

  /// Abre a partida de exemplo jogada pelo Guia.
  void _openGuideDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            BattleScreen(config: tutorialBattle(widget.config), guide: true),
      ),
    );
  }

  // --------------------------------------------------------------- tutorial

  void _guideAdvance() {
    if (_busy) return;
    if (_guideStep >= 6) {
      Navigator.of(context).maybePop();
      return;
    }

    setState(() {
      _guideStep++;
      _guideAction = _guideStep >= 6 ? 'Jogar a batalha' : 'Continuar';
    });
    switch (_guideStep) {
      case 1:
        _guideLiftAttack();
      case 2:
        _guidePlayAttack();
      case 3:
        _guideLiftCombo();
      case 4:
        _guidePlayCombo();
      case 5:
        _guideEndTurn();
      case 6:
        setState(() {
          _guideText =
              'É assim que se joga: leia a carta, dê duplo toque para jogar e '
              'some fundamentos no conjunto de resposta. Agora é com você.';
        });
    }
  }

  ArgumentCard? _guideFind(bool Function(ArgumentCard card) test) {
    for (final card in _engine.hand) {
      if (!_lifted.contains(card.id) && test(card)) return card;
    }
    return null;
  }

  void _guideLiftAttack() {
    final card = _guideFind((c) => c.kind == CardKind.ataque);
    if (card == null) return;
    setState(() {
      _lifted.add(card.id);
      _focusedId = card.id;
      _guideText =
          'Um toque simples só levanta a carta: ela fica aberta para leitura e '
          'ainda não foi jogada. Repare nas tags: '
          '${card.tags.map((tag) => tag.label).join(', ')}.';
    });
  }

  void _guidePlayAttack() {
    ArgumentCard? card;
    for (final c in _engine.hand) {
      if (c.kind == CardKind.ataque) {
        card = c;
        break;
      }
    }
    if (card == null) return;
    setState(() {
      _guideText =
          'Agora o duplo toque: a carta voa para o campo de batalha. Como tem '
          'a tag que a objeção pede, ela refuta o ataque — zero dano no turno '
          'e +3 de bônus.';
    });
    _play([card]);
  }

  void _guideLiftCombo() {
    final cards = [
      for (final card in _engine.hand)
        if (!_lifted.contains(card.id) && card.kind != CardKind.ataque) card,
    ];
    if (cards.isEmpty) return;
    setState(() {
      for (final card in cards) {
        _lifted.add(card.id);
      }
      _focusedId = cards.last.id;
      _guideText =
          'Várias cartas podem ficar levantadas ao mesmo tempo. Assim eu monto '
          'um conjunto de resposta com os fundamentos que se somam.';
    });
  }

  void _guidePlayCombo() {
    final cards = [
      for (final card in _engine.hand)
        if (_lifted.contains(card.id)) card,
    ];
    if (cards.isEmpty) return;
    setState(() {
      _guideText =
          'Duplo toque em qualquer uma delas: o conjunto entra junto no campo. '
          'O custo é somado e os efeitos também — aqui, ${cards.fold<int>(0, (sum, c) => sum + c.block)} de bloqueio.';
    });
    _play(cards);
  }

  void _guideEndTurn() {
    setState(() {
      _guideText =
          'Encerrar turno passa a vez: a tese ataca, o bloqueio do conjunto '
          'absorve o dano e a energia volta ao máximo.';
    });
    _endTurn();
  }

  // ----------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final config = widget.config;

    return Scaffold(
      backgroundColor: AppColors.navy,
      // Sem cabeçalho e sem margem artificial: a mesa e a mão ocupam a tela
      // inteira. O SafeArea só protege recortes reais do aparelho.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 380;
            final sideWidth = (constraints.maxWidth * 0.19)
                .clamp(104.0, 166.0)
                .toDouble();
            final handHeight = compact ? 112.0 : 132.0;

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _TableArea(
                              engine: _engine,
                              objectionKey: _objectionKey,
                              busy: _busy,
                              selected: _selectedCard,
                              combo: _comboCards,
                              onClear: _lowerAll,
                              onEndTurn: _endTurn,
                              guideText: _guideText,
                              guideAction: _guideAction,
                              guideEnabled: !_busy && !_engine.isOver,
                              onGuideNext: _guideAdvance,
                              compact: compact,
                            ),
                          ),
                          SizedBox(
                            width: sideWidth,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: _OpponentPanel(
                                config: config,
                                engine: _engine,
                                compact: compact,
                                turn: _engine.turn,
                                onBack: widget.guide
                                    ? () => Navigator.of(context).maybePop()
                                    : controller.previous,
                                onHelp: widget.guide ? null : _openGuideDemo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: handHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: sideWidth,
                            child: _PlayerBand(
                              engine: _engine,
                              guide: widget.guide,
                              compact: compact,
                            ),
                          ),
                          Expanded(
                            child: _HandFan(
                              cards: _engine.hand,
                              liftedIds: _lifted,
                              focusedId: _focusedId,
                              energy: _engine.energy,
                              enabled:
                                  !_busy && !_engine.isOver && !widget.guide,
                              onTap: _select,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_floatDamage > 0)
                  Positioned(
                    right: sideWidth * 0.5 - 20,
                    top: 210,
                    child: _FloatingDamage(
                      key: ValueKey(_damageTick),
                      value: _floatDamage,
                    ),
                  ),
                if (_played.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: handHeight + 8,
                    child: IgnorePointer(
                      child: Center(child: _PlayedBanner(cards: _played)),
                    ),
                  ),
                if (_busy)
                  Positioned(
                    right: sideWidth + 10,
                    top: 56,
                    child: const _MachineThinking(),
                  ),
                if (_engine.isOver)
                  Positioned.fill(
                    child: _BattleReportOverlay(
                      config: config,
                      engine: _engine,
                      newCards: _newCards,
                      onContinue: controller.next,
                      onRetry: _retry,
                      onTheory: config.theoryId == null
                          ? null
                          : () => showTheorySheet(context, config.theoryId!),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  ArgumentCard? get _selectedCard {
    final id = _focusedId;
    if (id == null) return null;
    for (final card in _engine.hand) {
      if (card.id == id) return card;
    }
    return null;
  }
}

// ------------------------------------------------------------- painéis

class _OpponentPanel extends StatelessWidget {
  const _OpponentPanel({
    required this.config,
    required this.engine,
    required this.compact,
    required this.turn,
    required this.onBack,
    required this.onHelp,
  });

  final BattleConfig config;
  final BattleEngine engine;
  final bool compact;
  final int turn;
  final VoidCallback onBack;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = engine.machineConviction / engine.machineMax;

    return _SidePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Avatar(
            icon: Icons.account_balance,
            color: AppColors.crimsonText,
            soft: AppColors.crimsonSoft,
            size: compact ? 34 : 42,
          ),
          const SizedBox(height: 6),
          Text(
            config.opponentName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          _Meter(
            label: 'Convicção da tese',
            value: engine.machineConviction,
            max: engine.machineMax,
            ratio: ratio,
            color: AppColors.crimsonText,
            soft: AppColors.crimsonSoft,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: AppColors.goldText,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    engine.refuted
                        ? 'Objeção refutada neste turno'
                        : 'Dano previsto: ${engine.incomingDamage}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: AppColors.goldText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Controles que antes ficavam no cabeçalho: voltar, turno, ajuda
          // e menu, agora compactos no rodapé do painel do oponente.
          Row(
            children: [
              IconButton(
                tooltip: 'Voltar',
                onPressed: onBack,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 26,
                  height: 26,
                ),
                iconSize: 16,
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              Icon(
                Icons.autorenew,
                size: 12,
                color: AppColors.ink.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 3),
              Text(
                '$turn',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              if (onHelp != null)
                IconButton(
                  tooltip: 'Como jogar',
                  onPressed: onHelp,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 26,
                    height: 26,
                  ),
                  iconSize: 15,
                  icon: const Icon(Icons.help_outline),
                ),
              const AppMenuButton(compact: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerBand extends StatelessWidget {
  const _PlayerBand({
    required this.engine,
    required this.guide,
    required this.compact,
  });

  final BattleEngine engine;
  final bool guide;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ratio = engine.playerConviction / engine.playerMax;

    return Container(
      margin: const EdgeInsets.fromLTRB(6, 0, 4, 4),
      padding: EdgeInsets.fromLTRB(8, compact ? 5 : 7, 8, 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                guide ? Icons.smart_toy_outlined : Icons.balance,
                size: 14,
                color: AppColors.tealText,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  guide ? 'O Guia' : 'Sua assessoria',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                '${engine.playerConviction}/${engine.playerMax}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: AppColors.tealText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0, 1).toDouble(),
              minHeight: 6,
              color: AppColors.tealText,
              backgroundColor: AppColors.tealSoft,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              for (var i = 0; i < engine.maxEnergy; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 1),
                  child: Icon(
                    i < engine.energy ? Icons.bolt : Icons.bolt_outlined,
                    size: 14,
                    color: i < engine.energy
                        ? AppColors.goldText
                        : AppColors.line,
                  ),
                ),
              const Spacer(),
              const Icon(
                Icons.shield_outlined,
                size: 11,
                color: AppColors.indigoText,
              ),
              const SizedBox(width: 2),
              Text(
                '${engine.block}',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.indigoText,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.style_outlined,
                size: 11,
                color: AppColors.plumText,
              ),
              const SizedBox(width: 2),
              Text(
                '${engine.drawPile.length}',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.plumText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 6, 6, 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.icon,
    required this.color,
    required this.soft,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final Color soft;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: soft, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: size * 0.55),
      ),
    );
  }
}

class _Meter extends StatelessWidget {
  const _Meter({
    required this.label,
    required this.value,
    required this.max,
    required this.ratio,
    required this.color,
    required this.soft,
  });

  final String label;
  final int value;
  final int max;
  final double ratio;
  final Color color;
  final Color soft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  letterSpacing: 0.7,
                  color: AppColors.ink.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '$value/$max',
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio.clamp(0, 1).toDouble(),
            minHeight: 7,
            color: color,
            backgroundColor: soft,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------------------- mesa

class _TableArea extends StatelessWidget {
  const _TableArea({
    required this.engine,
    required this.objectionKey,
    required this.busy,
    required this.selected,
    required this.combo,
    required this.onClear,
    required this.onEndTurn,
    required this.guideText,
    required this.guideAction,
    required this.guideEnabled,
    required this.onGuideNext,
    required this.compact,
  });

  final BattleEngine engine;
  final GlobalKey objectionKey;
  final bool busy;
  final ArgumentCard? selected;
  final List<ArgumentCard> combo;
  final VoidCallback onClear;
  final VoidCallback onEndTurn;
  final String? guideText;
  final String guideAction;
  final bool guideEnabled;
  final VoidCallback onGuideNext;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final objection = engine.objection;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyedSubtree(
            key: objectionKey,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 520),
              transitionBuilder: (child, animation) {
                final rotate = Tween<double>(begin: 0.7, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
                return AnimatedBuilder(
                  animation: rotate,
                  builder: (context, _) => Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0014)
                      ..rotateX((1 - rotate.value) * 1.4),
                    child: Opacity(opacity: animation.value, child: child),
                  ),
                );
              },
              child: objection == null
                  ? const SizedBox.shrink()
                  : _ObjectionCard(
                      key: ValueKey(
                        '${objection.id}-${engine.turn}-${engine.refuted}',
                      ),
                      objection: objection,
                      refuted: engine.refuted,
                      incomingDamage: engine.incomingDamage,
                      compact: compact,
                    ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: guideText != null
                ? _GuidePanel(
                    text: guideText!,
                    action: guideAction,
                    enabled: guideEnabled,
                    onNext: onGuideNext,
                  )
                : selected != null
                ? _CardReading(
                    card: selected!,
                    combo: combo,
                    energy: engine.energy,
                    onClear: onClear,
                  )
                : _LogStrip(engine: engine, compact: compact),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  engine.refuted
                      ? 'Objeção refutada: encerre o turno sem dano.'
                      : 'A objeção causa ${engine.incomingDamage} de dano se não for refutada.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 34,
                child: FilledButton.icon(
                  onPressed: busy || engine.isOver || guideText != null
                      ? null
                      : onEndTurn,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    backgroundColor: AppColors.goldText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.chevron_right, size: 18),
                  label: const Text(
                    'Encerrar turno',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ObjectionCard extends StatelessWidget {
  const _ObjectionCard({
    super.key,
    required this.objection,
    required this.refuted,
    required this.incomingDamage,
    required this.compact,
  });

  final Objection objection;
  final bool refuted;
  final int incomingDamage;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(12, compact ? 7 : 9, 12, compact ? 7 : 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: refuted ? AppColors.teal : AppColors.crimson,
            width: 5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                refuted ? Icons.verified_outlined : Icons.campaign_outlined,
                size: 15,
                color: refuted ? AppColors.tealText : AppColors.crimsonText,
              ),
              const SizedBox(width: 6),
              Text(
                refuted ? 'OBJEÇÃO REFUTADA' : 'OBJEÇÃO DA TESE',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w900,
                  color: refuted ? AppColors.tealText : AppColors.crimsonText,
                ),
              ),
              const Spacer(),
              if (!refuted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.crimsonSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-$incomingDamage',
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: compact ? 3 : 5),
          Text(
            objection.text,
            maxLines: compact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: compact ? 11 : 12,
              height: 1.28,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: compact ? 3 : 5),
          Row(
            children: [
              const Icon(
                Icons.key_outlined,
                size: 12,
                color: AppColors.goldText,
              ),
              const SizedBox(width: 4),
              Text(
                'Refute com: ${objection.counterHint}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: AppColors.goldText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogStrip extends StatelessWidget {
  const _LogStrip({required this.engine, required this.compact});

  final BattleEngine engine;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final entries = engine.log.reversed.take(compact ? 3 : 4).toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Text(
            'MESA · ÚLTIMOS LANCES',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 8,
              letterSpacing: 0.9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4, right: 6),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _logColor(entry.kind),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _logTextColor(entry.kind),
                        fontSize: compact ? 9 : 10,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static Color _logColor(BattleLogKind kind) => switch (kind) {
    BattleLogKind.good => AppColors.teal,
    BattleLogKind.bad => AppColors.crimson,
    BattleLogKind.player => AppColors.gold,
    BattleLogKind.machine => Colors.white70,
    BattleLogKind.neutral => Colors.white38,
  };

  static Color _logTextColor(BattleLogKind kind) => switch (kind) {
    BattleLogKind.good => const Color(0xFF9BE8D2),
    BattleLogKind.bad => const Color(0xFFFFB4B4),
    BattleLogKind.player => const Color(0xFFFFDFA0),
    BattleLogKind.machine => Colors.white,
    BattleLogKind.neutral => Colors.white70,
  };
}

class _CardReading extends StatelessWidget {
  const _CardReading({
    required this.card,
    required this.combo,
    required this.energy,
    required this.onClear,
  });

  final ArgumentCard card;
  final List<ArgumentCard> combo;
  final int energy;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cost = combo.fold<int>(0, (sum, c) => sum + c.cost);
    final damage = combo.fold<int>(0, (sum, c) => sum + c.power);
    final block = combo.fold<int>(0, (sum, c) => sum + c.block);
    final canPlay = cost <= energy;
    final count = combo.length;
    final summary = [
      if (damage > 0) '$damage de dano',
      if (block > 0) '$block de bloqueio',
      if (damage == 0 && block == 0) 'apoio',
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(card.icon, size: 14, color: card.color),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        card.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          color: card.color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${count == 1 ? '1 carta' : '$count cartas'} · '
                      'custo $cost',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.ink.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: Text(
                    card.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      height: 1.25,
                    ),
                  ),
                ),
                Text(
                  count > 1
                      ? 'Conjunto de resposta: $summary'
                      : card.effectLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: card.color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: canPlay ? card.soft : AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (canPlay ? card.color : AppColors.gold).withValues(
                      alpha: 0.45,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      canPlay ? Icons.touch_app_outlined : Icons.bolt_outlined,
                      size: 15,
                      color: canPlay ? card.color : AppColors.goldText,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      canPlay
                          ? (count > 1
                                ? 'Duplo toque\njoga as $count'
                                : 'Duplo toque\npara jogar')
                          : 'Sem energia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        color: canPlay ? card.color : AppColors.goldText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
                child: TextButton(
                  onPressed: onClear,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 24),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text('Abaixar', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- mão

class _HandFan extends StatefulWidget {
  const _HandFan({
    required this.cards,
    required this.liftedIds,
    required this.focusedId,
    required this.energy,
    required this.enabled,
    required this.onTap,
  });

  final List<ArgumentCard> cards;
  final Set<String> liftedIds;
  final String? focusedId;
  final int energy;
  final bool enabled;
  final void Function(ArgumentCard card, Rect? rect) onTap;

  @override
  State<_HandFan> createState() => _HandFanState();
}

class _HandFanState extends State<_HandFan>
    with SingleTickerProviderStateMixin {
  late final AnimationController _deal;

  @override
  void initState() {
    super.initState();
    _deal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant _HandFan oldWidget) {
    super.didUpdateWidget(oldWidget);
    final before = oldWidget.cards.map((c) => c.id).join('|');
    final after = widget.cards.map((c) => c.id).join('|');
    if (before != after) {
      _deal
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _deal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return Center(
        child: Text(
          'Mão vazia — encerre o turno para comprar novas cartas.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 12,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight - 8;
        final width = height / 1.42;
        final available = constraints.maxWidth - 16;
        final count = widget.cards.length;
        final overlapStep = count <= 1
            ? 0.0
            : ((available - width) / (count - 1))
                  .clamp(width * 0.42, width * 0.88)
                  .toDouble();
        final total = width + overlapStep * (count - 1);
        final start = (constraints.maxWidth - total) / 2;

        // Só 40% da carta aparece na base; ao tocar, ela sobe inteira.
        final restTop = constraints.maxHeight - height * 0.4;
        final liftedTop = 6.0;

        final lifted = [
          for (final id in widget.liftedIds)
            if (id != widget.focusedId) id,
          if (widget.focusedId != null) widget.focusedId!,
        ];
        final order = <int>[
          for (var i = 0; i < count; i++)
            if (!widget.liftedIds.contains(widget.cards[i].id)) i,
          for (final id in lifted)
            for (var i = 0; i < count; i++)
              if (widget.cards[i].id == id) i,
        ];

        // Recorta as cartas em repouso na base da faixa, para que o corte
        // fique limpo dentro da tela em vez de encostar na borda do app.
        return ClipRect(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (widget.liftedIds.isEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'SUA MÃO · toque para revelar · duplo toque joga o conjunto',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 9,
                        letterSpacing: 0.9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              for (final i in order)
                _buildCard(
                  i,
                  start + overlapStep * i,
                  width,
                  restTop: restTop,
                  liftedTop: liftedTop,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(
    int index,
    double left,
    double width, {
    required double restTop,
    required double liftedTop,
  }) {
    final card = widget.cards[index];
    final selected = widget.liftedIds.contains(card.id);
    final playable = card.cost <= widget.energy;
    final begin = (index * 0.06).clamp(0.0, 0.4).toDouble();
    final animation = CurvedAnimation(
      parent: _deal,
      curve: Interval(begin, 1, curve: Curves.easeOutCubic),
    );

    return AnimatedPositioned(
      key: ValueKey(card.id),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      left: left,
      top: selected ? liftedTop : restTop,
      width: width,
      height: width * 1.42,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.55),
            end: Offset.zero,
          ).animate(animation),
          child: Builder(
            builder: (cardContext) => ArgumentCardView(
              card: card,
              width: width,
              selected: selected,
              playable: playable && widget.enabled,
              dimmed: !playable,
              onTap: widget.enabled
                  ? () {
                      final box = cardContext.findRenderObject() as RenderBox?;
                      final rect = box == null || !box.hasSize
                          ? null
                          : box.localToGlobal(Offset.zero) & box.size;
                      widget.onTap(card, rect);
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Carta jogada voando da mão até a objeção no centro da mesa. Ao pousar,
/// encolhe e some, como se fosse inserida no campo de batalha.
class _CardInsertion extends StatefulWidget {
  const _CardInsertion({
    required this.card,
    required this.from,
    required this.to,
    required this.onDone,
  });

  final ArgumentCard card;
  final Rect from;
  final Rect to;
  final VoidCallback onDone;

  @override
  State<_CardInsertion> createState() => _CardInsertionState();
}

class _CardInsertionState extends State<_CardInsertion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeInOutCubic.transform(_controller.value);
          final center = Offset.lerp(widget.from.center, widget.to.center, t)!;
          final scale = 1 - 0.4 * t;
          final fadeStart = 0.82;
          final opacity = _controller.value < fadeStart
              ? 1.0
              : (1 - _controller.value) / (1 - fadeStart);
          final width = widget.from.width;

          return Stack(
            children: [
              Positioned(
                left: center.dx - width / 2,
                top: center.dy - (width * 1.42) / 2,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.rotate(
                    angle: -0.06 * (1 - t),
                    child: Transform.scale(scale: scale, child: child),
                  ),
                ),
              ),
            ],
          );
        },
        child: ArgumentCardView(
          card: widget.card,
          width: widget.from.width,
          playable: true,
        ),
      ),
    );
  }
}

class _PlayedBanner extends StatelessWidget {
  const _PlayedBanner({required this.cards});

  final List<ArgumentCard> cards;

  @override
  Widget build(BuildContext context) {
    final card = cards.first;
    final title = cards.map((c) => c.title).join(' + ');
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Opacity(
        opacity: value.clamp(0, 1),
        child: Transform.scale(scale: 0.9 + value * 0.1, child: child),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: card.color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(card.icon, size: 16, color: Colors.white),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (cards.length > 1) ...[
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '${cards.length} cartas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FloatingDamage extends StatelessWidget {
  const _FloatingDamage({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1600),
      builder: (context, t, child) => Opacity(
        opacity: (1 - t).clamp(0, 1),
        child: Transform.translate(
          offset: Offset(0, -34 * t),
          child: Transform.scale(scale: 0.8 + 0.5 * t, child: child),
        ),
      ),
      child: Text(
        '-$value',
        style: const TextStyle(
          color: Color(0xFFFF9A9A),
          fontSize: 30,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
        ),
      ),
    );
  }
}

class _MachineThinking extends StatelessWidget {
  const _MachineThinking();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 7),
          Text(
            'A tese responde...',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------- relatório

class _BattleReportOverlay extends StatelessWidget {
  const _BattleReportOverlay({
    required this.config,
    required this.engine,
    required this.newCards,
    required this.onContinue,
    required this.onRetry,
    required this.onTheory,
  });

  final BattleConfig config;
  final BattleEngine engine;
  final List<ArgumentCard> newCards;
  final VoidCallback onContinue;
  final VoidCallback onRetry;
  final VoidCallback? onTheory;

  @override
  Widget build(BuildContext context) {
    final won = engine.isVictory;
    final study = caseById(config.caseId);
    Choice? correct;
    if (study != null) {
      for (final choice in study.choices) {
        if (choice.correct) {
          correct = choice;
          break;
        }
      }
    }
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withValues(alpha: 0.62),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 560),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: won ? AppColors.tealText : AppColors.crimsonText,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: Row(
                  children: [
                    Icon(
                      won ? Icons.emoji_events_outlined : Icons.gavel,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            won ? 'Batalha vencida!' : 'A tese prevaleceu',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            won
                                ? 'A convicção da tese chegou a zero.'
                                : 'Sua convicção chegou a zero. Não há punição: '
                                      'reveja o fundamento e retome.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _ReportStat(label: 'Turnos', value: '${engine.turn}'),
                          _ReportStat(
                            label: 'Objeções refutadas',
                            value: '${engine.refutations}',
                          ),
                          _ReportStat(
                            label: 'Cartas jogadas',
                            value: '${engine.cardsPlayed}',
                          ),
                          _ReportStat(
                            label: 'Convicção restante',
                            value: '${engine.playerConviction}',
                          ),
                        ],
                      ),
                      if (won && study != null && correct != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Parecer do gabinete · ${study.number}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Alternativa ${correct.id}: ${correct.text}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.tealText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        for (final paragraph in correct.feedback)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              paragraph,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        if (correct.note != null) ...[
                          const SizedBox(height: 4),
                          _InlineNote(note: correct.note!),
                        ],
                      ],
                      if (!won) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.goldSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.goldText,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  engine.objection == null
                                      ? 'Encerre o turno com a objeção refutada '
                                            'para não sofrer dano.'
                                      : 'A próxima objeção pede um fundamento de '
                                            '"${engine.objection!.counterHint}". '
                                            'Guarde uma carta com essa tag.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.goldText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (won && newCards.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          'NOVAS CARTAS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final card in newCards)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: card.soft,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: card.color.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      card.icon,
                                      size: 12,
                                      color: card.color,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      card.title,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: card.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!won && onTheory != null) ...[
                      OutlinedButton.icon(
                        onPressed: onTheory,
                        icon: const Icon(Icons.menu_book_outlined, size: 18),
                        label: const Text('Rever a teoria'),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (!won)
                      FilledButton.icon(
                        onPressed: onRetry,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.crimsonText,
                        ),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retomar batalha'),
                      )
                    else
                      FilledButton.icon(
                        onPressed: onContinue,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.tealText,
                        ),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: Text(
                          config.id == 'battle5'
                              ? 'Ir para o caso 6'
                              : 'Continuar a jornada',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  const _ReportStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.indigoSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.indigoText,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.indigoText),
          ),
        ],
      ),
    );
  }
}

class _InlineNote extends StatelessWidget {
  const _InlineNote({required this.note});

  final InfoBox note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.title != null)
            Text(
              note.title!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.goldText,
                fontWeight: FontWeight.w800,
              ),
            ),
          if (note.text != null)
            Text(note.text!, style: theme.textTheme.bodySmall),
          for (final bullet in note.bullets)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text('• $bullet', style: theme.textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}

/// Fala do Guia durante a partida de exemplo: texto e botão de avanço.
class _GuidePanel extends StatelessWidget {
  const _GuidePanel({
    required this.text,
    required this.action,
    required this.enabled,
    required this.onNext,
  });

  final String text;
  final String action;
  final bool enabled;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.55)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 19,
              color: AppColors.goldText,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                height: 1.3,
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 32,
            child: FilledButton(
              onPressed: enabled ? onNext : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor: AppColors.goldText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                action,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
