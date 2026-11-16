import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/chat_script.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

const Color _success = Color(0xFF4F7A52);
const Color _danger = Color(0xFFB1462C);
const Color _successWash = Color(0xFFE7EFE3);
const Color _dangerWash = Color(0xFFF5E2DA);

enum _CardResult { none, correct, wrong, timeout }

/// Carta jurídica com cronômetro configurável e três classificações.
///
/// Fica no centro da conversa. Fecha sozinha quando o tempo acaba ou quando o
/// jogador escolhe uma opção, avisando o controlador.
class CardChallengePanel extends StatefulWidget {
  const CardChallengePanel({
    super.key,
    required this.card,
    required this.choices,
    required this.enabled,
    required this.onAnswer,
    required this.onTimeout,
  });

  final CardChallenge card;
  final List<ChatChoice> choices;
  final bool enabled;
  final ValueChanged<ChatChoice> onAnswer;
  final VoidCallback onTimeout;

  @override
  State<CardChallengePanel> createState() => _CardChallengePanelState();
}

class _CardChallengePanelState extends State<CardChallengePanel>
    with TickerProviderStateMixin {
  late final AnimationController _timer = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget.card.seconds),
  )..addListener(_onTick);

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );
  _CardResult _result = _CardResult.none;

  double get _remaining => widget.card.seconds * (1 - _timer.value);

  @override
  void initState() {
    super.initState();
    _timer.addStatusListener(_onTimerStatus);
    if (widget.enabled) _startTimer();
  }

  @override
  void didUpdateWidget(CardChallengePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card != widget.card) {
      _timer.stop();
      _timer.duration = Duration(seconds: widget.card.seconds);
      _timer.reset();
      _result = _CardResult.none;
      if (widget.enabled) _startTimer();
    } else if (!oldWidget.enabled && widget.enabled) {
      _startTimer();
    } else if (oldWidget.enabled && !widget.enabled) {
      _timer.stop();
    }
  }

  @override
  void dispose() {
    _timer
      ..removeListener(_onTick)
      ..removeStatusListener(_onTimerStatus)
      ..dispose();
    _shake.dispose();
    super.dispose();
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  void _onTimerStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _timeout();
  }

  void _startTimer() {
    if (_result != _CardResult.none) return;
    // Usa um AnimationController em vez de Timer: com TickerMode desligado
    // (rota em segundo plano), o cronômetro pausa sozinho.
    if (_timer.isAnimating || _timer.value >= 1) return;
    _timer.forward();
  }

  void _timeout() {
    if (_result != _CardResult.none) return;
    setState(() => _result = _CardResult.timeout);
    _shake.forward(from: 0);
    Future<void>.delayed(const Duration(milliseconds: 680), () {
      if (mounted) widget.onTimeout();
    });
  }

  void _pick(ChatChoice choice) {
    if (_result != _CardResult.none || !widget.enabled) return;
    _timer.stop();
    final bool correct = choice.isCorrect == true;
    setState(() {
      _result = correct ? _CardResult.correct : _CardResult.wrong;
    });
    if (!correct) _shake.forward(from: 0);
    Future<void>.delayed(const Duration(milliseconds: 680), () {
      if (mounted) widget.onAnswer(choice);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool success = _result == _CardResult.correct;
    final bool failure =
        _result == _CardResult.wrong || _result == _CardResult.timeout;
    final Color accent = success
        ? _success
        : failure
        ? _danger
        : AppColors.line;
    final Color glow = success
        ? _success.withValues(alpha: 0.30)
        : failure
        ? _danger.withValues(alpha: 0.22)
        : AppColors.ink.withValues(alpha: 0.06);

    final Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: success
            ? _successWash
            : failure
            ? _dangerWash
            : AppColors.paper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: success || failure ? accent : AppColors.line,
          width: success || failure ? 1.6 : 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: glow,
            blurRadius: success ? 22 : 12,
            spreadRadius: success ? 3 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.style_rounded,
                size: 15,
                color: AppColors.terracottaDark,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'CARTA ${widget.card.index.toString().padLeft(2, '0')} DE ${widget.card.total.toString().padLeft(2, '0')}',
                  style: AppTheme.overline.copyWith(
                    fontSize: 8.5,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              _TimerChip(
                seconds: _remaining.ceil().clamp(0, widget.card.seconds),
                danger: _remaining <= 3,
              ),
            ],
          ),
          const SizedBox(height: 11),
          _TimerBar(
            ratio: (widget.card.seconds == 0)
                ? 0
                : _remaining / widget.card.seconds,
            danger: _remaining <= 3,
          ),
          const SizedBox(height: 16),
          Text(
            widget.card.situation,
            style: AppTheme.name.copyWith(fontSize: 17, height: 1.35),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < widget.choices.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
              child: _OptionButton(
                label: widget.choices[i].label,
                onTap: widget.enabled && _result == _CardResult.none
                    ? () => _pick(widget.choices[i])
                    : null,
                accent: success || failure ? accent : null,
              ),
            ),
          const SizedBox(height: 12),
          _ResultLine(result: _result, enabled: widget.enabled),
        ],
      ),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 14),
        child: AnimatedBuilder(
          animation: _shake,
          builder: (BuildContext context, Widget? child) {
            final double t = _shake.value;
            return Transform.translate(
              offset: Offset(math.sin(t * math.pi * 7) * 8 * (1 - t), 0),
              child: child,
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: Transform.scale(
                    scale: 0.96,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.paperDeep,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.line),
                      ),
                    ),
                  ),
                ),
              ),
              card,
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.seconds, required this.danger});

  final int seconds;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: danger ? _dangerWash : AppColors.paperDeep,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.timer_outlined,
            size: 13,
            color: danger ? _danger : AppColors.terracottaDark,
          ),
          const SizedBox(width: 4),
          Text(
            '${seconds}s',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: danger ? _danger : AppColors.terracottaDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  const _TimerBar({required this.ratio, required this.danger});

  final double ratio;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) {
          return Stack(
            children: <Widget>[
              Container(height: 6, color: AppColors.paperDeep),
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.linear,
                width: box.maxWidth * ratio.clamp(0, 1),
                height: 6,
                color: danger ? _danger : AppColors.terracotta,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({required this.label, this.onTap, this.accent});

  final String label;
  final VoidCallback? onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paper,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: accent ?? AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.bubble.copyWith(fontSize: 14, height: 1.3),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.north_east_rounded,
                size: 14,
                color: onTap == null
                    ? AppColors.muted.withValues(alpha: 0.5)
                    : AppColors.terracotta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.result, required this.enabled});

  final _CardResult result;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final (Color color, String text, IconData icon) = switch (result) {
      _CardResult.correct => (
        _success,
        'ACERTOU! Já anexei no processo.',
        Icons.check_circle_outline_rounded,
      ),
      _CardResult.wrong => (
        _danger,
        'ERROU! Bruno vai explicar.',
        Icons.error_outline_rounded,
      ),
      _CardResult.timeout => (
        _danger,
        'TEMPO ESGOTADO!',
        Icons.timer_off_outlined,
      ),
      _CardResult.none when !enabled => (
        AppColors.muted,
        'Sem cafés. Revise a Sala de Dúvidas.',
        Icons.coffee_rounded,
      ),
      _CardResult.none => (
        AppColors.muted,
        'Classifique antes do tempo acabar.',
        Icons.touch_app_outlined,
      ),
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.25,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
