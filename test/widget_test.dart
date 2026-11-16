import 'package:flutter_test/flutter_test.dart';
import 'package:grupo_da_baiana/data/game_script.dart';
import 'package:grupo_da_baiana/models/chat_script.dart';
import 'package:grupo_da_baiana/models/contact.dart';

void main() {
  group('roteiro do jogo', () {
    test('todos os contatos têm um script com o mesmo id', () {
      for (final Contact contact in gameContacts) {
        expect(
          gameScripts.containsKey(contact.id),
          isTrue,
          reason: 'Falta script para ${contact.id}',
        );
        expect(gameScripts[contact.id]!.contactId, contact.id);
      }
    });

    test('o desbloqueio aponta para uma fase anterior existente', () {
      final Map<String, Contact> byId = <String, Contact>{
        for (final Contact contact in gameContacts) contact.id: contact,
      };

      for (final Contact contact in gameContacts) {
        final String? previous = contact.unlocksAfter;
        if (previous == null) continue;
        expect(byId.containsKey(previous), isTrue);
        expect(byId[previous]!.order, lessThan(contact.order));
      }
    });

    test('os nós das escolhas existem no mesmo script', () {
      for (final ChatScript script in gameScripts.values) {
        expect(script.nodes.containsKey(script.startNodeId), isTrue);

        for (final ChatNode node in script.nodes.values) {
          if (node.inspection != null) continue;
          expect(
            node.choices,
            isNotEmpty,
            reason: 'Nó ${script.contactId}/${node.id} sem saída',
          );
          for (final ChatChoice choice in node.choices) {
            if (choice.nextNodeId == null) continue;
            expect(
              script.nodes.containsKey(choice.nextNodeId),
              isTrue,
              reason:
                  'Escolha ${choice.id} aponta para nó inexistente ${choice.nextNodeId}',
            );
          }
        }
      }
    });

    test('conversas em grupo identificam quem fala', () {
      for (final Contact contact in gameContacts.where(
        (Contact c) => c.isGroup,
      )) {
        final ChatScript script = gameScripts[contact.id]!;
        for (final ChatNode node in script.nodes.values) {
          for (final BotLine line in node.lines) {
            expect(
              line.sender,
              isNotNull,
              reason: 'Mensagem de grupo sem remetente em ${node.id}',
            );
          }
          for (final ChatChoice choice in node.choices) {
            for (final BotLine line in choice.react) {
              expect(
                line.sender,
                isNotNull,
                reason: 'Reação de grupo sem remetente em ${choice.id}',
              );
            }
          }
        }
        for (final BotLine line in script.freeTextReplies) {
          expect(line.sender, isNotNull);
        }
      }
    });

    test('as ordens das fases são únicas e sequenciais', () {
      final List<Contact> phases = gameContacts
          .where((Contact c) => !c.isReference)
          .toList();
      final List<int> orders = phases.map((Contact c) => c.order).toList()
        ..sort();
      expect(orders, List<int>.generate(phases.length, (int i) => i));
    });

    test('a sala de dúvidas fica sempre aberta e não encerra', () {
      final List<Contact> references = gameContacts
          .where((Contact c) => c.isReference)
          .toList();
      expect(references, hasLength(1));

      final Contact sala = references.single;
      expect(sala.unlocksAfter, isNull);
      expect(sala.isGroup, isTrue);

      final ChatScript script = gameScripts[sala.id]!;
      for (final ChatNode node in script.nodes.values) {
        for (final ChatChoice choice in node.choices) {
          expect(
            choice.nextNodeId,
            isNotNull,
            reason: 'A consulta não deve ter escolha que encerra a fase',
          );
        }
      }
    });

    test(
      'o teste final tem cinco questões, cada uma com uma resposta correta',
      () {
        final ChatScript banca = gameScripts['banca']!;
        expect(banca.isQuiz, isTrue);

        final List<ChatNode> questions = banca.nodes.values
            .where(
              (ChatNode node) =>
                  node.choices.any((ChatChoice c) => c.isCorrect != null),
            )
            .toList();

        expect(questions.length, 5);
        for (final ChatNode question in questions) {
          final int correct = question.choices
              .where((ChatChoice choice) => choice.isCorrect == true)
              .length;
          expect(
            correct,
            1,
            reason: 'Questão ${question.id} sem resposta única',
          );
        }

        for (final ChatScript script in gameScripts.values) {
          if (script.isQuiz || script.isRiskChat) continue;
          for (final ChatNode node in script.nodes.values) {
            if (node.card != null) continue;
            for (final ChatChoice choice in node.choices) {
              expect(
                choice.isCorrect,
                isNull,
                reason: 'Escolha com nota fora do teste final',
              );
            }
          }
        }
      },
    );

    test('acerto técnico vale +15, informal +5 e erro -10', () {
      expect(AnswerStyle.technical.prestigeDelta, 15);
      expect(AnswerStyle.informal.prestigeDelta, 5);
      expect(AnswerStyle.wrong.prestigeDelta, -10);
      expect(AnswerStyle.technical.isHit, isTrue);
      expect(AnswerStyle.wrong.isMiss, isTrue);
    });

    test('as reações dos personagens seguem o tom da resposta', () {
      expect(AnswerStyle.technical.reactionEmojis, <String>['❤️', '👏']);
      expect(AnswerStyle.informal.reactionEmojis, <String>['👀', '😂']);
      expect(AnswerStyle.wrong.reactionEmojis, <String>['😱', '💀']);
    });

    test('o teste final marca café perdido e prestígio negativo no erro', () {
      final ChatScript banca = gameScripts['banca']!;
      for (final ChatNode node in banca.nodes.values) {
        for (final ChatChoice choice in node.choices) {
          if (choice.isCorrect == null) continue;
          expect(
            choice.answerStyle,
            choice.isCorrect! ? AnswerStyle.technical : AnswerStyle.wrong,
          );
          if (choice.isCorrect == false) {
            expect(choice.answerStyle.prestigeDelta, -10);
          }
        }
      }
    });

    test('a consulta permanente não usa tom de erro', () {
      final ChatScript sala = gameScripts['sala']!;
      for (final ChatNode node in sala.nodes.values) {
        for (final ChatChoice choice in node.choices) {
          expect(choice.answerStyle, isNot(AnswerStyle.wrong));
        }
      }
    });

    test('cada acerto no teste final rende elogio de um personagem', () {
      final ChatScript banca = gameScripts['banca']!;
      expect(banca.praiseLines.length, greaterThanOrEqualTo(5));

      final Contact contact = gameContacts.firstWhere(
        (Contact c) => c.id == 'banca',
      );
      final Set<String> speakers = contact.participants
          .map((ChatParticipant p) => p.name)
          .toSet();
      for (final BotLine line in banca.praiseLines) {
        expect(
          speakers.contains(line.sender),
          isTrue,
          reason: 'Elogio de personagem fora do grupo: ${line.sender}',
        );
      }

      for (final ChatScript script in gameScripts.values) {
        if (script.isQuiz) continue;
        expect(script.praiseLines, isEmpty);
      }
    });

    test(
      'as cartas do Bruno têm cronômetro, três opções e destino no timeout',
      () {
        final ChatScript bruno = gameScripts['bruno']!;
        final List<ChatNode> cards = bruno.nodes.values
            .where((ChatNode node) => node.card != null)
            .toList();

        expect(cards, hasLength(3));
        expect(
          bruno.startNode.lines.any(
            (BotLine line) => line.text.contains('segundos'),
          ),
          isTrue,
        );

        for (final ChatNode node in cards) {
          final CardChallenge card = node.card!;
          expect(card.seconds, greaterThan(0));
          expect(card.situation, isNotEmpty);
          expect(card.timeoutLine.sender, 'Bruno');
          expect(card.timeoutNextNodeId, isNotNull);
          expect(bruno.nodes.containsKey(card.timeoutNextNodeId), isTrue);
          expect(node.choices, hasLength(3));
          expect(
            node.choices.where((ChatChoice c) => c.isCorrect == true),
            hasLength(1),
          );
          for (final ChatChoice choice in node.choices) {
            if (choice.isCorrect == false) {
              expect(choice.answerStyle, AnswerStyle.wrong);
            }
          }
        }

        expect(cards.map((ChatNode node) => node.card!.index).toList(), <int>[
          1,
          2,
          3,
        ]);
      },
    );

    test('o chat do Ministro é de alto risco e desconta 25 no erro', () {
      final ChatScript ministro = gameScripts['ministro']!;
      expect(ministro.isRiskChat, isTrue);

      final ChatNode caso1 = ministro.nodes['caso1']!;
      final ChatChoice acolher = caso1.choices.firstWhere(
        (ChatChoice c) => c.isCorrect == true,
      );
      expect(acolher.prestigeDelta, isNull);
      expect(acolher.answerStyle.prestigeDelta, 15);
      expect(acolher.nextNodeId, isNull);

      for (final ChatChoice choice in caso1.choices) {
        if (choice.isCorrect == false) {
          expect(choice.prestigeDelta, -25);
          expect(choice.answerStyle, AnswerStyle.wrong);
          expect(choice.nextNodeId, 'insistencia');
        }
      }

      final ChatNode insistencia = ministro.nodes['insistencia']!;
      expect(
        insistencia.choices.where((ChatChoice c) => c.isCorrect == true),
        hasLength(1),
      );
      for (final ChatChoice choice in insistencia.choices) {
        if (choice.isCorrect == false) {
          expect(choice.prestigeDelta, -25);
          expect(choice.nextNodeId, 'insistencia');
        }
      }
    });

    test('o rascunho da Dra. Helena mistura erros e verdades', () {
      final ChatScript helena = gameScripts['helena']!;
      final ChatNode node = helena.nodes['rascunho']!;
      final InspectionChallenge inspection = node.inspection!;

      expect(inspection.statements.length, inInclusiveRange(5, 6));
      expect(inspection.falseCount, greaterThanOrEqualTo(2));
      expect(
        inspection.statements.where((DraftStatement s) => !s.isFalse).length,
        greaterThanOrEqualTo(2),
      );
      expect(
        inspection.statements.map((DraftStatement s) => s.id).toSet().length,
        inspection.statements.length,
      );
      expect(inspection.successLines, isNotEmpty);
      expect(node.choices, isEmpty);
    });

    test('o Bruno é o terceiro chat, logo depois do Ministro', () {
      final Contact ministro = gameContacts.firstWhere(
        (Contact c) => c.id == 'ministro',
      );
      final Contact bruno = gameContacts.firstWhere(
        (Contact c) => c.id == 'bruno',
      );
      expect(bruno.order, ministro.order + 1);
      expect(bruno.unlocksAfter, 'ministro');
    });
  });
}
