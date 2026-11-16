import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Modal que bloqueia o chat quando as xícaras acabam.
///
/// Retorna `true` quando o jogador escolhe recarregar (e revisar a Sala de
/// Dúvidas). Não pode ser fechado pelo fundo: só pelo botão.
Future<bool> showCoffeeBlockedDialog(BuildContext context) async {
  final bool? reload = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        child: PopScope(
          canPop: false,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.terracottaWash,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.coffee_rounded,
                      size: 30,
                      color: AppColors.terracottaDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('EXPEDIENTE PAUSADO', style: AppTheme.overline),
                  const SizedBox(height: 10),
                  Text(
                    'Seu cérebro travou!',
                    textAlign: TextAlign.center,
                    style: AppTheme.sheetTitle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tome um café e revise o resumo do grupo antes de continuar.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMuted.copyWith(
                      color: AppColors.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('Recarregar Cafés (Revisar)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return reload ?? false;
}
