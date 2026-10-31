import 'dart:math';

import 'package:assessora_stf_cards/data/battles.dart';
import 'package:assessora_stf_cards/data/cards.dart';
import 'package:assessora_stf_cards/engine/battle_engine.dart';
import 'package:assessora_stf_cards/models/battle.dart';
import 'package:assessora_stf_cards/models/card.dart';
import 'package:flutter_test/flutter_test.dart';

BattleConfig _config({
  int player = 20,
  int machine = 18,
  List<String>? deck,
  List<Objection>? objections,
}) {
  return BattleConfig(
    id: 'test',
    caseId: 'case1',
    title: 'Teste',
    subtitle: 'Teste',
    opponentName: 'Tese',
    opponentTitle: 'Tese',
    intro: 'Intro',
    deck: deck ?? const ['subsuncao', 'tudo-ou-nada', 'dignidade'],
    objections:
        objections ??
        [
          const Objection(
            id: 'o1',
            text: 'Objeção de teste',
            damage: 4,
            counterTags: {CardTag.regra},
            counterHint: 'Regra',
          ),
        ],
    rewardLabel: 'Nada',
    playerConviction: player,
    machineConviction: machine,
    handSize: 3,
  );
}

void main() {
  test('começa com mão cheia, energia cheia e turno 1', () {
    final engine = BattleEngine(config: _config(), random: Random(1));

    expect(engine.turn, 1);
    expect(engine.energy, 3);
    expect(engine.hand, hasLength(3));
    expect(engine.playerConviction, 20);
    expect(engine.machineConviction, 18);
    expect(engine.phase, BattlePhase.playerTurn);
  });

  test('não joga carta sem energia suficiente', () {
    final engine = BattleEngine(
      config: _config(deck: const ['idade-minima', 'tudo-ou-nada']),
      random: Random(2),
    );
    expect(engine.hand, hasLength(2));

    final expensive = engine.hand.firstWhere((c) => c.cost == 2);
    expect(engine.canPlay(expensive), isTrue);
    engine.playCard(expensive);
    expect(engine.energy, 1);

    final second = engine.hand.isEmpty ? null : engine.hand.first;
    if (second != null && second.cost > 1) {
      expect(engine.canPlay(second), isFalse);
      expect(engine.playCard(second), isNull);
    }
  });

  test('carta com a tag certa refuta a objeção e ganha bônus', () {
    final engine = BattleEngine(
      config: _config(deck: const ['subsuncao']),
      random: Random(3),
    );
    final card = engine.hand.single;

    final outcome = engine.playCard(card)!;

    expect(outcome.refuted, isTrue);
    expect(outcome.damage, 7); // 4 de base + 3 de bônus
    expect(engine.refutations, 1);
    expect(engine.machineConviction, 11);

    engine.endTurn();
    expect(engine.playerConviction, 20);
    expect(engine.phase, BattlePhase.playerTurn);
  });

  test('conjunto de resposta soma custo, dano e refuta uma única vez', () {
    final engine = BattleEngine(
      config: _config(
        deck: const ['subsuncao', 'tudo-ou-nada'],
        objections: [
          const Objection(
            id: 'o1',
            text: 'Objeção de teste',
            damage: 4,
            counterTags: {CardTag.regra},
            counterHint: 'Regra',
          ),
        ],
      ),
      random: Random(31),
    );

    final cards = engine.hand.toList();
    expect(cards, hasLength(2));
    expect(engine.comboCost(cards), 3);
    expect(engine.canPlayCombo(cards), isTrue);

    final outcome = engine.playCombo(cards)!;

    // 4 + 6 de base e +3 de bônus apenas uma vez.
    expect(outcome.cards, hasLength(2));
    expect(outcome.damage, 13);
    expect(outcome.refuted, isTrue);
    expect(engine.refutations, 1);
    expect(engine.machineConviction, 5);
    expect(engine.energy, 0);
    expect(engine.hand, isEmpty);
  });

  test('conjunto que não cabe na energia é recusado', () {
    final engine = BattleEngine(
      config: _config(deck: const ['idade-minima', 'tudo-ou-nada']),
      random: Random(32),
    );

    final cards = engine.hand.toList();
    expect(engine.comboCost(cards), 4);
    expect(engine.canPlayCombo(cards), isFalse);
    expect(engine.playCombo(cards), isNull);
    expect(engine.energy, 3);
    expect(engine.machineConviction, 18);
    expect(engine.hand, hasLength(2));
  });

  test('conjunto com carta repetida é inválido', () {
    final engine = BattleEngine(
      config: _config(deck: const ['subsuncao']),
      random: Random(33),
    );
    final card = engine.hand.single;

    expect(engine.canPlayCombo([card, card]), isFalse);
    expect(engine.playCombo([card, card]), isNull);
    expect(engine.energy, 3);
  });

  test('objeção não refutada causa dano no fim do turno', () {
    final engine = BattleEngine(
      config: _config(deck: const ['liberdade-expressao']),
      random: Random(4),
    );
    expect(engine.hand.single.tags, contains(CardTag.principio));

    engine.playCard(engine.hand.single);
    engine.endTurn();

    expect(engine.playerConviction, 16);
    expect(engine.turn, 2);
    expect(engine.energy, 3);
  });

  test('bloqueio absorve o ataque antes de atingir a convicção', () {
    final engine = BattleEngine(
      config: _config(deck: const ['seguranca-juridica']),
      random: Random(5),
    );
    // A defesa também tem a tag regra: refuta e ainda bloqueia.
    engine.playCard(engine.hand.single);
    expect(engine.block, greaterThan(0));

    engine.endTurn();
    expect(engine.playerConviction, 20);
  });

  test('zerar a convicção da tese encerra em vitória', () {
    final engine = BattleEngine(
      config: _config(machine: 5, deck: const ['subsuncao']),
      random: Random(6),
    );

    engine.playCard(engine.hand.single);

    expect(engine.machineConviction, 0);
    expect(engine.isVictory, isTrue);
    expect(engine.phase, BattlePhase.won);
    expect(engine.endTurn, returnsNormally);
  });

  test('zerar a convicção do jogador encerra em derrota', () {
    final engine = BattleEngine(
      config: _config(
        player: 5,
        machine: 99,
        deck: const ['dignidade'],
        objections: const [
          Objection(
            id: 'o1',
            text: 'Ataque forte',
            damage: 6,
            counterTags: {CardTag.mutacao},
            counterHint: 'Mutação',
          ),
        ],
      ),
      random: Random(7),
    );

    engine.endTurn();

    expect(engine.playerConviction, 0);
    expect(engine.phase, BattlePhase.lost);
    expect(engine.endTurn, returnsNormally);
  });

  test('baralho reembaralha o descarte sem travar', () {
    final engine = BattleEngine(
      config: _config(player: 60, deck: const ['subsuncao', 'dignidade']),
      random: Random(8),
    );

    for (var i = 0; i < 4; i++) {
      engine.endTurn();
      expect(engine.hand, isNotEmpty);
    }
    expect(engine.phase, BattlePhase.playerTurn);
  });

  test('as cinco batalhas usam cartas existentes', () {
    for (final battle in battleConfigs) {
      for (final id in battle.deck) {
        expect(cardById(id), isNotNull, reason: 'carta ausente: $id');
      }
      expect(battle.objections, isNotEmpty);
      expect(battle.deck, hasLength(10));
    }
  });

  test('cada objeção tem ao menos uma carta de resposta no baralho', () {
    for (final battle in battleConfigs) {
      final deck = battle.deck.map(cardById).whereType<ArgumentCard>().toList();
      for (final objection in battle.objections) {
        final answers = deck.where(objection.isCounteredBy);
        expect(
          answers,
          isNotEmpty,
          reason: '${battle.id}/${objection.id} sem resposta',
        );
      }
    }
  });
}
