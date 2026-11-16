import 'package:flutter/material.dart';

import '../state/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Folha exibida quando uma fase termina (ou é revisitada).
Future<void> showStageCompletionSheet(
  BuildContext context,
  StageCompletion completion,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 560),
    barrierColor: AppColors.ink.withValues(alpha: 0.38),
    builder: (BuildContext context) =>
        _StageCompletionSheet(completion: completion),
  );
}

class _StageCompletionSheet extends StatelessWidget {
  const _StageCompletionSheet({required this.completion});

  final StageCompletion completion;

  @override
  Widget build(BuildContext context) {
    final bool replay = completion.isReplay;
    final bool quiz = completion.isQuiz && !replay;
    final bool finale = completion.isFinale;
    final int correct = completion.correctAnswers;
    final int total = completion.answeredQuestions;

    final String overline;
    final String title;
    final String body;
    final IconData icon;

    if (quiz) {
      overline = 'DIAGNÓSTICO DO GABINETE';
      if (correct == total) {
        title = 'Gabinete aprovado';
        body = 'Você domina mutação constitucional. Releia o debate da segunda instância e forme sua opinião.';
        icon = Icons.workspace_premium_outlined;
      } else if (correct >= 3) {
        title = 'Bom trabalho, quase lá';
        body = 'Revise a triagem do Caso 2 e os limites da mutação antes de sustentar uma tese.';
        icon = Icons.fact_check_outlined;
      } else {
        title = 'Segunda análise';
        body = 'O ministro pediu uma segunda análise. Refaça a jornada com atenção às telas de teoria.';
        icon = Icons.replay_rounded;
      }
    } else if (finale) {
      overline = 'FIM DA TEMPORADA';
      title = 'Expediente encerrado';
      body = 'Você chegou ao fim da jornada no gabinete. A Constituição continua a mesma — e o sentido, em movimento.';
      icon = Icons.local_florist_outlined;
    } else if (replay) {
      overline = 'RELEITURA';
      title = 'Conversa revisitada';
      body = 'Essa fase já estava concluída. Nada mudou no seu progresso, mas a conversa continua aqui quando quiser voltar.';
      icon = Icons.replay_rounded;
    } else {
      overline = 'FASE CONCLUÍDA';
      title = 'Conversa concluída';
      body = completion.nextContact != null
          ? '“${completion.nextContact!.name}” foi desbloqueado. Abra a nova conversa quando quiser.'
          : 'Seu progresso foi salvo.';
      icon = Icons.lock_open_rounded;
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 26),
            Container(
              width: 66,
              height: 66,
              decoration: const BoxDecoration(
                color: AppColors.terracottaWash,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 27, color: AppColors.terracottaDark),
            ),
            const SizedBox(height: 22),
            Text(overline, style: AppTheme.overline),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.sheetTitle,
            ),
            if (quiz) ...<Widget>[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    '$correct',
                    style: const TextStyle(
                      fontFamily: AppTheme.headingFont,
                      fontSize: 40,
                      height: 1,
                      fontWeight: FontWeight.w500,
                      color: AppColors.terracotta,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ $total acertos',
                    style: AppTheme.bodyMuted.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTheme.bodyMuted.copyWith(color: AppColors.inkSoft),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Voltar para as conversas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
