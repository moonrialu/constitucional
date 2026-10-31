import '../models/content.dart';
import '../models/mutation.dart';

/// Conteúdo do OVA 2 — Mutação constitucional no gabinete do STF.
///
/// Fonte: roteiro "Roteiro OVA 2 - Mutação Constitucional" (Direito
/// Constitucional I, Faculdade Baiana de Direito, 2026.2).

/// Tela 1 — capa.
const String mutationCoverTitle =
    'Mutação constitucional: quando a Constituição muda sem mudar uma palavra';

const String mutationCoverLead =
    'Você foi nomeado(a) assessor(a) no gabinete de um ministro do STF. '
    'Nos próximos 15 minutos, quatro processos vão testar uma pergunta: a '
    'Constituição pode mudar de sentido sem que o Congresso altere o texto? '
    'E até onde isso pode ir?';

/// Tela 2 — objetivos.
const List<String> mutationObjectives = [
  'Explicar por que texto e norma não são a mesma coisa.',
  'Diferenciar mutação, reforma e simples interpretação.',
  'Reconhecer os meios pelos quais a mutação acontece.',
  'Analisar casos reais do STF descritos como mutação.',
  'Identificar quando uma “mutação” se torna inconstitucional.',
];

const String mutationHowToPlay =
    'Leia o caso, escolha uma resposta e receba a explicação. Cada erro traz '
    'o porquê e devolve você ao caminho. No fim, cinco questões fecham o '
    'diagnóstico do gabinete.';

/// Telas 3, 9 e 12 — casos.
const List<MutationCase> mutationCases = [
  MutationCase(
    id: 'case1',
    number: 'Processo 1 · Caso 1',
    title: '“Entre o homem e a mulher”',
    body:
        'O art. 226, § 3º, da Constituição diz: “Para efeito da proteção do '
        'Estado, é reconhecida a união estável entre o homem e a mulher como '
        'entidade familiar”. Ana e Beatriz vivem juntas há 12 anos, de forma '
        'pública e contínua, e pedem o reconhecimento da união estável. Esse '
        'texto nunca foi alterado por emenda.',
    question: 'Antes de qualquer teoria, qual sua intuição?',
    nextLabel: 'Entender o fenômeno',
    choices: [
      MutationChoice(
        id: 'A',
        text:
            'O pedido deve ser negado: o texto fala em “homem e mulher”, e só '
            'uma emenda pode mudar isso.',
        correct: false,
        feedback: [
          'É uma leitura possível, e parte da doutrina defende exatamente '
              'isso. Mas o STF entendeu que o texto precisa ser lido em '
              'conjunto com os princípios fundamentais (art. 1º, III; art. 3º, '
              'IV; art. 5º, caput).',
          'Assim, o Tribunal mudou o sentido sem mudar o texto. A pergunta '
              'que fica é: se o texto não mudou, o que mudou?',
        ],
      ),
      MutationChoice(
        id: 'B',
        text:
            'O pedido pode ser acolhido: o texto deve ser lido junto com a '
            'dignidade, a igualdade e a proibição de discriminação.',
        correct: true,
        feedback: [
          'Foi isso que o STF decidiu, por unanimidade, no julgamento conjunto '
              'da ADPF 132 e da ADI 4277 (maio de 2011). O Tribunal deu '
              'interpretação conforme à Constituição ao art. 1.723 do Código '
              'Civil e reconheceu a união entre pessoas do mesmo sexo como '
              'entidade familiar.',
          'Nenhuma palavra do art. 226, § 3º, mudou. O que mudou foi o sentido '
              'atribuído a ele.',
        ],
      ),
      MutationChoice(
        id: 'C',
        text:
            'O pedido pode ser acolhido porque o STF pode reescrever o artigo '
            'quando quiser.',
        correct: false,
        feedback: [
          'O resultado bate, mas o fundamento não. O STF não pode reescrever a '
              'Constituição: ele interpreta. E essa interpretação tem limites, '
              'como você verá no Caso 4.',
          'A decisão de 2011 foi uma interpretação conforme: o texto foi lido '
              'à luz dos princípios fundamentais, sem alteração de uma vírgula.',
        ],
      ),
    ],
    reflection: InfoBox(
      title: 'Pergunta que fica',
      text:
          'Se o texto não mudou, o que mudou? A próxima tela responde com a '
          'distinção entre texto e norma.',
    ),
  ),
  MutationCase(
    id: 'case3',
    number: 'Processo 2 · Caso 3',
    title: '“O Senado só publica?”',
    body:
        'O art. 52, X, diz que compete privativamente ao Senado “suspender a '
        'execução, no todo ou em parte, de lei declarada inconstitucional por '
        'decisão definitiva do Supremo Tribunal Federal”. Tradicionalmente, '
        'isso significava: quando o STF declara uma lei inconstitucional em um '
        'caso concreto (controle difuso), a decisão vale só para as partes. '
        'Para valer para todos, o Senado precisa suspender a lei.\n\n'
        'O ministro recebe um parecer dizendo: “Com o fortalecimento do STF, a '
        'decisão do Plenário já vale para todos. O Senado agora só dá '
        'publicidade à decisão.”',
    question: 'Como você classifica a tese do parecer?',
    nextLabel: 'Entender os limites',
    choices: [
      MutationChoice(
        id: 'A',
        text: 'É reforma constitucional: o texto do art. 52, X, foi alterado.',
        correct: false,
        feedback: [
          'O texto do art. 52, X, nunca foi alterado por emenda. A mudança '
              'proposta é de sentido, e não de texto: por isso se fala em '
              'mutação.',
        ],
      ),
      MutationChoice(
        id: 'B',
        text:
            'É uma tese de mutação constitucional: o texto continua igual, mas '
            'o papel do Senado passa a ser lido de outro modo. A tese é '
            'polêmica justamente por testar o limite do texto.',
        correct: true,
        feedback: [
          'Exatamente. Essa tese foi defendida no STF e virou o debate mais '
              'famoso sobre mutação no Brasil.',
          'Ela mostra o potencial e o risco do fenômeno: o mesmo texto passa a '
              'ser lido de outro modo, sem emenda, mas a nova leitura precisa '
              'caber nas possibilidades das palavras.',
        ],
      ),
      MutationChoice(
        id: 'C',
        text: 'É interpretação comum, sem nenhuma mudança de sentido.',
        correct: false,
        feedback: [
          'Há mudança de sentido, sim: o Senado deixaria de dar eficácia geral '
              'à decisão e passaria só a divulgá-la. Essa mudança de sentido, '
              'com o texto igual, é o que caracteriza a mutação.',
        ],
      ),
    ],
    timeline: MutationTimeline(
      title: 'A história real em dois momentos',
      entries: [
        TimelineEntry(
          year: '2014',
          judgment: 'Rcl 4335/AC · rel. Min. Gilmar Mendes',
          description:
              'Gilmar Mendes e Eros Grau defenderam a mutação do art. 52, X. '
              'Sepúlveda Pertence, Joaquim Barbosa, Ricardo Lewandowski e '
              'Marco Aurélio rejeitaram a tese. A reclamação foi julgada '
              'procedente por outro fundamento: a superveniente Súmula '
              'Vinculante 26.',
        ),
        TimelineEntry(
          year: '2017',
          judgment: 'ADIs 3406 e 3470 (amianto) · rel. Min. Rosa Weber',
          description:
              'O STF declarou incidentalmente inconstitucional o art. 2º da '
              'Lei 9.055/1995, com efeito vinculante e erga omnes. Gilmar '
              'Mendes falou em “releitura” do art. 52, X; Celso de Mello disse '
              'que o STF promoveu uma verdadeira mutação constitucional. Marco '
              'Aurélio divergiu.',
        ),
      ],
    ),
    reflection: InfoBox(
      title: 'Para pensar',
      text:
          'Na Rcl 4335, Sepúlveda Pertence advertiu contra a tese; para os '
          'críticos, como Lenio Streck, ela retirava do Senado uma competência '
          'escrita na Constituição, o que seria mutação inconstitucional. Você '
          'concorda? O próximo processo trata justamente desses limites.',
    ),
  ),
  MutationCase(
    id: 'case4',
    number: 'Processo 4 · Caso 4',
    title: 'O “voto secreto” reinterpretado',
    disclaimer:
        'Caso hipotético, criado para o exercício. Não houve decisão real '
        'nesses termos.',
    body:
        'Um tribunal decide que, com as novas tecnologias, o “voto secreto” '
        'previsto na Constituição (art. 14, caput, e art. 60, § 4º, II) '
        '“passou a significar” um voto registrado com o nome do eleitor, para '
        'facilitar auditorias. O texto continua dizendo “voto secreto”. Os '
        'autores da decisão afirmam: “é apenas uma mutação constitucional”.',
    question: 'Como classificar essa decisão?',
    nextLabel: 'Ir para o teste final',
    choices: [
      MutationChoice(
        id: 'A',
        text:
            'Mutação constitucional válida: o texto ficou igual e o sentido '
            'acompanhou a tecnologia.',
        correct: false,
        feedback: [
          'Cuidado: texto igual não basta. A mutação precisa caber dentro das '
              'possibilidades do texto. Aqui o novo sentido é o oposto do que '
              'o texto diz: é mutação inconstitucional.',
        ],
      ),
      MutationChoice(
        id: 'B',
        text: 'Seria válida se feita por emenda constitucional.',
        correct: false,
        feedback: [
          'Nem por emenda. O voto direto, secreto, universal e periódico é '
              'cláusula pétrea: uma proposta de emenda tendente a aboli-lo não '
              'pode sequer ser deliberada.',
        ],
      ),
      MutationChoice(
        id: 'C',
        text:
            'Mutação inconstitucional: contraria o texto expresso e atinge uma '
            'cláusula pétrea, que nem uma emenda poderia abolir.',
        correct: true,
        feedback: [
          'Isso! “Secreto” e “identificado” são sentidos opostos: a decisão '
              'não interpreta o texto, ela o contraria. E o voto secreto é '
              'cláusula pétrea (art. 60, § 4º, II).',
          'Chamar isso de mutação não muda a sua natureza: o texto é o limite '
              'da interpretação.',
        ],
      ),
    ],
    timeline: MutationTimeline(
      title: 'Debate real: prisão após condenação em segunda instância',
      entries: [
        TimelineEntry(
          year: '2009',
          judgment: 'HC 84.078',
          description:
              'Prisão para cumprimento da pena só após o trânsito em julgado.',
        ),
        TimelineEntry(
          year: '2016',
          judgment: 'HC 126.292 · rel. Min. Teori Zavascki',
          description:
              'Admitida a execução da pena após condenação em segunda '
              'instância.',
        ),
        TimelineEntry(
          year: '2019',
          judgment: 'ADCs 43, 44 e 54 · 6 votos a 5',
          description:
              'Volta a exigência do trânsito em julgado; declarada a '
              'constitucionalidade do art. 283 do CPP.',
        ),
      ],
    ),
    reflection: InfoBox(
      title: 'Pergunta para reflexão',
      text:
          'O art. 5º, LVII, diz que “ninguém será considerado culpado até o '
          'trânsito em julgado de sentença penal condenatória”. O texto nunca '
          'mudou, mas o STF mudou de entendimento três vezes. A decisão de '
          '2016 foi uma mutação legítima ou contrariou a expressão “até o '
          'trânsito em julgado”? Três mudanças em dez anos mostram também o '
          'risco de insegurança jurídica.',
    ),
  ),
];

/// Telas 5, 6 e 11 — teoria.
const List<MutationTheory> mutationTheory = [
  MutationTheory(
    id: 'theory1',
    kicker: 'Teoria 1 · texto e norma',
    title:
        'O texto é o ponto de partida. A norma é o sentido que se extrai dele.',
    lead:
        'O mesmo texto pode gerar normas diferentes ao longo do tempo, '
        'conforme a realidade social e a interpretação mudam.',
    nextLabel: 'Mutação, reforma e interpretação',
    paragraphs: [
      'Friedrich Müller descreve isso como a diferença entre o texto da norma '
          'e a norma, que só surge quando o texto é interpretado diante de um '
          'caso concreto. É essa distância entre texto e norma que torna a '
          'mutação possível.',
      'Princípios, por serem mais abertos (dignidade, igualdade), são o '
          'principal motor da mutação: eles “puxam” o sentido das regras. Foi '
          'o que aconteceu no Caso 1. Regras com conteúdo preciso (“35 anos”, '
          '“voto secreto”) deixam pouco espaço para mudança de sentido.',
    ],
    concept: InfoBox(
      title: 'Conceito',
      text:
          'Mutação constitucional é o processo informal de mudança da '
          'Constituição, em que se altera o sentido, o significado ou o '
          'alcance de suas normas sem qualquer alteração do texto.',
    ),
    authorHeading: 'De onde vem a ideia',
    authors: [
      AuthorCard(
        name: 'Paul Laband e Georg Jellinek',
        text:
            'Alemanha, fim do séc. XIX e início do séc. XX. Observaram que a '
            'Constituição alemã mudava na prática sem emendas. Jellinek chamou '
            'o fenômeno de Verfassungswandlung.',
      ),
      AuthorCard(
        name: 'Konrad Hesse',
        text:
            'A mutação é legítima apenas dentro das possibilidades do texto; '
            'fora dele, deixa de ser interpretação.',
      ),
      AuthorCard(
        name: 'Anna Cândida da Cunha Ferraz',
        text:
            'Brasil, 1986. Em Processos informais de mudança da Constituição, '
            'sistematizou o tema no país e insistiu que a mutação não pode '
            'violar a letra nem o espírito da Constituição.',
      ),
    ],
  ),
  MutationTheory(
    id: 'theory2',
    kicker: 'Teoria 2 · comparar para não confundir',
    title: 'Mutação, reforma e interpretação',
    lead:
        'Na mutação, o texto fica igual e o sentido muda. Na reforma, o texto '
        'muda. Na interpretação comum, nada muda: apenas se aplica o sentido '
        'já aceito.',
    nextLabel: 'Classificar três situações',
    table: MutationTable(
      columns: ['Reforma', 'Mutação', 'Interpretação comum'],
      rows: [
        MutationTableRow(
          label: 'O que muda',
          cells: [
            'O texto',
            'O sentido de um texto já interpretado de outro modo',
            'Nada muda: apenas se aplica o sentido já aceito',
          ],
        ),
        MutationTableRow(
          label: 'Via',
          cells: [
            'Formal: emenda (art. 60) ou revisão (art. 3º do ADCT)',
            'Informal',
            'Atividade cotidiana de aplicação',
          ],
        ),
        MutationTableRow(
          label: 'Quem faz',
          cells: [
            'Congresso Nacional (3/5, dois turnos em cada Casa)',
            'Juízes, Legislativo, Executivo e a própria sociedade',
            'Qualquer intérprete',
          ],
        ),
        MutationTableRow(
          label: 'Exemplo',
          cells: [
            'EC 45/2004 (Reforma do Judiciário)',
            'ADPF 132 / ADI 4277',
            'Aplicar a idade mínima de 35 anos a um candidato',
          ],
        ),
      ],
    ),
    cardHeading: 'Os meios da mutação',
    cards: [
      MutationCard(
        title: 'Interpretação judicial',
        text:
            'O tribunal passa a ler o mesmo dispositivo de outro modo. É o meio '
            'mais estudado no Brasil (Caso 1 e Caso 3).',
      ),
      MutationCard(
        title: 'Interpretação legislativa',
        text:
            'O legislador, ao regulamentar a Constituição, fixa um sentido novo '
            'para um dispositivo.',
      ),
      MutationCard(
        title: 'Costume e práticas institucionais',
        text:
            'Comportamentos reiterados dos Poderes mudam a forma como uma norma '
            'é aplicada.',
      ),
    ],
    tip: InfoBox(
      title: 'Dica de prova',
      text:
          'Na mutação, o texto fica igual e o sentido muda. Na reforma, o texto '
          'muda. Se o novo sentido contraria o texto, não é mutação legítima: '
          'é mutação inconstitucional.',
    ),
  ),
  MutationTheory(
    id: 'theory3',
    kicker: 'Teoria 3 · os limites',
    title: 'A mutação é legítima enquanto interpreta o texto.',
    lead: 'Quando passa a contrariá-lo, vira usurpação do poder constituinte.',
    nextLabel: 'Último processo',
    cardHeading: 'Os limites da mutação',
    cards: [
      MutationCard(
        title: '1. O texto',
        text:
            'O novo sentido precisa caber nas possibilidades das palavras. Não '
            'se pode ler “secreto” como “identificado”.',
      ),
      MutationCard(
        title: '2. Princípios fundamentais e cláusulas pétreas',
        text:
            'Se nem uma emenda pode aboli-los (art. 60, § 4º), uma mutação '
            'também não pode.',
      ),
      MutationCard(
        title: '3. Separação de Poderes',
        text:
            'O intérprete não pode retirar de um Poder uma competência que a '
            'Constituição lhe deu expressamente.',
      ),
    ],
    concept: InfoBox(
      title: 'Conceito-chave',
      text:
          'Mutação inconstitucional é a mudança informal que ultrapassa esses '
          'limites. O texto continua igual, mas o sentido atribuído o '
          'contraria.',
    ),
    tip: InfoBox(
      title: 'Por que isso importa',
      text:
          'Quem altera a Constituição pela via formal é o Congresso, eleito e '
          'sujeito a um processo rígido (3/5, dois turnos). Se a mutação não '
          'tivesse limites, essa rigidez perderia o sentido, e a segurança '
          'jurídica também.',
    ),
  ),
];

/// Tela 7 — classificação (Caso 2).
const MutationCheck mutationCheck = MutationCheck(
  id: 'check2',
  kicker: 'Caso 2 · a triagem do gabinete',
  title: 'Três papéis chegaram à sua mesa. Classifique cada um.',
  lead:
      'Leia cada situação e escolha: reforma, mutação ou mutação '
      'inconstitucional.',
  nextLabel: 'Conferir a triagem',
  items: [
    MutationCheckItem(
      id: 's1',
      prompt:
          'Situação 1 — O Congresso aprova uma emenda que acrescenta um novo '
          'inciso ao art. 5º, criando um novo direito fundamental.',
      correct: 'R',
      feedback:
          'É reforma. O texto foi alterado pela via formal do art. 60. Mutação '
          'nunca mexe no texto.',
      options: [
        MutationCheckOption(id: 'R', text: 'Reforma'),
        MutationCheckOption(id: 'M', text: 'Mutação'),
        MutationCheckOption(id: 'I', text: 'Mutação inconstitucional'),
      ],
    ),
    MutationCheckItem(
      id: 's2',
      prompt:
          'Situação 2 — Sem qualquer alteração no texto, o STF passa a '
          'entender que um dispositivo, antes lido de forma restrita, alcança '
          'situações que a sociedade antes não reconhecia, com apoio nos '
          'princípios da dignidade e da igualdade.',
      correct: 'M',
      feedback:
          'É mutação. O texto fica igual, o sentido muda, e a nova leitura cabe '
          'dentro das palavras do dispositivo, com apoio nos princípios.',
      options: [
        MutationCheckOption(id: 'R', text: 'Reforma'),
        MutationCheckOption(id: 'M', text: 'Mutação'),
        MutationCheckOption(id: 'I', text: 'Mutação inconstitucional'),
      ],
    ),
    MutationCheckItem(
      id: 's3',
      prompt:
          'Situação 3 — Uma lei estabelece que, onde a Constituição diz “é '
          'vedado”, deve-se ler “é permitido em casos de urgência”.',
      correct: 'I',
      feedback:
          'É mutação inconstitucional. “Vedado” e “permitido” são opostos: a '
          'lei não interpreta, ela contraria o texto. Além disso, uma lei não '
          'pode alterar a Constituição.',
      options: [
        MutationCheckOption(id: 'R', text: 'Reforma'),
        MutationCheckOption(id: 'M', text: 'Mutação'),
        MutationCheckOption(id: 'I', text: 'Mutação inconstitucional'),
      ],
    ),
  ],
  note: InfoBox(
    title: 'Resumo visual',
    bullets: [
      'Texto mudou? → Reforma.',
      'Texto igual e sentido cabe nas palavras? → Mutação.',
      'Texto igual, mas sentido contrário às palavras ou aos princípios '
          'fundamentais? → Mutação inconstitucional.',
    ],
  ),
);

/// Tela 14 — teste final.
const List<MutationQuizQuestion> mutationQuiz = [
  MutationQuizQuestion(
    id: 'q1',
    number: 1,
    statement: 'O que diferencia a mutação da reforma constitucional?',
    correct: 'B',
    reviewStepId: 'theory2',
    reviewLabel: 'Mutação, reforma e interpretação',
    feedback:
        'Reforma é a via formal do art. 60, que altera o texto. A mutação é '
        'informal e mantém o texto.',
    choices: [
      MutationQuizChoice(id: 'A', text: 'A mutação é feita só pelo Congresso.'),
      MutationQuizChoice(
        id: 'B',
        text:
            'Na mutação, muda o sentido e o texto permanece; na reforma, o '
            'texto é alterado.',
      ),
      MutationQuizChoice(
        id: 'C',
        text: 'A reforma é informal e a mutação é formal.',
      ),
    ],
  ),
  MutationQuizQuestion(
    id: 'q2',
    number: 2,
    statement: 'Por que a mutação é possível?',
    correct: 'A',
    reviewStepId: 'theory1',
    reviewLabel: 'Texto não é norma',
    feedback:
        'A norma é o sentido extraído do texto. A CF/88 é rígida, e o STF não '
        'altera o texto: interpreta.',
    choices: [
      MutationQuizChoice(
        id: 'A',
        text:
            'Porque texto e norma não se confundem: o mesmo texto pode gerar '
            'sentidos diferentes ao longo do tempo.',
      ),
      MutationQuizChoice(
        id: 'B',
        text: 'Porque o STF pode alterar o texto da Constituição.',
      ),
      MutationQuizChoice(
        id: 'C',
        text: 'Porque a Constituição de 1988 é flexível.',
      ),
    ],
  ),
  MutationQuizQuestion(
    id: 'q3',
    number: 3,
    statement: 'Qual destes NÃO é um meio de mutação constitucional?',
    correct: 'C',
    reviewStepId: 'theory2',
    reviewLabel: 'Os meios da mutação',
    feedback:
        'Emenda é reforma, pois altera o texto. Interpretação e costume mudam '
        'o sentido sem tocar no texto.',
    choices: [
      MutationQuizChoice(id: 'A', text: 'Interpretação judicial.'),
      MutationQuizChoice(id: 'B', text: 'Costume constitucional.'),
      MutationQuizChoice(id: 'C', text: 'Emenda constitucional.'),
    ],
  ),
  MutationQuizQuestion(
    id: 'q4',
    number: 4,
    statement: 'Na Rcl 4335/AC, a tese de mutação do art. 52, X:',
    correct: 'B',
    reviewStepId: 'case3-feedback',
    reviewLabel: 'O papel do Senado (Caso 3)',
    feedback:
        'A reclamação foi julgada procedente com base na Súmula Vinculante 26. '
        'O tema voltou nas ADIs 3406 e 3470 (2017).',
    choices: [
      MutationQuizChoice(id: 'A', text: 'Foi aprovada por unanimidade.'),
      MutationQuizChoice(
        id: 'B',
        text:
            'Foi defendida por Gilmar Mendes e Eros Grau, mas não formou '
            'maioria.',
      ),
      MutationQuizChoice(id: 'C', text: 'Nunca foi discutida no STF.'),
    ],
  ),
  MutationQuizQuestion(
    id: 'q5',
    number: 5,
    statement: 'Uma “mutação” que atribui ao texto um sentido oposto ao que ele diz é:',
    correct: 'B',
    reviewStepId: 'theory3',
    reviewLabel: 'Os limites da mutação',
    feedback:
        'O texto é o limite da interpretação. Ultrapassá-lo, ou atingir '
        'cláusulas pétreas, configura mutação inconstitucional.',
    choices: [
      MutationQuizChoice(id: 'A', text: 'Legítima, desde que feita pelo STF.'),
      MutationQuizChoice(id: 'B', text: 'Mutação inconstitucional.'),
      MutationQuizChoice(id: 'C', text: 'Reforma constitucional.'),
    ],
  ),
];

/// Tela 15 — faixas de diagnóstico.
const List<DiagnosisBand> mutationDiagnosisBands = [
  DiagnosisBand(
    min: 5,
    max: 5,
    title: 'Gabinete aprovado!',
    message: 'Você domina mutação constitucional.',
    recommendation: 'Releia o debate da segunda instância e forme sua opinião.',
  ),
  DiagnosisBand(
    min: 3,
    max: 4,
    title: 'Bom trabalho, quase lá.',
    message: 'Você já distingue o essencial; revise os pontos indicados.',
    recommendation:
        'Use os atalhos abaixo para voltar às telas de teoria de cada erro.',
  ),
  DiagnosisBand(
    min: 0,
    max: 2,
    title: 'O ministro pediu uma segunda análise.',
    message: 'Vale refazer a jornada desde o Caso 1, com atenção às telas de teoria.',
    recommendation: 'A distinção entre texto e norma é a chave de tudo. Recomece com calma.',
  ),
];

/// Tela 16 — créditos.
const List<CreditMember> mutationCreditsTeam = [
  CreditMember(name: '[Integrante 1]', role: 'Pesquisa e revisão jurídica'),
  CreditMember(name: '[Integrante 2]', role: 'Roteiro e redação'),
  CreditMember(name: '[Integrante 3]', role: 'Design e identidade visual'),
  CreditMember(name: '[Integrante 4]', role: 'Desenvolvimento'),
  CreditMember(name: '[Integrante 5]', role: 'Testes e revisão'),
  CreditMember(name: '[Integrante 6]', role: 'Coordenação'),
];

const List<String> mutationReferences = [
  'BRASIL. Constituição da República Federativa do Brasil de 1988.',
  'FERRAZ, Anna Cândida da Cunha. Processos informais de mudança da '
      'Constituição. São Paulo: Max Limonad, 1986.',
  'HESSE, Konrad. A força normativa da Constituição. Porto Alegre: Sergio '
      'Antonio Fabris.',
  'MÜLLER, Friedrich. Teoria estruturante do direito. São Paulo: Revista dos '
      'Tribunais.',
  'MENDES, Gilmar Ferreira; BRANCO, Paulo Gustavo Gonet. Curso de direito '
      'constitucional. São Paulo: Saraiva.',
  'STF. ADPF 132 e ADI 4277 (2011); Rcl 4335/AC (2014); ADIs 3406 e 3470 '
      '(2017); HC 84.078 (2009); HC 126.292 (2016); ADCs 43, 44 e 54 (2019).',
];

const String mutationTransparency =
    'Utilizamos o Claude (Anthropic) para brainstorming da estrutura do OVA e '
    'para a primeira versão do roteiro. Todo o conteúdo jurídico foi conferido '
    'pela equipe nas fontes acima.';

/// Atalhos de consulta.
MutationCase? mutationCaseById(String id) {
  for (final item in mutationCases) {
    if (item.id == id) return item;
  }
  return null;
}

MutationTheory? mutationTheoryById(String id) {
  for (final item in mutationTheory) {
    if (item.id == id) return item;
  }
  return null;
}

MutationQuizQuestion? mutationQuizById(String id) {
  for (final item in mutationQuiz) {
    if (item.id == id) return item;
  }
  return null;
}
