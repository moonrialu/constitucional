import '../models/battle.dart';
import '../models/card.dart';

/// As cinco batalhas da jornada. Cada uma reaproveita um caso do roteiro:
/// as alternativas incorretas viram as objeções jogadas pela máquina.
const List<BattleConfig> battleConfigs = [
  BattleConfig(
    id: 'battle1',
    caseId: 'case1',
    title: 'O candidato de 34 anos',
    subtitle: 'Caso 1 · Regra × princípio',
    opponentName: 'Defesa de João',
    opponentTitle: 'Argumenta que a idade mínima pode ser ponderada',
    intro:
        'João tem 34 anos e quer se candidatar a Presidente. A defesa sustenta '
        'que a soberania popular deve ser ponderada com a exigência de 35 anos. '
        'Responda com o fundamento correto e derrube a tese.',
    deck: [
      'subsuncao',
      'tudo-ou-nada',
      'idade-minima',
      'seguranca-juridica',
      'unidade',
      'dignidade',
      'dworkin',
      'texto-limite',
      'legalidade',
      'distincao',
    ],
    objections: [
      Objection(
        id: 'b1-o1',
        text:
            'Soberania popular é princípio e, ponderada com a idade mínima, '
            'deveria permitir a candidatura.',
        damage: 4,
        counterTags: {CardTag.regra},
        counterHint: 'Regra',
        sourceChoiceId: 'A',
      ),
      Objection(
        id: 'b1-o2',
        text:
            'Qualquer princípio fundamental prevalece sobre a regra da idade '
            'mínima.',
        damage: 5,
        counterTags: {CardTag.regra},
        counterHint: 'Regra',
        sourceChoiceId: 'C',
      ),
      Objection(
        id: 'b1-o3',
        text:
            'Regras e princípios têm hierarquia: o princípio sempre vence a '
            'regra.',
        damage: 6,
        counterTags: {CardTag.regra},
        counterHint: 'Regra',
      ),
    ],
    rewardLabel: 'Ponderação, Alexy e Hierarquia das normas',
    theoryId: 'theory1',
  ),
  BattleConfig(
    id: 'battle2',
    caseId: 'case2',
    title: 'A biografia não autorizada',
    subtitle: 'Caso 2 · Colisão de princípios',
    opponentName: 'Advogado do cantor',
    opponentTitle: 'Pede a proibição da biografia antes do lançamento',
    intro:
        'A biografia foi escrita com entrevistas e documentos públicos. O '
        'cantor invoca intimidade e vida privada; a editora invoca liberdade de '
        'expressão e informação. Resolva a colisão sem censura prévia.',
    deck: [
      'liberdade-expressao',
      'direito-informacao',
      'intimidade',
      'indenizacao',
      'adi-4815',
      'censura-previa',
      'direito-resposta',
      'ponderacao',
      'alexy',
      'unidade',
    ],
    objections: [
      Objection(
        id: 'b2-o1',
        text:
            'A intimidade está antes no texto, então prevalece pelo critério '
            'hierárquico.',
        damage: 4,
        counterTags: {CardTag.principio},
        counterHint: 'Princípio',
        sourceChoiceId: 'A',
      ),
      Objection(
        id: 'b2-o2',
        text:
            'Um dos dois direitos deve ser declarado inválido e retirado do '
            'sistema.',
        damage: 5,
        counterTags: {CardTag.principio},
        counterHint: 'Princípio',
        sourceChoiceId: 'B',
      ),
      Objection(
        id: 'b2-o3',
        text:
            'Sem autorização prévia do biografado, a obra deve ser proibida '
            'antes do lançamento.',
        damage: 6,
        counterTags: {CardTag.precedente},
        counterHint: 'Precedente',
      ),
    ],
    rewardLabel: 'Honra e imagem',
    machineConviction: 18,
  ),
  BattleConfig(
    id: 'battle3',
    caseId: 'case3',
    title: '"Entre o homem e a mulher"',
    subtitle: 'Caso 3 · Mutação constitucional',
    opponentName: 'Ministério Público',
    opponentTitle: 'Exige emenda para reconhecer a união',
    intro:
        'Um casal de duas mulheres, junto há 12 anos, pede o reconhecimento da '
        'união estável. O texto do art. 226, § 3º, não foi alterado. Mostre '
        'como a Constituição evolui sem emenda.',
    deck: [
      'mutacao',
      'interpretacao-conforme',
      'adpf-132',
      'ferraz',
      'avila',
      'dignidade',
      'texto-limite',
      'subsuncao',
      'ponderacao',
      'hierarquia-normas',
    ],
    objections: [
      Objection(
        id: 'b3-o1',
        text: 'Só uma emenda constitucional pode mudar o sentido do texto.',
        damage: 5,
        counterTags: {CardTag.mutacao},
        counterHint: 'Mutação',
        sourceChoiceId: 'A',
      ),
      Objection(
        id: 'b3-o2',
        text:
            'O STF pode reescrever qualquer dispositivo quando a sociedade '
            'muda.',
        damage: 5,
        counterTags: {CardTag.competencia},
        counterHint: 'Limite',
        sourceChoiceId: 'C',
      ),
      Objection(
        id: 'b3-o3',
        text:
            'A expressão "homem e mulher" é um limite textual intransponível.',
        damage: 6,
        counterTags: {CardTag.mutacao},
        counterHint: 'Mutação',
      ),
    ],
    rewardLabel: 'Entidade familiar, Voto secreto, Cláusula pétrea e Controle preventivo',
    machineConviction: 20,
    theoryId: 'theory2',
  ),
  BattleConfig(
    id: 'battle4',
    caseId: 'case4',
    title: 'Os limites da mutação',
    subtitle: 'Caso 4 · Mutação inconstitucional',
    opponentName: 'Tribunal fictício',
    opponentTitle: 'Diz que "voto secreto" virou voto identificado',
    intro:
        'Um tribunal decide que "voto secreto" passou a significar voto '
        'registrado com o nome do eleitor. O texto continua igual. Classifique '
        'a decisão e mostre o limite da mutação.',
    deck: [
      'mutacao-limite',
      'voto-secreto',
      'clausula-petrea',
      'controle-preventivo',
      'texto-limite',
      'mutacao',
      'interpretacao-conforme',
      'seguranca-juridica',
      'subsuncao',
      'hierarquia-normas',
    ],
    objections: [
      Objection(
        id: 'b4-o1',
        text: 'Texto igual basta: o sentido mudou com a sociedade.',
        damage: 5,
        counterTags: {CardTag.mutacao},
        counterHint: 'Mutação',
        sourceChoiceId: 'A',
      ),
      Objection(
        id: 'b4-o2',
        text: 'Seria válida se fosse feita por emenda constitucional.',
        damage: 6,
        counterTags: {CardTag.competencia},
        counterHint: 'Cláusula pétrea',
        sourceChoiceId: 'B',
      ),
      Objection(
        id: 'b4-o3',
        text:
            'A mutação pode contrariar o texto, desde que acompanhe a evolução '
            'da sociedade.',
        damage: 6,
        counterTags: {CardTag.mutacao},
        counterHint: 'Mutação',
      ),
    ],
    rewardLabel:
        'Rcl 4335, Mutação inconstitucional, Separação dos Poderes e mais',
    machineConviction: 20,
    theoryId: 'theory2',
  ),
  BattleConfig(
    id: 'battle5',
    caseId: 'case5',
    title: 'A emenda que queria extinguir o STF',
    subtitle: 'Caso 5 · Cláusula pétrea',
    opponentName: 'Autores da PEC',
    opponentTitle: 'Alegam quórum e soberania popular',
    intro:
        'Uma PEC aprovada em dois turnos, por 3/5, quer extinguir o STF e '
        'transferir suas funções a um conselho indicado pelo Executivo. '
        'Oriente o voto do gabinete.',
    deck: [
      'clausula-petrea',
      'separacao-poderes',
      'quorum',
      'ms-32033',
      'controle-preventivo',
      'referendo',
      'rcl-4335',
      'mutacao-limite',
      'seguranca-juridica',
      'independencia',
    ],
    objections: [
      Objection(
        id: 'b5-o1',
        text:
            'O quórum de 3/5 foi cumprido; a vontade popular legitima a '
            'mudança.',
        damage: 5,
        counterTags: {CardTag.competencia},
        counterHint: 'Cláusula pétrea',
        sourceChoiceId: 'A',
      ),
      Objection(
        id: 'b5-o2',
        text: 'O referendo popular pode convalidar a supressão do STF.',
        damage: 6,
        counterTags: {CardTag.competencia},
        counterHint: 'Cláusula pétrea',
        sourceChoiceId: 'C',
      ),
      Objection(
        id: 'b5-o3',
        text:
            'Cláusulas pétreas limitam a interpretação, não a reforma '
            'constitucional.',
        damage: 6,
        counterTags: {CardTag.competencia},
        counterHint: 'Cláusula pétrea',
      ),
    ],
    rewardLabel: 'Parecer do ministro',
    machineConviction: 22,
    theoryId: 'theory2',
  ),
];

BattleConfig? battleById(String id) {
  for (final battle in battleConfigs) {
    if (battle.id == id) return battle;
  }
  return null;
}

BattleConfig? battleForCase(String caseId) {
  for (final battle in battleConfigs) {
    if (battle.caseId == caseId) return battle;
  }
  return null;
}

/// Partida de exemplo conduzida pelo Guia (a máquina). Usa o mesmo caso e as
/// mesmas objeções da batalha, mas com um baralho curto e controlado para a
/// demonstração: um ataque que refuta e um conjunto de defesa.
BattleConfig tutorialBattle(BattleConfig base) {
  return BattleConfig(
    id: 'tutorial',
    caseId: base.caseId,
    title: 'Partida de exemplo',
    subtitle: 'O Guia joga · ${base.title}',
    opponentName: base.opponentName,
    opponentTitle: base.opponentTitle,
    intro:
        'O Guia conduz uma partida de exemplo antes da sua. Observe como ler, '
        'jogar e montar um conjunto de resposta.',
    deck: const ['subsuncao', 'seguranca-juridica', 'dignidade'],
    objections: base.objections.take(2).toList(),
    rewardLabel: 'Tutorial concluído',
    playerConviction: 20,
    machineConviction: 24,
    handSize: 3,
    theoryId: base.theoryId,
  );
}
