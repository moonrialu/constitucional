import 'dart:math';

import '../data/cards.dart';
import '../models/battle.dart';
import '../models/card.dart';

/// Resultado de uma jogada (uma carta ou um conjunto de resposta), usado pela
/// interface para animar e narrar.
class PlayOutcome {
  const PlayOutcome({
    required this.cards,
    required this.refuted,
    required this.damage,
    required this.block,
    required this.drawn,
    required this.energyGained,
  });

  final List<ArgumentCard> cards;
  final bool refuted;
  final int damage;
  final int block;
  final int drawn;
  final int energyGained;

  ArgumentCard get card => cards.first;
  int get totalCost => cards.fold(0, (sum, c) => sum + c.cost);
}

/// Motor puro da batalha de cartas. Não conhece Flutter: recebe um `Random`
/// injetável e pode ser testado com sementes fixas.
class BattleEngine {
  BattleEngine({required this.config, Random? random})
    : _random = random ?? Random() {
    _playerMax = config.playerConviction;
    _machineMax = config.machineConviction;
    reset();
  }

  final BattleConfig config;
  final Random _random;

  late final int _playerMax;
  late final int _machineMax;

  final List<ArgumentCard> _drawPile = [];
  final List<ArgumentCard> _discardPile = [];
  final List<ArgumentCard> _hand = [];
  final List<BattleLogEntry> _log = [];

  int _playerConviction = 0;
  int _machineConviction = 0;
  int _energy = 0;
  int _block = 0;
  int _turn = 1;
  int _objectionIndex = 0;
  int _objectionCycle = 0;
  int _cardsPlayed = 0;
  int _refutations = 0;
  bool _refuted = false;
  BattlePhase _phase = BattlePhase.playerTurn;

  // ------------------------------------------------------------- leitura

  int get playerMax => _playerMax;
  int get machineMax => _machineMax;
  int get playerConviction => _playerConviction;
  int get machineConviction => _machineConviction;
  int get energy => _energy;
  int get maxEnergy => config.energyPerTurn;
  int get block => _block;
  int get turn => _turn;
  int get cardsPlayed => _cardsPlayed;
  int get refutations => _refutations;
  bool get refuted => _refuted;
  BattlePhase get phase => _phase;
  bool get isOver => _phase == BattlePhase.won || _phase == BattlePhase.lost;
  bool get isVictory => _phase == BattlePhase.won;

  List<ArgumentCard> get hand => List.unmodifiable(_hand);
  List<ArgumentCard> get drawPile => List.unmodifiable(_drawPile);
  List<ArgumentCard> get discardPile => List.unmodifiable(_discardPile);
  List<BattleLogEntry> get log => List.unmodifiable(_log);

  Objection? get objection {
    if (config.objections.isEmpty) return null;
    return config.objections[_objectionIndex % config.objections.length];
  }

  /// Dano que a objeção causaria se não fosse refutada neste turno.
  int get incomingDamage {
    final current = objection;
    if (current == null || _refuted) return 0;
    return current.damage + _objectionCycle;
  }

  bool canPlay(ArgumentCard card) =>
      _phase == BattlePhase.playerTurn &&
      _hand.any((c) => c.id == card.id) &&
      card.cost <= _energy;

  /// Custo total de um conjunto de resposta.
  int comboCost(Iterable<ArgumentCard> cards) =>
      cards.fold(0, (sum, card) => sum + card.cost);

  /// O conjunto é válido (cartas na mão, sem repetição) e cabe na energia?
  bool canPlayCombo(Iterable<ArgumentCard> cards) {
    if (_phase != BattlePhase.playerTurn) return false;
    final ids = <String>{};
    var cost = 0;
    for (final card in cards) {
      if (!ids.add(card.id)) return false;
      if (!_hand.any((c) => c.id == card.id)) return false;
      cost += card.cost;
    }
    return ids.isNotEmpty && cost <= _energy;
  }

  // -------------------------------------------------------------- turnos

  void reset() {
    _drawPile
      ..clear()
      ..addAll(config.deck.map(cardById).whereType<ArgumentCard>().toList());
    _drawPile.shuffle(_random);
    _discardPile.clear();
    _hand.clear();
    _log.clear();
    _playerConviction = _playerMax;
    _machineConviction = _machineMax;
    _energy = config.energyPerTurn;
    _block = 0;
    _turn = 1;
    _objectionIndex = 0;
    _objectionCycle = 0;
    _cardsPlayed = 0;
    _refutations = 0;
    _refuted = false;
    _phase = BattlePhase.playerTurn;
    _drawUpTo(config.handSize);
    _addLog('A sessão começou. ${config.opponentName} apresenta sua tese.');
  }

  /// Joga uma carta da mão. Devolve `null` se a jogada for inválida.
  PlayOutcome? playCard(ArgumentCard card) => playCombo([card]);

  /// Joga um conjunto de resposta: as cartas entram juntas no campo de
  /// batalha e os efeitos somam. A refutação vale uma única vez, com +3 de
  /// bônus para o efeito principal do conjunto.
  PlayOutcome? playCombo(List<ArgumentCard> cards) {
    if (!canPlayCombo(cards)) return null;

    final current = objection;
    final counters =
        !_refuted && current != null && cards.any(current.isCounteredBy);
    if (counters) {
      _refuted = true;
      _refutations++;
    }

    final bonus = counters ? 3 : 0;
    final damageBase = cards.fold(0, (sum, c) => sum + c.power);
    final blockBase = cards.fold(0, (sum, c) => sum + c.block);
    final drawBase = cards.fold(0, (sum, c) => sum + c.draw);
    final energyGained = cards.fold(0, (sum, c) => sum + c.energy);

    _energy -= comboCost(cards);

    var damage = damageBase;
    var gainedBlock = blockBase;
    var bonusDraw = 0;
    if (bonus > 0) {
      if (damageBase > 0) {
        damage += bonus;
      } else if (blockBase > 0) {
        gainedBlock += bonus;
      } else {
        bonusDraw = bonus;
      }
    }

    if (damage > 0) {
      _machineConviction = max(0, _machineConviction - damage);
    }
    if (gainedBlock > 0) _block += gainedBlock;
    if (energyGained > 0) _energy += energyGained;
    final drawn = _drawCards(drawBase + bonusDraw);

    final ids = cards.map((c) => c.id).toSet();
    _hand.removeWhere((c) => ids.contains(c.id));
    _cardsPlayed += cards.length;
    _discardPile.addAll(cards);

    final titles = cards.map((c) => c.title).join(' + ');
    if (cards.length == 1) {
      _addLog(
        counters
            ? '${cards.first.title}: objeção refutada!'
            : '${cards.first.title}: ${cards.first.effectLabel}.',
        kind: counters ? BattleLogKind.good : BattleLogKind.player,
      );
    } else {
      _addLog(
        counters
            ? 'Conjunto $titles: objeção refutada! $damage de dano.'
            : 'Conjunto $titles: $damage de dano, $gainedBlock de bloqueio.',
        kind: counters ? BattleLogKind.good : BattleLogKind.player,
      );
    }

    if (_machineConviction <= 0) {
      _phase = BattlePhase.won;
      _addLog(
        'A tese adversa foi vencida. Caso resolvido!',
        kind: BattleLogKind.good,
      );
    }

    return PlayOutcome(
      cards: List.unmodifiable(cards),
      refuted: counters,
      damage: damage,
      block: gainedBlock,
      drawn: drawn,
      energyGained: energyGained,
    );
  }

  /// Fecha o turno: a máquina ataca e um novo turno começa.
  void endTurn() {
    if (_phase != BattlePhase.playerTurn) return;

    _phase = BattlePhase.machineTurn;
    _addLog('Turno da tese adversa.', kind: BattleLogKind.machine);

    final current = objection;
    if (current != null) {
      if (_refuted) {
        _addLog(
          'Objeção refutada: "${_short(current.text)}" não causa dano.',
          kind: BattleLogKind.good,
        );
      } else {
        final raw = current.damage + _objectionCycle;
        final absorbed = min(_block, raw);
        final damage = raw - absorbed;
        _playerConviction = max(0, _playerConviction - damage);
        _block = 0;
        _addLog(
          absorbed > 0
              ? 'A tese ataca: $raw de dano, $absorbed bloqueado, $damage '
                    'atinge sua convicção.'
              : 'A tese ataca: $damage de dano na sua convicção.',
          kind: BattleLogKind.bad,
        );
      }
    }

    if (_playerConviction <= 0) {
      _phase = BattlePhase.lost;
      _addLog(
        'Sua convicção chegou a zero. Reveja o fundamento e retome a batalha.',
        kind: BattleLogKind.bad,
      );
      return;
    }

    // Próxima objeção, reiniciando o ciclo com um pouco mais de pressão.
    _objectionIndex++;
    if (config.objections.isNotEmpty &&
        _objectionIndex % config.objections.length == 0) {
      _objectionCycle++;
    }
    _refuted = false;
    _block = 0;
    _turn++;

    // Descarta a mão restante e compra uma nova.
    _discardPile.addAll(_hand);
    _hand.clear();
    _drawUpTo(config.handSize);
    _energy = config.energyPerTurn;
    _phase = BattlePhase.playerTurn;

    final next = objection;
    if (next != null) {
      _addLog(
        'Nova objeção: "${_short(next.text)}"',
        kind: BattleLogKind.machine,
      );
    }
  }

  /// Descarta a mão e compra de novo (usado ao retomar uma batalha perdida).
  void reshuffleHand() {
    if (_phase != BattlePhase.playerTurn) return;
    _discardPile.addAll(_hand);
    _hand.clear();
    _drawUpTo(config.handSize);
  }

  BattleRecord toRecord({required int attempts, required DateTime at}) {
    return BattleRecord(
      won: isVictory,
      attempts: attempts,
      turns: _turn,
      convictionLeft: _playerConviction,
      refutations: _refutations,
      cardsPlayed: _cardsPlayed,
      finishedAt: at,
    );
  }

  // ------------------------------------------------------------- internos

  int _drawCards(int count) {
    var drawn = 0;
    for (var i = 0; i < count; i++) {
      if (_drawPile.isEmpty) {
        if (_discardPile.isEmpty) break;
        _drawPile.addAll(_discardPile);
        _discardPile.clear();
        _drawPile.shuffle(_random);
      }
      if (_drawPile.isEmpty) break;
      _hand.add(_drawPile.removeLast());
      drawn++;
    }
    return drawn;
  }

  void _drawUpTo(int size) {
    while (_hand.length < size) {
      final before = _hand.length;
      _drawCards(1);
      if (_hand.length == before) break;
    }
  }

  void _addLog(String text, {BattleLogKind kind = BattleLogKind.neutral}) {
    _log.add(BattleLogEntry(text, kind: kind));
    if (_log.length > 40) _log.removeAt(0);
  }

  static String _short(String text) =>
      text.length <= 90 ? text : '${text.substring(0, 87)}...';
}
