import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Mapa mental interativo, disponível fora da jornada.
///
/// Cada ramo abre um resumo curto e uma pergunta de fixação. A ideia é dar ao
/// estudante uma parada rápida para revisar mutação constitucional sem
/// reiniciar a explicação nem a batalha.
class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  String _selectedId = 'centro';
  bool _answerVisible = false;

  _MapNode get _selected => _nodes.firstWhere((node) => node.id == _selectedId);

  void _select(String id) {
    setState(() {
      _selectedId = id;
      _answerVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 6, 12, 8),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Voltar',
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'MAPA MENTAL · FIXAÇÃO',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w900,
                            color: AppColors.goldText,
                          ),
                        ),
                        Text(
                          'Mutação constitucional',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 14,
                          color: AppColors.tealText,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Toque nos ramos',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.tealText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF6F1E6), AppColors.surface],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: _canvasWidth,
                      height: _canvasHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _MapLinesPainter(
                                selectedId: _selectedId,
                              ),
                            ),
                          ),
                          for (final node in _nodes)
                            Positioned(
                              left: node.left,
                              top: node.top,
                              width: node.width,
                              height: node.height,
                              child: _MapNodeCard(
                                node: node,
                                selected: node.id == _selectedId,
                                onTap: () => _select(node.id),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _selected.color.withValues(alpha: 0.35),
                  ),
                ),
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Column(
                      key: ValueKey(_selectedId),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _selected.icon,
                              size: 19,
                              color: _selected.color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selected.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: _selected.color,
                                ),
                              ),
                            ),
                            if (_selected.id != 'centro')
                              TextButton(
                                onPressed: () => _select('centro'),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 32),
                                  foregroundColor: AppColors.ink,
                                ),
                                child: const Text(
                                  'Voltar ao centro',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selected.summary,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final bullet in _selected.bullets)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _selected.color.withValues(
                                    alpha: 0.09,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selected.color.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  bullet,
                                  style: TextStyle(
                                    fontSize: 11,
                                    height: 1.3,
                                    fontWeight: FontWeight.w700,
                                    color: _selected.color,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.goldSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.help_outline_rounded,
                                    size: 16,
                                    color: AppColors.goldText,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      _selected.question,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.goldText,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              if (_answerVisible)
                                Text(
                                  _selected.answer,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    height: 1.4,
                                  ),
                                )
                              else
                                TextButton.icon(
                                  onPressed: () =>
                                      setState(() => _answerVisible = true),
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size(0, 32),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    foregroundColor: AppColors.goldText,
                                  ),
                                  icon: const Icon(
                                    Icons.visibility_outlined,
                                    size: 15,
                                  ),
                                  label: const Text(
                                    'Ver resposta',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const double _canvasWidth = 1040;
const double _canvasHeight = 600;

class _MapNode {
  const _MapNode({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.summary,
    required this.bullets,
    required this.question,
    required this.answer,
    this.center = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double left;
  final double top;
  final double width;
  final double height;
  final String summary;
  final List<String> bullets;
  final String question;
  final String answer;
  final bool center;

  Offset get anchor => Offset(left + width / 2, top + height / 2);
}

const List<_MapNode> _nodes = [
  _MapNode(
    id: 'centro',
    title: 'Mutação constitucional',
    subtitle: 'o sentido muda, o texto não',
    icon: Icons.account_balance_rounded,
    color: AppColors.navy,
    left: 400,
    top: 245,
    width: 240,
    height: 115,
    center: true,
    summary:
        'Mudança informal do sentido, do significado ou do alcance da norma '
        'constitucional, sem alteração de uma palavra do texto.',
    bullets: ['Texto igual', 'Sentido novo', 'Sem emenda'],
    question: 'Qual é a diferença central entre texto e norma?',
    answer:
        'O texto é o enunciado; a norma é o sentido que se extrai dele quando '
        'é interpretado diante de um caso concreto.',
  ),
  _MapNode(
    id: 'texto-norma',
    title: 'Texto × norma',
    subtitle: 'a distância que permite a mutação',
    icon: Icons.menu_book_outlined,
    color: AppColors.teal,
    left: 30,
    top: 25,
    width: 230,
    height: 105,
    summary:
        'A partitura não é a música. O mesmo texto pode gerar normas diferentes '
        'ao longo do tempo.',
    bullets: ['Müller', 'Concretização', 'Princípios abrem espaço'],
    question: 'Se o texto não mudou, o que mudou no Caso 1?',
    answer:
        'Mudou o sentido atribuído ao texto: o art. 226, § 3º, passou a ser '
        'lido junto com dignidade, igualdade e proibição de discriminação.',
  ),
  _MapNode(
    id: 'comparacao',
    title: 'Reforma × mutação',
    subtitle: 'não confunda os caminhos',
    icon: Icons.compare_arrows_rounded,
    color: AppColors.plum,
    left: 780,
    top: 25,
    width: 230,
    height: 105,
    summary:
        'Reforma altera o texto pela via formal do art. 60. Mutação altera o '
        'sentido, com o texto intacto. Interpretação comum só aplica o sentido '
        'já aceito.',
    bullets: [
      'Reforma = emenda',
      'Mutação = informal',
      'Interpretação = aplicação',
    ],
    question: 'Emenda constitucional é meio de mutação?',
    answer:
        'Não. A emenda altera o texto, por isso é reforma. Mutação é informal e '
        'preserva o texto.',
  ),
  _MapNode(
    id: 'meios',
    title: 'Meios da mutação',
    subtitle: 'quem movimenta o sentido',
    icon: Icons.alt_route_rounded,
    color: AppColors.gold,
    left: 30,
    top: 250,
    width: 210,
    height: 105,
    summary:
        'A mutação não é exclusividade do STF: juízes, Legislativo, Executivo e '
        'a sociedade participam da mudança de sentido.',
    bullets: ['Judicial', 'Legislativa', 'Costume'],
    question: 'Qual é o meio mais estudado no Brasil?',
    answer:
        'A interpretação judicial: o tribunal passa a ler o mesmo dispositivo '
        'de outro modo, como na ADPF 132 / ADI 4277.',
  ),
  _MapNode(
    id: 'limites',
    title: 'Limites',
    subtitle: 'interpretar não é usurpar',
    icon: Icons.shield_outlined,
    color: AppColors.indigo,
    left: 810,
    top: 250,
    width: 200,
    height: 105,
    summary:
        'A mutação é legítima apenas dentro das possibilidades do texto e do '
        'espírito da Constituição.',
    bullets: ['Texto', 'Cláusulas pétreas', 'Separação de Poderes'],
    question: 'Texto igual basta para a mutação ser válida?',
    answer:
        'Não. O novo sentido precisa caber nas palavras e respeitar os '
        'princípios fundamentais e as cláusulas pétreas.',
  ),
  _MapNode(
    id: 'inconstitucional',
    title: 'Mutação inconstitucional',
    subtitle: 'quando o sentido contraria o texto',
    icon: Icons.block_rounded,
    color: AppColors.crimson,
    left: 150,
    top: 470,
    width: 270,
    height: 105,
    summary:
        'É a mudança informal que ultrapassa os limites: o texto continua '
        'igual, mas o sentido atribuído o contraria ou atinge cláusula pétrea.',
    bullets: ['“Secreto” ≠ “identificado”', 'Voto secreto', 'Cláusula pétrea'],
    question: 'O “voto secreto” pode virar “voto identificado” por mutação?',
    answer:
        'Não. “Secreto” e “identificado” são sentidos opostos; além disso, o '
        'voto secreto é cláusula pétrea (art. 60, § 4º, II).',
  ),
  _MapNode(
    id: 'casos',
    title: 'Casos para lembrar',
    subtitle: 'a teoria aplicada',
    icon: Icons.gavel_rounded,
    color: AppColors.tealText,
    left: 640,
    top: 470,
    width: 270,
    height: 105,
    summary:
        'Os precedentes mostram o potencial e o risco da mutação: mudar o '
        'sentido pode incluir, mas também pode usurpar.',
    bullets: ['ADPF 132 / ADI 4277', 'Rcl 4335', '2ª instância'],
    question: 'O que a Rcl 4335 debateu?',
    answer:
        'A tese de mutação do art. 52, X: a decisão do Plenário já valeria para '
        'todos e o Senado apenas daria publicidade. A tese não formou maioria.',
  ),
];

class _MapNodeCard extends StatelessWidget {
  const _MapNodeCard({
    required this.node,
    required this.selected,
    required this.onTap,
  });

  final _MapNode node;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = node.center;
    final foreground = dark ? Colors.white : AppColors.ink;
    return Semantics(
      button: true,
      selected: selected,
      label: '${node.title}. ${node.subtitle}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              gradient: dark
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.navy, Color(0xFF0C2230)],
                    )
                  : null,
              color: dark ? null : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? AppColors.gold
                    : node.color.withValues(alpha: 0.45),
                width: selected ? 2.4 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: node.color.withValues(alpha: selected ? 0.24 : 0.1),
                  blurRadius: selected ? 16 : 6,
                  offset: Offset(0, selected ? 6 : 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(node.icon, size: 18, color: node.color),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        node.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: node.center ? 16 : 13,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: dark ? Colors.white : node.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  node.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: node.center ? 11 : 10,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: foreground.withValues(alpha: dark ? 0.78 : 0.62),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapLinesPainter extends CustomPainter {
  _MapLinesPainter({required this.selectedId});

  final String selectedId;

  @override
  void paint(Canvas canvas, Size size) {
    final center = _nodes.firstWhere((node) => node.center);
    final centerAnchor = center.anchor;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    for (final node in _nodes.where((node) => !node.center)) {
      final active = node.id == selectedId;
      line.color = active
          ? AppColors.gold.withValues(alpha: 0.85)
          : node.color.withValues(alpha: 0.35);
      line.strokeWidth = active ? 3.2 : 2;

      // Sai da borda do cartão central em direção ao ramo.
      final delta = node.anchor - centerAnchor;
      final start = _edgePoint(center, delta);
      final end = node.anchor;
      final path = Path()..moveTo(start.dx, start.dy);
      final midX = (start.dx + end.dx) / 2;
      path.cubicTo(midX, start.dy, midX, end.dy, end.dx, end.dy);
      canvas.drawPath(path, line);

      final dot = Paint()..color = line.color;
      canvas.drawCircle(end, active ? 5 : 3.2, dot);
      canvas.drawCircle(start, 2.4, dot);
    }

    // Anel suave ao redor do centro.
    final halo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = AppColors.gold.withValues(alpha: 0.08);
    canvas.drawCircle(
      centerAnchor,
      math.min(center.width, center.height) * 0.62,
      halo,
    );
  }

  Offset _edgePoint(_MapNode node, Offset delta) {
    final halfW = node.width / 2;
    final halfH = node.height / 2;
    if (delta.dx == 0) return node.anchor + Offset(0, delta.dy.sign * halfH);
    final scaleX = halfW / delta.dx.abs();
    final scaleY = halfH / delta.dy.abs();
    final scale = math.min(scaleX, scaleY);
    return node.anchor + delta * scale;
  }

  @override
  bool shouldRepaint(covariant _MapLinesPainter oldDelegate) =>
      oldDelegate.selectedId != selectedId;
}
