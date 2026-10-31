import '../models/card.dart';

/// Catálogo de cartas do baralho da assessora.
///
/// `unlock` é a etapa que libera a carta:
/// - `battle1`..`battle5`: vencer a batalha;
/// - `check1`..`check3`: concluir a etapa interativa;
/// - `theory2`: ter passado pela teoria da mutação;
/// - `quiz`: concluir o teste final.
/// Carta sem `unlock` já começa no baralho.
const List<ArgumentCard> allCards = [
  // ------------------------------------------------------------ base inicial
  ArgumentCard(
    id: 'subsuncao',
    title: 'Subsunção',
    text:
        'A hipótese da regra se encaixa no fato e a consequência incide, sem '
        'ponderação.',
    kind: CardKind.ataque,
    cost: 1,
    power: 4,
    tags: {CardTag.regra},
  ),
  ArgumentCard(
    id: 'tudo-ou-nada',
    title: 'Tudo ou nada',
    text:
        'Regras valem de forma definitiva: ou se aplicam, ou não se aplicam. '
        'Não há "mais ou menos".',
    kind: CardKind.ataque,
    cost: 2,
    power: 6,
    tags: {CardTag.regra},
  ),
  ArgumentCard(
    id: 'idade-minima',
    title: 'Idade mínima',
    text:
        'Art. 14, § 3º, VI, "a": 35 anos para Presidente. O constituinte já fez '
        'a ponderação ao fixar o número.',
    kind: CardKind.ataque,
    cost: 2,
    power: 7,
    tags: {CardTag.regra, CardTag.competencia},
  ),
  ArgumentCard(
    id: 'seguranca-juridica',
    title: 'Segurança jurídica',
    text:
        'Ponderar uma regra clara esvaziaria a previsibilidade que ela existe '
        'para garantir.',
    kind: CardKind.defesa,
    cost: 1,
    block: 5,
    tags: {CardTag.regra},
  ),
  ArgumentCard(
    id: 'unidade',
    title: 'Unidade da Constituição',
    text:
        'Normas constitucionais originárias têm o mesmo status: não há '
        'hierarquia automática entre elas.',
    kind: CardKind.apoio,
    cost: 1,
    draw: 1,
    tags: {CardTag.principio, CardTag.regra},
  ),
  ArgumentCard(
    id: 'dignidade',
    title: 'Dignidade humana',
    text:
        'Art. 1º, III. Mandamento de otimização: realiza-se na maior medida '
        'possível, conforme o caso.',
    kind: CardKind.defesa,
    cost: 1,
    block: 5,
    tags: {CardTag.principio},
  ),
  ArgumentCard(
    id: 'dworkin',
    title: 'Dworkin',
    text:
        'Regras valem no "tudo ou nada"; princípios têm uma dimensão de peso.',
    kind: CardKind.apoio,
    cost: 1,
    draw: 1,
    tags: {CardTag.doutrina, CardTag.principio},
  ),
  ArgumentCard(
    id: 'texto-limite',
    title: 'O texto é o limite',
    text:
        'A interpretação não pode contrariar o texto expresso da Constituição.',
    kind: CardKind.defesa,
    cost: 1,
    block: 4,
    tags: {CardTag.regra, CardTag.mutacao},
  ),
  ArgumentCard(
    id: 'legalidade',
    title: 'Legalidade',
    text:
        'A administração e o julgador atuam conforme a norma posta: não há '
        'decisão contra a lei.',
    kind: CardKind.ataque,
    cost: 1,
    power: 4,
    tags: {CardTag.regra},
  ),
  ArgumentCard(
    id: 'distincao',
    title: 'Distinção',
    text:
        'Antes de aplicar, verifique se a norma é regra ou princípio: o método '
        'muda.',
    kind: CardKind.defesa,
    cost: 1,
    block: 4,
    tags: {CardTag.principio},
  ),

  // ------------------------------------------------------- recompensa battle1
  ArgumentCard(
    id: 'ponderacao',
    title: 'Ponderação',
    text:
        'Na colisão de princípios, os dois continuam válidos; um prevalece no '
        'caso concreto.',
    kind: CardKind.ataque,
    cost: 2,
    power: 6,
    tags: {CardTag.principio, CardTag.proporcionalidade},
    unlock: 'battle1',
    unlockLabel: 'Vença a batalha do Caso 1',
  ),
  ArgumentCard(
    id: 'alexy',
    title: 'Alexy',
    text:
        'Princípios são mandamentos de otimização; a colisão se resolve pela '
        'proporcionalidade.',
    kind: CardKind.apoio,
    cost: 1,
    energy: 1,
    draw: 1,
    tags: {CardTag.doutrina, CardTag.proporcionalidade},
    unlock: 'battle1',
    unlockLabel: 'Vença a batalha do Caso 1',
  ),
  ArgumentCard(
    id: 'hierarquia-normas',
    title: 'Hierarquia das normas',
    text:
        'O critério hierárquico resolve conflito entre níveis diferentes, não '
        'entre direitos fundamentais.',
    kind: CardKind.defesa,
    cost: 1,
    block: 5,
    tags: {CardTag.regra, CardTag.competencia},
    unlock: 'battle1',
    unlockLabel: 'Vença a batalha do Caso 1',
  ),

  // -------------------------------------------------------- recompensa check1
  ArgumentCard(
    id: 'liberdade-expressao',
    title: 'Liberdade de expressão',
    text:
        'Art. 5º, IV e IX. Protege a manifestação e a atividade intelectual, '
        'inclusive contra censura prévia.',
    kind: CardKind.ataque,
    cost: 2,
    power: 6,
    tags: {CardTag.principio},
    unlock: 'check1',
    unlockLabel: 'Conclua a classificação de regras e princípios',
  ),
  ArgumentCard(
    id: 'direito-informacao',
    title: 'Direito à informação',
    text:
        'Art. 5º, XIV. O público tem direito de acesso a fatos de interesse '
        'coletivo.',
    kind: CardKind.ataque,
    cost: 1,
    power: 5,
    tags: {CardTag.principio},
    unlock: 'check1',
    unlockLabel: 'Conclua a classificação de regras e princípios',
  ),
  ArgumentCard(
    id: 'intimidade',
    title: 'Intimidade e vida privada',
    text:
        'Art. 5º, X. Continua válida na colisão: protege dados médicos, '
        'familiares e a exposição gratuita.',
    kind: CardKind.defesa,
    cost: 1,
    block: 5,
    tags: {CardTag.principio},
    unlock: 'check1',
    unlockLabel: 'Conclua a classificação de regras e princípios',
  ),
  ArgumentCard(
    id: 'indenizacao',
    title: 'Reparação posterior',
    text:
        'Abuso de expressão se repara depois: indenização e direito de '
        'resposta são meios menos gravosos que a censura.',
    kind: CardKind.defesa,
    cost: 2,
    block: 8,
    tags: {CardTag.principio, CardTag.precedente},
    unlock: 'check1',
    unlockLabel: 'Conclua a classificação de regras e princípios',
  ),
  ArgumentCard(
    id: 'adi-4815',
    title: 'ADI 4815',
    text:
        'STF (2015): interpretação conforme aos arts. 20 e 21 do Código Civil. '
        'Biografias não exigem autorização prévia.',
    kind: CardKind.ataque,
    cost: 2,
    power: 8,
    precedent: 'ADI 4815 (2015)',
    tags: {CardTag.precedente, CardTag.principio},
    unlock: 'check1',
    unlockLabel: 'Conclua a classificação de regras e princípios',
  ),
  ArgumentCard(
    id: 'censura-previa',
    title: 'Vedação à censura',
    text: 'Censura prévia é vedada; a análise de abuso é posterior e concreta.',
    kind: CardKind.ataque,
    cost: 2,
    power: 6,
    tags: {CardTag.principio, CardTag.precedente},
    unlock: 'check1',
    unlockLabel: 'Conclua a classificação de regras e princípios',
  ),
  ArgumentCard(
    id: 'direito-resposta',
    title: 'Direito de resposta',
    text:
        'Art. 5º, V. Resposta proporcional ao agravo, sem retirar a obra de '
        'circulação.',
    kind: CardKind.defesa,
    cost: 1,
    block: 6,
    tags: {CardTag.principio},
    unlock: 'check1',
    unlockLabel: 'Conclua a classificação de regras e princípios',
  ),

  // -------------------------------------------------------- recompensa check2
  ArgumentCard(
    id: 'ferraz',
    title: 'Anna Cândida Ferraz',
    text:
        'Processos informais de mudança da Constituição: o sentido muda sem '
        'alteração do texto.',
    kind: CardKind.apoio,
    cost: 1,
    draw: 1,
    tags: {CardTag.doutrina, CardTag.mutacao},
    unlock: 'check2',
    unlockLabel: 'Conclua a associação de autores e teses',
  ),
  ArgumentCard(
    id: 'avila',
    title: 'Humberto Ávila',
    text:
        'A distinção entre regras e princípios não é rígida: regras também '
        'podem ceder em casos excepcionais.',
    kind: CardKind.defesa,
    cost: 1,
    block: 4,
    tags: {CardTag.doutrina, CardTag.regra},
    unlock: 'check2',
    unlockLabel: 'Conclua a associação de autores e teses',
  ),
  ArgumentCard(
    id: 'adpf-132',
    title: 'ADPF 132 / ADI 4277',
    text:
        'STF (2011): união estável entre pessoas do mesmo sexo é entidade '
        'familiar, sem alterar o texto.',
    kind: CardKind.ataque,
    cost: 2,
    power: 8,
    precedent: 'ADPF 132 e ADI 4277 (2011)',
    tags: {CardTag.precedente, CardTag.mutacao},
    unlock: 'check2',
    unlockLabel: 'Conclua a associação de autores e teses',
  ),

  // -------------------------------------------------------- recompensa theory2
  ArgumentCard(
    id: 'mutacao',
    title: 'Mutação constitucional',
    text:
        'Mudança informal: o sentido da norma evolui com a sociedade e o texto '
        'permanece o mesmo.',
    kind: CardKind.ataque,
    cost: 2,
    power: 6,
    tags: {CardTag.mutacao},
    unlock: 'theory2',
    unlockLabel: 'Passe pela teoria da mutação constitucional',
  ),
  ArgumentCard(
    id: 'interpretacao-conforme',
    title: 'Interpretação conforme',
    text:
        'Preserva o texto e ajusta o sentido à Constituição, em vez de declarar '
        'a norma inválida.',
    kind: CardKind.apoio,
    cost: 1,
    draw: 1,
    tags: {CardTag.mutacao},
    unlock: 'theory2',
    unlockLabel: 'Passe pela teoria da mutação constitucional',
  ),
  ArgumentCard(
    id: 'mutacao-limite',
    title: 'Limites da mutação',
    text:
        'A mutação não pode contrariar o texto expresso nem violar cláusulas '
        'pétreas. Fora daí, é inconstitucional.',
    kind: CardKind.ataque,
    cost: 2,
    power: 7,
    tags: {CardTag.mutacao, CardTag.competencia},
    unlock: 'theory2',
    unlockLabel: 'Passe pela teoria da mutação constitucional',
  ),

  // ------------------------------------------------------- recompensa battle2
  ArgumentCard(
    id: 'honra',
    title: 'Honra e imagem',
    text:
        'Art. 5º, X. Também é direito fundamental e entra na ponderação, sem '
        'hierarquia prévia.',
    kind: CardKind.defesa,
    cost: 1,
    block: 5,
    tags: {CardTag.principio},
    unlock: 'battle2',
    unlockLabel: 'Vença a batalha do Caso 2',
  ),

  // ------------------------------------------------------- recompensa battle3
  ArgumentCard(
    id: 'familia',
    title: 'Entidade familiar',
    text:
        'Art. 226, § 3º, lido à luz da dignidade e da igualdade: família é '
        'vínculo afetivo, não fórmula literal.',
    kind: CardKind.ataque,
    cost: 2,
    power: 6,
    tags: {CardTag.mutacao, CardTag.principio},
    unlock: 'battle3',
    unlockLabel: 'Vença a batalha do Caso 3',
  ),
  ArgumentCard(
    id: 'voto-secreto',
    title: 'Voto secreto',
    text: 'Art. 60, § 4º, II: cláusula pétrea. Nem emenda pode aboli-lo.',
    kind: CardKind.defesa,
    cost: 2,
    block: 7,
    tags: {CardTag.mutacao, CardTag.competencia},
    unlock: 'battle3',
    unlockLabel: 'Vença a batalha do Caso 3',
  ),
  ArgumentCard(
    id: 'clausula-petrea',
    title: 'Cláusula pétrea',
    text:
        'Art. 60, § 4º: forma federativa, voto secreto, separação dos Poderes '
        'e direitos individuais não podem ser abolidos.',
    kind: CardKind.defesa,
    cost: 2,
    block: 8,
    tags: {CardTag.competencia},
    unlock: 'battle3',
    unlockLabel: 'Vença a batalha do Caso 3',
  ),
  ArgumentCard(
    id: 'controle-preventivo',
    title: 'Controle preventivo',
    text:
        'MS 32.033: o STF pode barrar PEC que ofenda cláusula pétrea antes da '
        'votação.',
    kind: CardKind.defesa,
    cost: 1,
    block: 6,
    tags: {CardTag.competencia, CardTag.precedente},
    unlock: 'battle3',
    unlockLabel: 'Vença a batalha do Caso 3',
  ),

  // ------------------------------------------------------- recompensa battle4
  ArgumentCard(
    id: 'rcl-4335',
    title: 'Rcl 4335',
    text:
        'Debate sobre o art. 52, X: mutação constitucional ou mutação '
        'inconstitucional? O texto é o limite.',
    kind: CardKind.ataque,
    cost: 2,
    power: 8,
    precedent: 'Rcl 4335/AC',
    tags: {CardTag.precedente, CardTag.mutacao},
    unlock: 'battle4',
    unlockLabel: 'Vença a batalha do Caso 4',
  ),
  ArgumentCard(
    id: 'mutacao-inconstitucional',
    title: 'Mutação inconstitucional',
    text:
        'Quando o novo sentido é o oposto do texto, não há interpretação: há '
        'violação da Constituição.',
    kind: CardKind.ataque,
    cost: 3,
    power: 9,
    tags: {CardTag.mutacao, CardTag.competencia},
    unlock: 'battle4',
    unlockLabel: 'Vença a batalha do Caso 4',
  ),
  ArgumentCard(
    id: 'separacao-poderes',
    title: 'Separação dos Poderes',
    text:
        'Art. 60, § 4º, III: núcleo intangível. Extinguir o STF e subordiná-lo '
        'ao Executivo suprime a cláusula.',
    kind: CardKind.ataque,
    cost: 2,
    power: 7,
    tags: {CardTag.competencia, CardTag.principio},
    unlock: 'battle4',
    unlockLabel: 'Vença a batalha do Caso 4',
  ),
  ArgumentCard(
    id: 'quorum',
    title: 'Quórum de 3/5',
    text:
        'Art. 60, § 2º: quórum de emenda. Cumpri-lo não dispensa os limites '
        'materiais do § 4º.',
    kind: CardKind.ataque,
    cost: 1,
    power: 5,
    tags: {CardTag.competencia, CardTag.regra},
    unlock: 'battle4',
    unlockLabel: 'Vença a batalha do Caso 4',
  ),
  ArgumentCard(
    id: 'referendo',
    title: 'Referendo não convalida',
    text:
        'Nem a maioria qualificada nem a consulta popular suprimem cláusula '
        'pétrea.',
    kind: CardKind.ataque,
    cost: 1,
    power: 5,
    tags: {CardTag.competencia},
    unlock: 'battle4',
    unlockLabel: 'Vença a batalha do Caso 4',
  ),
  ArgumentCard(
    id: 'ms-32033',
    title: 'MS 32.033',
    text:
        'Controle preventivo de PEC: o STF examina o vício antes da '
        'deliberação parlamentar.',
    kind: CardKind.defesa,
    cost: 2,
    block: 8,
    precedent: 'MS 32.033',
    tags: {CardTag.precedente, CardTag.competencia},
    unlock: 'battle4',
    unlockLabel: 'Vença a batalha do Caso 4',
  ),
  ArgumentCard(
    id: 'independencia',
    title: 'Independência judicial',
    text:
        'Sem Judiciário independente não há separação de Poderes nem proteção '
        'de direitos.',
    kind: CardKind.defesa,
    cost: 1,
    block: 6,
    tags: {CardTag.competencia, CardTag.principio},
    unlock: 'battle4',
    unlockLabel: 'Vença a batalha do Caso 4',
  ),

  // ------------------------------------------------------- recompensa battle5
  ArgumentCard(
    id: 'parecer-ministro',
    title: 'Parecer do ministro',
    text:
        'Síntese do gabinete: vício formal antes da votação, não apenas vício '
        'material depois.',
    kind: CardKind.ataque,
    cost: 3,
    power: 10,
    tags: {CardTag.precedente, CardTag.competencia},
    unlock: 'battle5',
    unlockLabel: 'Vença a batalha do Caso 5',
  ),

  // -------------------------------------------------------- recompensa check3
  ArgumentCard(
    id: 'proporcionalidade',
    title: 'Três testes',
    text:
        'Adequação, necessidade e proporcionalidade em sentido estrito: o '
        'roteiro da ponderação.',
    kind: CardKind.ataque,
    cost: 2,
    power: 7,
    tags: {CardTag.proporcionalidade, CardTag.principio},
    unlock: 'check3',
    unlockLabel: 'Conclua a aplicação dos três testes',
  ),
  ArgumentCard(
    id: 'minimo-existencial',
    title: 'Mínimo existencial',
    text:
        'A reserva do possível não elimina o dever estatal de garantir o '
        'essencial.',
    kind: CardKind.ataque,
    cost: 2,
    power: 7,
    tags: {CardTag.proporcionalidade, CardTag.principio},
    unlock: 'check3',
    unlockLabel: 'Conclua a aplicação dos três testes',
  ),
  ArgumentCard(
    id: 'reserva-possivel',
    title: 'Reserva do possível',
    text:
        'É limite real, mas entra na ponderação: não é cheque em branco nem '
        'prevalência automática do orçamento.',
    kind: CardKind.defesa,
    cost: 2,
    block: 7,
    tags: {CardTag.proporcionalidade},
    unlock: 'check3',
    unlockLabel: 'Conclua a aplicação dos três testes',
  ),
  ArgumentCard(
    id: 'saude',
    title: 'Direito à saúde',
    text:
        'Art. 6º e 196. Se o fármaco trata a doença, é meio adequado de '
        'realizar o direito.',
    kind: CardKind.ataque,
    cost: 1,
    power: 5,
    tags: {CardTag.principio, CardTag.proporcionalidade},
    unlock: 'check3',
    unlockLabel: 'Conclua a aplicação dos três testes',
  ),

  // ----------------------------------------------------------- recompensa quiz
  ArgumentCard(
    id: 'gabarito',
    title: 'Gabarito do ministro',
    text:
        'Parecer fechado: regra se aplica por subsunção, princípio por '
        'ponderação, texto é limite da mutação.',
    kind: CardKind.ataque,
    cost: 3,
    power: 10,
    tags: {CardTag.precedente, CardTag.doutrina},
    unlock: 'quiz',
    unlockLabel: 'Conclua o teste final',
  ),
];

final Map<String, ArgumentCard> _cardsById = {
  for (final card in allCards) card.id: card,
};

ArgumentCard? cardById(String id) => _cardsById[id];

/// Cartas disponíveis antes de qualquer conquista.
List<ArgumentCard> get starterCards =>
    allCards.where((c) => c.unlock == null).toList();

/// Cartas liberadas por uma etapa concluída.
List<ArgumentCard> cardsUnlockedBy(String stage) =>
    allCards.where((c) => c.unlock == stage).toList();

/// Todas as etapas que desbloqueiam alguma carta, na ordem de apresentação.
const List<String> unlockStages = [
  'battle1',
  'check1',
  'battle2',
  'check2',
  'theory2',
  'battle3',
  'battle4',
  'battle5',
  'check3',
  'quiz',
];
