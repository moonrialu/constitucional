export const CARD_LIBRARY = [
  {
    id: 'mutacao',
    title: 'Mutação constitucional',
    subtitle: 'Sentido novo, texto intacto',
    symbol: '∆',
    accent: '#d8b56a',
    surface: 'from-[#3a2f1c] via-[#2a2418] to-[#171710]',
    note: 'Mudança informal de sentido, alcance ou significado, sem alterar o texto.',
  },
  {
    id: 'reforma',
    title: 'Reforma constitucional',
    subtitle: 'O texto é alterado',
    symbol: '§',
    accent: '#63c7b8',
    surface: 'from-[#173c3b] via-[#12302f] to-[#0c2021]',
    note: 'Alteração formal do texto constitucional pelo procedimento do art. 60.',
  },
  {
    id: 'emenda',
    title: 'Emenda constitucional',
    subtitle: 'A via formal do art. 60',
    symbol: '✎',
    accent: '#8fb7d8',
    surface: 'from-[#20374d] via-[#182b3d] to-[#101d29]',
    note: 'Espécie de reforma: modifica o texto por proposta, votação e promulgação.',
  },
  {
    id: 'interpretacao',
    title: 'Interpretação comum',
    subtitle: 'Aplicar o sentido já aceito',
    symbol: '≈',
    accent: '#b9c7d6',
    surface: 'from-[#2b3440] via-[#222a34] to-[#151b22]',
    note: 'Subsunção: aplica-se ao caso o sentido já consolidado, sem criar leitura nova.',
  },
  {
    id: 'inconstitucional',
    title: 'Mutação inconstitucional',
    subtitle: 'O sentido contra o texto',
    symbol: '⚖',
    accent: '#d97c92',
    surface: 'from-[#4a2230] via-[#351b25] to-[#1e1217]',
    note: 'Mudança informal que contraria o texto, as cláusulas pétreas ou a separação de Poderes.',
  },
  {
    id: 'clausula',
    title: 'Cláusula pétrea',
    subtitle: 'O limite que não se remove',
    symbol: '◈',
    accent: '#e0a84f',
    surface: 'from-[#47351b] via-[#332717] to-[#1d1810]',
    note: 'Núcleo imutável do art. 60, § 4º: nem emenda nem mutação podem aboli-lo.',
  },
  {
    id: 'textoNorma',
    title: 'Texto ≠ norma',
    subtitle: 'Partitura e música',
    symbol: '✦',
    accent: '#9bd8cd',
    surface: 'from-[#1c3f3d] via-[#16302f] to-[#0d1e1e]',
    note: 'O texto é o enunciado; a norma é o sentido que dele se extrai na interpretação.',
  },
  {
    id: 'costume',
    title: 'Costume constitucional',
    subtitle: 'A prática que fixa sentido',
    symbol: '↻',
    accent: '#b5a7d8',
    surface: 'from-[#312b4a] via-[#26213a] to-[#171426]',
    note: 'Comportamento institucional reiterado que altera a aplicação da norma.',
  },
  {
    id: 'controle',
    title: 'Controle difuso',
    subtitle: 'A inconstitucionalidade no caso',
    symbol: '⌕',
    accent: '#8fb7d8',
    surface: 'from-[#263d4d] via-[#1d303d] to-[#121f28]',
    note: 'Fiscalização concreta, incidente e descentralizada da constitucionalidade.',
  },
  {
    id: 'revogacao',
    title: 'Revogação',
    subtitle: 'A norma deixa de existir',
    symbol: '×',
    accent: '#c8b7a3',
    surface: 'from-[#3b332b] via-[#2c261f] to-[#1b1713]',
    note: 'Supressão da norma vigente; não se confunde com mudança de sentido.',
  },
];

export const cardById = (id) => CARD_LIBRARY.find((card) => card.id === id);

export const CARD_ROUNDS = [
  {
    id: 'union',
    mentor: 'amanda',
    caseLabel: 'Processo 01 · Entidade familiar',
    title: 'A união que não mudou o texto',
    scenario:
      'O art. 226, § 3º, fala em união estável “entre o homem e a mulher”. Ana e Beatriz vivem juntas há 12 anos e pedem reconhecimento. O STF acolhe o pedido lendo o dispositivo à luz da dignidade, da igualdade e da proibição de discriminação. Nenhuma palavra do texto é alterada.',
    question: 'Qual carta traduz com precisão o que o Tribunal fez?',
    options: ['reforma', 'mutacao', 'interpretacao', 'revogacao', 'emenda'],
    answer: 'mutacao',
    explanation:
      'O STF mudou o sentido de “entidade familiar” sem tocar no texto. Isso é mutação constitucional: mudança informal de sentido, alcance ou significado da norma.',
    traps: {
      reforma: 'Reforma exige alteração do texto pelo art. 60. Aqui, nenhuma palavra mudou.',
      emenda: 'Emenda é espécie de reforma e altera o texto. Não foi o que ocorreu.',
      interpretacao:
        'A interpretação conforme foi o método usado, mas o fenômeno é a mutação: o sentido mudou sem texto novo.',
      revogacao:
        'Revogação suprime a norma. O dispositivo continua em vigor, apenas com outro sentido.',
    },
  },
  {
    id: 'ec45',
    mentor: 'ian',
    caseLabel: 'Processo 02 · Reforma do Judiciário',
    title: 'Quando a Constituição é reescrita',
    scenario:
      'Em 2004, a EC 45 acrescentou dispositivos ao texto constitucional, criou o Conselho Nacional de Justiça e alterou regras da magistratura. O procedimento seguiu os dois turnos e os três quintos em cada Casa.',
    question: 'Que carta classifica corretamente a EC 45?',
    options: ['mutacao', 'reforma', 'controle', 'interpretacao', 'costume'],
    answer: 'reforma',
    explanation:
      'A EC 45 alterou formalmente o texto da Constituição. Toda alteração textual pelo procedimento do art. 60 é reforma constitucional — a emenda é a sua espécie mais comum.',
    traps: {
      mutacao: 'Mutação muda o sentido sem mexer no texto. A EC 45 mexeu no texto.',
      interpretacao:
        'Não é simples aplicação de sentido já aceito: o texto foi formalmente modificado.',
      costume: 'Costume é prática reiterada, não emenda formal.',
      controle:
        'Controle é mecanismo de fiscalização, não espécie de mudança constitucional.',
    },
  },
  {
    id: 'age',
    mentor: 'gabriel',
    caseLabel: 'Processo 03 · Elegibilidade',
    title: 'Trinta e quatro anos',
    scenario:
      'Um candidato ao Senado tem 34 anos completos no dia da posse. O Tribunal aplica a regra constitucional da idade mínima de 35 anos e indefere o registro. Não há dúvida sobre o sentido do dispositivo nem mudança de leitura.',
    question: 'Qual carta descreve a operação realizada?',
    options: ['interpretacao', 'mutacao', 'clausula', 'reforma', 'inconstitucional'],
    answer: 'interpretacao',
    explanation:
      'A regra foi apenas aplicada ao caso: interpretação comum, também chamada de subsunção. Não surgiu sentido novo, não houve alteração textual e não há contrariedade à Constituição.',
    traps: {
      mutacao: 'Aqui não há sentido novo: aplica-se a regra já existente ao caso.',
      reforma: 'Nenhuma alteração textual ocorreu.',
      inconstitucional: 'Não há contrariedade ao texto; a regra foi aplicada como está.',
      clausula: 'Cláusula pétrea é limite material, não o nome da operação de subsunção.',
    },
  },
  {
    id: 'score',
    mentor: 'luiza',
    caseLabel: 'Processo 04 · A metáfora',
    title: 'A partitura e a música',
    scenario:
      'Luiza explica: a partitura não é a música. A música só aparece quando alguém interpreta a partitura. O mesmo texto constitucional pode soar diferente em épocas diferentes, sem que uma nota seja reescrita.',
    question: 'Qual conceito a metáfora ilustra?',
    options: ['mutacao', 'reforma', 'textoNorma', 'emenda', 'costume'],
    answer: 'textoNorma',
    explanation:
      'A metáfora separa texto e norma: o texto é a partitura; a norma é a música produzida na interpretação. A mutação é uma consequência possível dessa distância, não o nome da distância.',
    traps: {
      mutacao: 'A metáfora explica a distinção entre texto e norma; a mutação é uma consequência possível.',
      reforma: 'A partitura não é alterada; só a execução muda.',
      costume: 'Costume é uma prática institucional, não a relação entre partitura e música.',
      emenda: 'A metáfora não trata de alteração formal do texto.',
    },
  },
  {
    id: 'senate',
    mentor: 'rafael',
    caseLabel: 'Processo 05 · O Senado',
    title: 'Só publicar?',
    scenario:
      'Um parecer sustenta que a decisão do Plenário do STF já vale para todos e que o Senado, no art. 52, X, apenas dá publicidade à decisão. A tese retira do Senado a competência de suspender a execução da lei.',
    question: 'Como classificar essa tese?',
    options: ['mutacao', 'inconstitucional', 'interpretacao', 'controle', 'reforma'],
    answer: 'inconstitucional',
    explanation:
      'A tese pode ser apresentada como mutação, mas retira do Senado uma competência expressa. Ao ultrapassar o texto e a separação de Poderes, converte-se em mutação inconstitucional.',
    traps: {
      mutacao:
        'A tese é uma mudança de sentido, mas, ao retirar competência escrita do Senado, é mutação inconstitucional.',
      interpretacao: 'Não é leitura que caiba no texto: a competência do Senado é expressa.',
      reforma: 'Não houve alteração formal do art. 52, X.',
      controle: 'Controle difuso é o contexto, não a classificação da tese.',
    },
  },
  {
    id: 'secret',
    mentor: 'paola',
    caseLabel: 'Processo 06 · Voto secreto',
    title: 'Secreto quer dizer identificado?',
    scenario:
      'Para facilitar auditorias, um tribunal passa a interpretar “voto secreto” como “voto identificado”. O texto constitucional não é alterado. A Constituição afirma que o voto é direto, secreto, universal e periódico.',
    question: 'Qual limite é diretamente violado por essa leitura?',
    options: ['mutacao', 'reforma', 'clausula', 'interpretacao', 'costume'],
    answer: 'clausula',
    explanation:
      'O voto secreto é cláusula pétrea do art. 60, § 4º. Nem emenda nem interpretação podem aboli-lo. A leitura contraria o texto e esbarra no núcleo imutável da Constituição.',
    traps: {
      mutacao: 'Houve mudança de sentido, mas ela contraria cláusula pétrea; o limite qualifica o fenômeno.',
      reforma: 'Não houve emenda; a tentativa é interpretativa.',
      interpretacao: 'Interpretar não autoriza inverter o sentido literal de “secreto”.',
      costume: 'Não é prática reiterada; é decisão interpretativa que contraria o texto.',
    },
  },
];
