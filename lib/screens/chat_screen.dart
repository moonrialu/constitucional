import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/chat_script.dart';
import '../models/contact.dart';
import '../state/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/card_challenge_panel.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/choice_list.dart';
import '../widgets/coffee_blocked_dialog.dart';
import '../widgets/contact_avatar.dart';
import '../widgets/finale_sheet.dart';
import '../widgets/message_bubble.dart';
import '../widgets/stage_complete_sheet.dart';
import '../widgets/status_bar.dart';
import '../widgets/typing_indicator.dart';
import 'exoneration_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.controller,
    required this.contact,
  });

  final GameController controller;
  final Contact contact;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    _inputFocus.addListener(_onFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.controller.openChat(widget.contact);
      // Conversas retomadas do disco já vêm preenchidas: abre no fim.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _jumpToBottom();
        _maybeBlockForCoffee();
      });
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _inputFocus.removeListener(_onFocusChanged);
    _scrollController.dispose();
    _inputController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  int _scrollTicket = 0;

  void _onControllerChanged() {
    // O rodapé (escolhas/teclado) muda a altura do viewport e o ChoiceList
    // anima essa altura por ~220ms. Rolamos no fim do frame, no frame
    // seguinte e de novo depois que a animação do rodapé termina.
    final int ticket = ++_scrollTicket;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || ticket != _scrollTicket) return;
      _scrollToBottom();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || ticket != _scrollTicket) return;
        _scrollToBottom();
      });
      Future<void>.delayed(const Duration(milliseconds: 280), () {
        if (!mounted || ticket != _scrollTicket) return;
        _scrollToBottom();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeBlockForCoffee());
  }

  void _onFocusChanged() {
    if (_inputFocus.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (!mounted || !_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _jumpToBottom() {
    if (!mounted || !_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<void> _sendFreeText(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _inputController.clear();
    await widget.controller.sendFreeText(widget.contact, trimmed);
  }

  Future<void> _choose(ChatChoice choice) async {
    _inputFocus.unfocus();
    if (!widget.contact.isReference) {
      _showChoiceFeedback(choice);
    }
    final StageCompletion? completion = await widget.controller.choose(
      widget.contact,
      choice,
    );
    if (!mounted || completion == null) return;

    // Banca do Ministro: o teste final encerra o treinamento. Não há próxima
    // fase para carregar e nenhum cronômetro segue ativo.
    if (completion.isCareerFinale) {
      final FinaleAction? action = await showFinaleSheet(
        context,
        stats: widget.controller.stats,
        correctAnswers: completion.correctAnswers,
        answeredQuestions: completion.answeredQuestions,
      );
      if (!mounted) return;
      if (action == FinaleAction.restart) {
        await widget.controller.restartTraining();
        if (!mounted) return;
      }
      Navigator.of(context).pop();
      return;
    }

    await showStageCompletionSheet(context, completion);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _inspectStatement(ChatMessage message) async {
    if (message.statementIsFalse == false) {
      _showStatementSnack(
        '−1 café · essa parte estava certa! 👀',
        Icons.coffee_rounded,
      );
    } else {
      _showStatementSnack(
        'Balão marcado como falso · +10 prestígio',
        Icons.delete_outline_rounded,
      );
    }

    final StageCompletion? completion = await widget.controller
        .inspectStatement(widget.contact, message.id);
    if (!mounted || completion == null) return;
    await showStageCompletionSheet(context, completion);
    if (mounted) Navigator.of(context).pop();
  }

  void _showStatementSnack(String text, IconData icon) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Row(
            children: <Widget>[
              Icon(icon, size: 17, color: AppColors.cream),
              const SizedBox(width: 10),
              Expanded(child: Text(text)),
            ],
          ),
        ),
      );
  }

  /// Confirma na hora o efeito da escolha: prestígio e, no teste, café perdido.
  void _showChoiceFeedback(ChatChoice choice) {
    if (!mounted) return;
    final AnswerStyle style = choice.answerStyle;
    final bool game = widget.controller.isAnswerGame(widget.contact);
    final int delta = choice.prestigeDelta ?? style.prestigeDelta;

    final IconData icon = switch (style) {
      AnswerStyle.technical =>
        choice.isCorrect == true || game
            ? Icons.check_circle_outline_rounded
            : Icons.trending_up_rounded,
      AnswerStyle.informal => Icons.chat_bubble_outline_rounded,
      AnswerStyle.wrong => Icons.coffee_rounded,
    };
    final String text;
    if (choice.isCorrect == true) {
      text = 'Acertou! Prestígio +$delta';
    } else if (choice.isCorrect == false) {
      text = '−1 café · erro conceitual · prestígio $delta';
    } else if (style.isMiss) {
      text = 'Erro conceitual · prestígio $delta';
    } else {
      text = 'Prestígio +$delta · ${style.feedbackLabel}';
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Row(
            children: <Widget>[
              Icon(icon, size: 17, color: AppColors.cream),
              const SizedBox(width: 10),
              Expanded(child: Text(text)),
            ],
          ),
        ),
      );
  }

  bool _coffeeDialogOpen = false;

  /// Tempo esgotado em uma carta: o Bruno explica e a fase continua.
  Future<void> _timeoutCard() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Row(
            children: <Widget>[
              Icon(Icons.timer_off_outlined, size: 17, color: AppColors.cream),
              SizedBox(width: 10),
              Expanded(child: Text('Tempo esgotado · −1 café · prestígio −10')),
            ],
          ),
        ),
      );
    final StageCompletion? completion = await widget.controller.timeoutCard(
      widget.contact,
    );
    if (!mounted || completion == null) return;
    await showStageCompletionSheet(context, completion);
    if (mounted) Navigator.of(context).pop();
  }

  /// Bloqueia o expediente quando as xícaras chegam a zero.
  /// Cafés são vida apenas dos jogos de respostas (cartas e banca).
  Future<void> _maybeBlockForCoffee() async {
    if (!mounted || _coffeeDialogOpen) return;
    if (widget.controller.isExonerated(widget.contact)) return;
    if (!widget.controller.isAnswerGame(widget.contact)) return;
    if (!widget.controller.isOutOfCoffee) return;

    final ChatSession session = widget.controller.sessionFor(widget.contact);
    if (session.busy || session.finished) return;

    _coffeeDialogOpen = true;
    final bool reload = await showCoffeeBlockedDialog(context);
    _coffeeDialogOpen = false;
    if (!reload || !mounted) return;

    await widget.controller.reloadCoffees();
    if (!mounted) return;
    await _openReferenceRoom();
  }

  Future<void> _openReferenceRoom() async {
    final Contact? sala = widget.controller.referenceContact;
    if (sala == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ChatScreen(controller: widget.controller, contact: sala),
      ),
    );
  }

  Future<void> _restartTraining() async {
    await widget.controller.restartTraining();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Contact contact = widget.contact;
    final int totalStages = widget.controller.totalStages;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, _) {
        if (widget.controller.isExonerated(contact)) {
          return ExonerationScreen(onRestart: _restartTraining);
        }
        return _buildChat(context, contact, totalStages);
      },
    );
  }

  Widget _buildChat(BuildContext context, Contact contact, int totalStages) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 52,
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.ink,
        ),
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            ContactAvatar(contact: contact, size: 38),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.appBarName,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    contact.isGroup
                        ? contact.participantNames
                        : contact.kindLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.2,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (BuildContext context, _) {
          final ChatSession session = widget.controller.sessionFor(contact);
          final List<ChatChoice> choices = widget.controller.choicesFor(
            contact,
          );
          final CardChallenge? card = widget.controller.cardFor(contact);
          final bool answerGame = widget.controller.isAnswerGame(contact);
          final bool canType =
              session.started && !session.busy && !session.finished;
          final String hint = session.finished
              ? 'Conversa encerrada'
              : session.started && !session.busy
              ? 'Escreva uma mensagem'
              : 'Aguarde a resposta…';

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                children: <Widget>[
                  StatusBar(
                    stats: widget.controller.stats,
                    showCoffees: answerGame,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.paperDeep.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              contact.isReference
                                  ? 'CONSULTA PERMANENTE'
                                  : 'FASE ${(contact.order + 1).toString().padLeft(2, '0')} DE ${totalStages.toString().padLeft(2, '0')}',
                              style: AppTheme.overline.copyWith(
                                fontSize: 8.5,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints box) {
                              return SingleChildScrollView(
                                controller: _scrollController,
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  10,
                                  16,
                                  10,
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: box.maxHeight - 20 > 0
                                        ? box.maxHeight - 20
                                        : 0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      for (final ChatMessage message
                                          in session.messages)
                                        MessageBubble(
                                          message: message,
                                          senderAvatarAsset: contact
                                              .avatarAssetFor(
                                                message.senderName,
                                              ),
                                          onStatementTap:
                                              message.isStatement &&
                                                  message.statementMark ==
                                                      StatementMark.none &&
                                                  !session.busy &&
                                                  !session.finished &&
                                                  !widget
                                                      .controller
                                                      .isOutOfCoffee
                                              ? () => _inspectStatement(message)
                                              : null,
                                        ),
                                      if (session.busy)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 6),
                                          child: TypingIndicator(),
                                        ),
                                      if (card != null)
                                        CardChallengePanel(
                                          key: ValueKey<String>(
                                            '${contact.id}-${session.currentNodeId}',
                                          ),
                                          card: card,
                                          choices: choices,
                                          enabled:
                                              !widget.controller.isOutOfCoffee,
                                          onAnswer: _choose,
                                          onTimeout: _timeoutCard,
                                        ),
                                      if (session.finished)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 22,
                                            bottom: 6,
                                          ),
                                          child: Text(
                                            'CONVERSA ENCERRADA',
                                            textAlign: TextAlign.center,
                                            style: AppTheme.overline.copyWith(
                                              fontSize: 8.5,
                                              letterSpacing: 1.6,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ChoiceList(
                    choices: card == null ? choices : const <ChatChoice>[],
                    onSelected: _choose,
                  ),
                  ChatInputBar(
                    controller: _inputController,
                    focusNode: _inputFocus,
                    enabled: canType,
                    hint: hint,
                    onSend: _sendFreeText,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
