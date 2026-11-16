import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

const Color _decreeRed = Color(0xFF571A13);
const Color _decreeRedDeep = Color(0xFF3D100C);
const Color _decreeCream = Color(0xFFF6E8DA);

/// Bad ending do chat do Ministro: o decreto de exoneração.
///
/// A tela ocupa o lugar do chat e só oferece o reinício do treinamento.
class ExonerationScreen extends StatelessWidget {
  const ExonerationScreen({super.key, required this.onRestart});

  final Future<void> Function() onRestart;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: _decreeRed,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _decreeRedDeep,
                        border: Border.all(
                          color: _decreeCream.withValues(alpha: 0.28),
                        ),
                      ),
                      child: const Icon(
                        Icons.gavel_rounded,
                        size: 40,
                        color: _decreeCream,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'BAD ENDING · EXPEDIENTE ENCERRADO',
                      textAlign: TextAlign.center,
                      style: AppTheme.overline.copyWith(
                        fontSize: 9,
                        letterSpacing: 2,
                        color: _decreeCream.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'DECRETO DE\nEXONERAÇÃO 📜❌',
                      textAlign: TextAlign.center,
                      style: AppTheme.displayTitle.copyWith(
                        fontSize: 40,
                        height: 1.08,
                        color: _decreeCream,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'O erro comprometeu a reputação do Ministro no Plenário. O gabinete não pode mais contar com você.',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyMuted.copyWith(
                        fontSize: 14.5,
                        height: 1.55,
                        color: _decreeCream.withValues(alpha: 0.82),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      decoration: BoxDecoration(
                        color: _decreeRedDeep.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _decreeCream.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '“Mais um deslize desses e você será exonerado hoje mesmo.”',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.headingFont,
                              fontSize: 16.5,
                              height: 1.4,
                              fontStyle: FontStyle.italic,
                              color: _decreeCream,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '— MINISTRO',
                            style: AppTheme.overline.copyWith(
                              fontSize: 8.5,
                              letterSpacing: 1.8,
                              color: _decreeCream.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.trending_down_rounded,
                          size: 18,
                          color: _decreeCream,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PRESTÍGIO NO GABINETE  0%',
                          style: AppTheme.overline.copyWith(
                            fontSize: 9,
                            letterSpacing: 1.6,
                            color: _decreeCream,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: _decreeCream,
                          foregroundColor: _decreeRedDeep,
                        ),
                        onPressed: () => onRestart(),
                        child: const Text(
                          'Refazer Treinamento (Voltar ao Grupo 1)',
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'O treinamento recomeça no Grupo do Gabinete.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.3,
                        color: _decreeCream.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
