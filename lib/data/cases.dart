import '../models/content.dart';

/// Os quatro casos práticos do roteiro original.
const List<CaseStudy> caseStudies = [
  CaseStudy(
    id: 'case1',
    number: 'Caso 1',
    title: 'O candidato de 34 anos',
    body:
        'João tem 34 anos e quer se candidatar a Presidente da República. '
        'A Constituição exige idade mínima de 35 anos (art. 14, § 3º, VI, "a"). '
        'Os advogados dele argumentam que a soberania popular e o pluralismo '
        'político são princípios fundamentais e que, "ponderados", deveriam '
        'permitir a candidatura.',
    question: 'Como devemos tratar a exigência de 35 anos?',
    nextLabel: 'Entender a diferença',
    feedbackTitle: 'Feedback do Caso 1',
    choices: [
      Choice(
        id: 'A',
        text:
            'É um princípio: deve ser ponderado com a soberania popular no '
            'caso concreto.',
        correct: false,
        feedback: [
          'Quase. Soberania popular é um princípio, mas a idade mínima não. '
              'Ela não admite "mais ou menos": é uma regra, aplicada por '
              'subsunção. Ponderar uma regra assim esvaziaria a segurança '
              'jurídica que ela existe para garantir.',
        ],
      ),
      Choice(
        id: 'B',
        text:
            'É uma regra: aplica-se no "tudo ou nada", e a candidatura não é '
            'possível.',
        correct: true,
        feedback: [
          'Isso mesmo! A idade mínima é uma regra: descreve uma conduta e uma '
              'consequência de forma precisa. Ou a pessoa tem 35 anos, ou não '
              'tem. Regras se aplicam por subsunção: o fato se encaixa na '
              'hipótese e a consequência vem. O constituinte já fez a '
              'ponderação ao fixar o número.',
        ],
      ),
      Choice(
        id: 'C',
        text: 'É uma regra, mas qualquer princípio fundamental prevalece sobre ela.',
        correct: false,
        feedback: [
          'Cuidado. Regras e princípios não têm hierarquia automática entre '
              'si, e as normas constitucionais originárias têm o mesmo status '
              '(princípio da unidade da Constituição). A idade mínima é uma '
              'regra, aplicada por subsunção.',
        ],
      ),
    ],
  ),
  CaseStudy(
    id: 'case2',
    number: 'Caso 2',
    title: 'A biografia não autorizada',
    body:
        'Uma jornalista escreveu a biografia de um cantor famoso, com base em '
        'entrevistas e documentos públicos. O cantor não autorizou a obra e '
        'pede que o livro seja proibido antes de ser lançado, alegando '
        'violação à sua intimidade e vida privada (art. 5º, X). A editora '
        'invoca a liberdade de expressão e o direito à informação (art. 5º, '
        'IV, IX e XIV; art. 220).',
    question: 'Qual o caminho correto para decidir?',
    nextLabel: 'Próximo processo',
    feedbackTitle: 'Feedback do Caso 2',
    choices: [
      Choice(
        id: 'A',
        text:
            'Aplicar o critério hierárquico: a intimidade está antes no texto, '
            'então prevalece.',
        correct: false,
        feedback: [
          'Não há hierarquia entre direitos fundamentais pela ordem em que '
              'aparecem no texto. Esse critério só serve para conflito entre '
              'normas de níveis diferentes. Aqui, temos uma colisão de '
              'princípios, resolvida por ponderação no caso concreto.',
        ],
      ),
      Choice(
        id: 'B',
        text:
            'Declarar que um dos dois direitos é inválido para este caso e '
            'retirá-lo do sistema.',
        correct: false,
        feedback: [
          'Isso seria tratar princípios como regras. Na colisão, os dois '
              'continuam válidos; um apenas prevalece naquele caso. Em outro '
              'caso (por exemplo, a divulgação de dados médicos sem interesse '
              'público), o peso pode se inverter.',
        ],
      ),
      Choice(
        id: 'C',
        text:
            'Ponderar os princípios no caso concreto: a liberdade de expressão '
            'prevalece contra a censura prévia, e eventuais abusos são '
            'reparados depois.',
        correct: true,
        feedback: [
          'Perfeito! Isso é colisão de princípios, resolvida por ponderação. '
              'Foi o que o STF fez na ADI 4815 (2015): deu interpretação '
              'conforme à Constituição aos arts. 20 e 21 do Código Civil e '
              'afastou a exigência de autorização prévia para biografias. A '
              'intimidade continua válida e protegida: quem se sentir lesado '
              'pode buscar indenização e direito de resposta depois.',
        ],
        note: InfoBox(
          title: 'Os três testes da proporcionalidade, aplicados ao caso',
          bullets: [
            'Adequação: proibir o livro protege a intimidade? Sim.',
            'Necessidade: existe meio menos gravoso? Sim: a indenização e o '
                'direito de resposta posteriores.',
            'Proporcionalidade em sentido estrito: o ganho para a intimidade '
                'justifica a censura prévia? Não.',
          ],
        ),
      ),
    ],
  ),
  CaseStudy(
    id: 'case3',
    number: 'Caso 3',
    title: '"Entre o homem e a mulher"',
    body:
        'O art. 226, § 3º, da Constituição reconhece "a união estável entre o '
        'homem e a mulher como entidade familiar". O art. 1.723 do Código '
        'Civil repete a mesma fórmula. Um casal de duas mulheres, juntas há 12 '
        'anos, pede o reconhecimento da união estável. O texto constitucional '
        'nunca foi alterado.',
    question: 'O STF pode reconhecer essa união sem emenda constitucional?',
    nextLabel: 'Próximo processo',
    feedbackTitle: 'Feedback do Caso 3',
    choices: [
      Choice(
        id: 'A',
        text: 'Não. Só uma emenda (art. 60) pode mudar o sentido do texto.',
        correct: false,
        feedback: [
          'A emenda é a via formal, mas não a única forma de a Constituição '
              'evoluir. Aqui o STF mudou o sentido sem mudar o texto, por '
              'interpretação sistemática com os princípios da dignidade e da '
              'igualdade. Isso é mutação.',
        ],
      ),
      Choice(
        id: 'B',
        text:
            'Sim. A leitura do texto à luz da dignidade, da igualdade e da '
            'vedação à discriminação permite reconhecer a união sem mudar uma '
            'palavra.',
        correct: true,
        feedback: [
          'Exato! No julgamento conjunto da ADPF 132 e da ADI 4277 (2011), o '
              'STF, por unanimidade, deu interpretação conforme à Constituição '
              'ao art. 1.723 do Código Civil. Reconheceu a união contínua, '
              'pública e duradoura entre pessoas do mesmo sexo como entidade '
              'familiar. O texto do art. 226, § 3º, continuou igual. É um dos '
              'exemplos mais citados de mutação constitucional pela via '
              'interpretativa.',
        ],
        note: InfoBox(
          title: 'Para pensar',
          text:
              'Parte da doutrina critica esse julgamento, por entender que '
              '"homem e mulher" seria um limite textual. É justamente esse '
              'debate que o próximo caso explora.',
        ),
      ),
      Choice(
        id: 'C',
        text:
            'Sim, porque o STF pode reescrever qualquer dispositivo da '
            'Constituição quando a sociedade muda.',
        correct: false,
        feedback: [
          'O resultado está certo, mas o fundamento não. A mutação tem '
              'limites: não pode contrariar o texto expresso nem os princípios '
              'fundamentais. O STF não "reescreve" a Constituição; ele '
              'interpreta dentro do que o texto e o sistema permitem.',
        ],
      ),
    ],
  ),
  CaseStudy(
    id: 'case4',
    number: 'Caso 4',
    title: 'Os limites da mutação',
    disclaimer: 'Caso hipotético, criado apenas para este exercício.',
    body:
        'Um tribunal decide que, com a tecnologia, o "voto secreto" previsto '
        'na Constituição (art. 14, caput, e art. 60, § 4º, II) "passou a '
        'significar" um voto registrado com o nome do eleitor, para facilitar '
        'auditorias. O texto continua dizendo "voto secreto".',
    question: 'Como classificar essa decisão?',
    nextLabel: 'Próximo processo',
    feedbackTitle: 'Feedback do Caso 4',
    choices: [
      Choice(
        id: 'A',
        text:
            'Mutação constitucional válida: o sentido mudou com a sociedade e '
            'o texto ficou igual.',
        correct: false,
        feedback: [
          'Cuidado: texto igual não basta. A mutação precisa caber dentro das '
              'possibilidades do texto. Quando o novo sentido é o oposto do '
              'que o texto diz, há mutação inconstitucional.',
        ],
      ),
      Choice(
        id: 'B',
        text: 'Seria válida se fosse feita por emenda constitucional.',
        correct: false,
        feedback: [
          'Nem por emenda. O voto direto, secreto, universal e periódico está '
              'entre as cláusulas pétreas (art. 60, § 4º, II). Uma emenda '
              'tendente a aboli-lo não pode sequer ser objeto de deliberação.',
        ],
      ),
      Choice(
        id: 'C',
        text:
            'Mutação inconstitucional: contraria o texto expresso e atinge uma '
            'cláusula pétrea, o que nem uma emenda poderia fazer.',
        correct: true,
        feedback: [
          'Isso! A mutação tem limites. "Secreto" e "identificado" são '
              'sentidos opostos: a decisão não interpreta o texto, ela o '
              'contraria. Além disso, o voto secreto é cláusula pétrea '
              '(art. 60, § 4º, II): nem uma emenda poderia aboli-lo.',
        ],
        note: InfoBox(
          title: 'Debate real',
          text:
              'O mesmo problema apareceu no STF com o art. 52, X, que dá ao '
              'Senado o papel de suspender leis declaradas inconstitucionais '
              'pelo STF em controle difuso. Na Rcl 4335/AC, os ministros Gilmar '
              'Mendes e Eros Grau defenderam que esse dispositivo teria sofrido '
              'mutação, e o Senado passaria só a dar publicidade à decisão. '
              'Críticos como Lenio Streck chamaram a tese de mutação '
              'inconstitucional. O tema voltou nas ADIs 3406 e 3470 (2017).',
        ),
      ),
    ],
  ),
  CaseStudy(
    id: 'case5',
    number: 'Caso 5',
    title: 'A emenda que queria extinguir o STF',
    disclaimer: 'Caso hipotético, criado apenas para este exercício.',
    body:
        'Uma proposta de emenda constitucional, aprovada em dois turnos, por '
        '3/5 dos votos em cada Casa, pretende extinguir o Supremo Tribunal '
        'Federal e transferir suas competências a um conselho indicado pelo '
        'Executivo. Os defensores argumentam que a soberania popular legitima '
        'qualquer mudança e que o quórum do art. 60, § 2º, foi respeitado.',
    question: 'Como o gabinete deve orientar o voto?',
    nextLabel: 'Aplicar a proporcionalidade',
    feedbackTitle: 'Feedback do Caso 5',
    choices: [
      Choice(
        id: 'A',
        text:
            'É válida: o quórum do art. 60, § 2º, foi cumprido e a vontade '
            'popular legitima a mudança.',
        correct: false,
        feedback: [
          'Quórum não é tudo. O art. 60, § 4º, lista o que não pode nem ser '
              'objeto de deliberação: a forma federativa de Estado, o voto '
              'direto, secreto, universal e periódico, a separação dos Poderes '
              'e os direitos e garantias individuais. Esses limites valem para '
              'a emenda, não só para a interpretação.',
        ],
      ),
      Choice(
        id: 'B',
        text:
            'A PEC não pode nem ser objeto de deliberação: ela suprime a '
            'separação dos Poderes, cláusula pétrea do art. 60, § 4º, III.',
        correct: true,
        feedback: [
          'Exato. Extinguir o STF e subordinar suas funções ao Executivo '
              'elimina a separação dos Poderes, núcleo intangível do '
              'art. 60, § 4º, III. Uma PEC com esse conteúdo não pode sequer '
              'ser deliberada: é inconstitucionalidade que nasce antes da '
              'votação, não depois.',
        ],
        note: InfoBox(
          title: 'Parecer do gabinete',
          bullets: [
            'Cláusulas pétreas limitam o poder de reforma, não a interpretação '
                'evolutiva.',
            'Aqui não há mutação: há tentativa de reforma proibida.',
            'Vício formal (deliberação vedada), não apenas vício material.',
          ],
        ),
      ),
      Choice(
        id: 'C',
        text: 'É válida, mas só depois de referendo popular.',
        correct: false,
        feedback: [
          'Referendo não convalida cláusula pétrea. O art. 60, § 4º, é limite '
              'ao poder de reforma; nem a maioria qualificada nem a consulta '
              'popular podem suprimir a separação dos Poderes. O controle '
              'preventivo do STF (MS 32.033) existe justamente para barrar '
              'propostas desse tipo.',
        ],
      ),
    ],
  ),
];

CaseStudy? caseById(String id) {
  for (final c in caseStudies) {
    if (c.id == id) return c;
  }
  return null;
}
