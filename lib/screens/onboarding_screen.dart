import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/training_dialogue.dart';
import '../engine/mutation_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/mentor_avatar.dart';

/// Tela inicial de onboarding: guarda o nome e apresenta os mentores.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  /// Chamado depois de salvar o nome.
  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _name = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final current = context.read<MutationController>().userName;
    _name.text = current;
  }

  @override
  void dispose() {
    _name.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Digite um nome para o gabinete te chamar.');
      _focus.requestFocus();
      return;
    }
    if (name.length > 40) {
      setState(() => _error = 'Use um nome com até 40 caracteres.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    await context.read<MutationController>().setUserName(name);
    if (!mounted) return;
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navy, Color(0xFF091B28)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 760;
                    final intro = _Intro(theme: theme);
                    final form = _Form(
                      theme: theme,
                      name: _name,
                      focus: _focus,
                      error: _error,
                      saving: _saving,
                      onStart: _start,
                    );
                    if (!wide) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [intro, const SizedBox(height: 18), form],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 6, child: intro),
                        const SizedBox(width: 32),
                        Expanded(flex: 5, child: form),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'DIREITO CONSTITUCIONAL I · OVA 2.0',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w800,
            color: AppColors.gold.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Antes de assumir\no gabinete...',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontSize: 34,
            height: 1.05,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Seis mentores vão conduzir seu treinamento sobre mutação '
          'constitucional. A explicação vem primeiro; a prática vem depois.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final mentor in mutationMentors)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: mentorColor(mentor.id),
                      child: Text(
                        mentor.initials,
                        style: const TextStyle(
                          fontSize: 7,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mentor.name,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    required this.theme,
    required this.name,
    required this.focus,
    required this.error,
    required this.saving,
    required this.onStart,
  });

  final ThemeData theme;
  final TextEditingController name;
  final FocusNode focus;
  final String? error;
  final bool saving;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: AppColors.goldText,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identificação do gabinete',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      'O nome aparece nos diálogos com os mentores.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.ink.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: name,
            focusNode: focus,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            maxLength: 40,
            onSubmitted: (_) => saving ? null : onStart(),
            decoration: InputDecoration(
              labelText: 'Como devemos te chamar?',
              hintText: 'Ex.: Ana, Luiza, João...',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              errorText: error,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.teal, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Usamos o nome apenas neste aparelho, para personalizar a '
            'experiência.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.ink.withValues(alpha: 0.52),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: saving ? null : onStart,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (saving) ...[
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                const Text('Entrar no treinamento'),
                if (!saving) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 19),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
