import '../models/mutation.dart';

/// Mentores da fase de treinamento.
///
/// Os avatares são desenhados na interface com as iniciais e a cor de cada
/// mentor; não dependemos de imagens externas.
const List<MentorProfile> mutationMentors = [
  MentorProfile(
    id: 'amanda',
    name: 'Amanda',
    role: 'Coordenadora do gabinete-escola',
    initials: 'AM',
    trait: 'organiza o raciocínio',
  ),
  MentorProfile(
    id: 'ian',
    name: 'Ian',
    role: 'Constitucionalista',
    initials: 'IA',
    trait: 'preciso e direto',
  ),
  MentorProfile(
    id: 'gabriel',
    name: 'Gabriel',
    role: 'Pesquisador de jurisprudência',
    initials: 'GA',
    trait: 'explica com exemplos',
  ),
  MentorProfile(
    id: 'luiza',
    name: 'Luiza',
    role: 'Didática e mnemônicos',
    initials: 'LU',
    trait: 'transforma teoria em imagem',
  ),
  MentorProfile(
    id: 'rafael',
    name: 'Rafael',
    role: 'Analista de precedentes',
    initials: 'RA',
    trait: 'conecta os casos reais',
  ),
  MentorProfile(
    id: 'paola',
    name: 'Paola',
    role: 'Revisora crítica',
    initials: 'PA',
    trait: 'faz as perguntas difíceis',
  ),
];

/// Fase de treinamento: três atos em estilo visual novel.
///
/// O texto usa `{nome}` para ser personalizado com o nome do onboarding.
/// A explicação é aprofundada de propósito: cada fala cabe em um balão e o
/// estudante avança no próprio ritmo.
const List<TrainingAct> mutationTraining = [
  TrainingAct(
    id: 'training1',
    number: 'Ato 1',
    title: 'Texto não é norma',
    subtitle: 'A distância que torna a mutação possível',
    nextLabel: 'Ir ao Ato 2',
    summaryTitle: 'O essencial do Ato 1',
    summaryBullets: [
      'Texto é o enunciado; norma é o sentido extraído dele na interpretação.',
      'O mesmo texto pode gerar normas diferentes ao longo do tempo.',
      'Princípios abrem mais espaço de mudança; regras precisas, menos.',
      'Mutação constitucional é mudança informal de sentido, sem alterar o '
          'texto.',
    ],
    lines: [
      DialogueLine(
        text:
            'Sala de treinamento do gabinete. Seis mentores esperam por você. '
            'Na mesa, apenas uma Constituição e um processo em branco.',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            '{nome}, bem-vindo(a) ao nosso gabinete-escola. Antes de pegar um '
            'processo, você precisa aprender a olhar para a Constituição de um '
            'jeito diferente.',
        emphasis: 'Boas-vindas',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            'A pergunta que vai nos guiar: como uma Constituição pode mudar de '
            'sentido sem que uma única palavra do texto seja alterada?',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'A resposta começa com uma distinção que parece simples, mas muda '
            'tudo: texto não é norma.',
        emphasis: 'Texto ≠ norma',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'O texto é a matéria-prima. A norma é o sentido que se extrai do '
            'texto quando ele é interpretado diante de um caso.',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Pensa numa partitura. A partitura não é a música. A música só '
            'aparece quando alguém a interpreta. O mesmo texto pode soar '
            'diferente em épocas diferentes.',
        emphasis: 'Partitura e música',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Friedrich Müller chama isso de diferença entre texto da norma e '
            'norma. A norma não está pronta no papel: ela se constitui no '
            'processo de concretização.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'Exemplo: o art. 226, § 3º, fala em “homem e mulher”. O texto é o '
            'mesmo desde 1988. Mas o sentido de “entidade familiar” foi lido de '
            'outro modo em 2011.',
        emphasis: 'Art. 226, § 3º',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'Na ADPF 132 e na ADI 4277, o STF reconheceu a união estável entre '
            'pessoas do mesmo sexo. Nenhuma palavra mudou. O que mudou foi a '
            'norma extraída do texto.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Cuidado com o atalho mental: “então o intérprete cria a '
            'Constituição?”. Não. O texto impõe limites. Interpretar não é '
            'licença poética.',
        emphasis: 'Limite do texto',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            'Por isso a metáfora da partitura: o intérprete tem liberdade, mas '
            'não pode tocar uma música que a partitura não permite.',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Há outro elemento: princípios e regras são espécies de norma. '
            'Regras têm hipótese e consequência precisas; princípios são '
            'mandamentos de otimização.',
        emphasis: 'Regras × princípios',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'A idade mínima de 35 anos é regra: ou tem, ou não tem. Já a '
            'dignidade humana é princípio: manda realizar algo na maior medida '
            'possível.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'Princípios são mais abertos e, por isso, puxam a mudança de '
            'sentido. Regras com conteúdo preciso oferecem menos espaço para '
            'mutação.',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'Foi o que vimos no caso da união estável: dignidade, igualdade e '
            'proibição de discriminação funcionaram como motores da nova '
            'leitura.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            '{nome}, pergunta de controle: se o texto não mudou, o que '
            'exatamente mudou?',
        emphasis: 'Pergunta de controle',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            'Deixe {nome} responder mentalmente... e depois confira: mudou o '
            'sentido atribuído ao texto, não o texto.',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Essa é a definição que vamos usar: mutação constitucional é '
            'mudança informal do sentido, do significado ou do alcance da '
            'norma, sem alteração do texto.',
        emphasis: 'Definição',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Informal significa sem emenda, sem revisão constitucional, sem '
            'passar pelo art. 60.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'E não é um fenômeno só brasileiro. Laband e Jellinek observaram na '
            'Alemanha do fim do século XIX uma Constituição que mudava na '
            'prática sem emendas.',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Jellinek chamou isso de Verfassungswandlung: mudança da '
            'Constituição pela via dos fatos e da interpretação.',
        emphasis: 'Verfassungswandlung',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'No Brasil, Anna Cândida da Cunha Ferraz sistematizou o tema em '
            '1986 e deixou uma advertência: a mutação não pode violar a letra '
            'nem o espírito da Constituição.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Guarde essa advertência. Ela vai voltar no Ato 3, quando falarmos '
            'de mutação inconstitucional.',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            'Resumo do primeiro ato: texto e norma não se confundem; a norma é '
            'o sentido extraído do texto; é essa distância que permite a '
            'mutação.',
        emphasis: 'Fechamento do Ato 1',
      ),
    ],
  ),
  TrainingAct(
    id: 'training2',
    number: 'Ato 2',
    title: 'Mutação, reforma e os meios',
    subtitle: 'Três caminhos que não se confundem',
    nextLabel: 'Ir ao Ato 3',
    summaryTitle: 'O essencial do Ato 2',
    summaryBullets: [
      'Reforma altera o texto; mutação altera o sentido.',
      'Interpretação comum apenas aplica o sentido já aceito.',
      'Meios da mutação: interpretação judicial, legislativa e costume.',
      'Emenda é reforma, não mutação.',
      'Rcl 4335 e ADIs 3406/3470 mostram o debate sobre o art. 52, X.',
    ],
    lines: [
      DialogueLine(
        text:
            'Ato 2. Na mesa, três pastas lado a lado: reforma, mutação e '
            'interpretação comum.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            '{nome}, o erro mais comum em prova é confundir mutação com '
            'reforma. Vamos separar os três caminhos.',
        emphasis: 'Separe os caminhos',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Reforma: muda o texto. Mutação: muda o sentido, texto igual. '
            'Interpretação comum: aplica o sentido já aceito, sem novidade.',
        emphasis: 'Regra de ouro',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'A reforma segue a via formal do art. 60: proposta, discussão, '
            'votação em dois turnos, três quintos em cada Casa e promulgação.',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'Exemplo de reforma: EC 45/2004, a Reforma do Judiciário. O texto '
            'constitucional foi alterado.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'Exemplo de mutação: ADPF 132/ADI 4277. O texto do art. 226 ficou '
            'igual; a leitura mudou.',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Exemplo de interpretação comum: aplicar a idade mínima de 35 anos '
            'a um candidato de 34. Nada de novo: só subsunção.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'E quem faz a mutação? Não é só o STF. Juízes, Legislativo, '
            'Executivo e a própria sociedade podem participar.',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Os meios clássicos são três: interpretação judicial, '
            'interpretação legislativa e costume constitucional.',
        emphasis: 'Os três meios',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'Interpretação judicial: o tribunal passa a ler o mesmo '
            'dispositivo de outro modo. É o meio mais estudado no Brasil.',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'Interpretação legislativa: ao regulamentar a Constituição, o '
            'legislador fixa um sentido novo para um dispositivo.',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Costume e práticas institucionais: comportamentos reiterados dos '
            'Poderes mudam a forma como a norma é aplicada.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Mas atenção: emenda não é meio de mutação. Emenda é reforma, '
            'porque mexe no texto.',
        emphasis: 'Pegadinha de prova',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text: 'Agora o caso mais famoso: o art. 52, X, e o papel do Senado.',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'O texto diz que o Senado suspende a execução de lei declarada '
            'inconstitucional pelo STF. Tradicionalmente, essa suspensão dava '
            'eficácia geral à decisão no controle difuso.',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Em 2014, na Rcl 4335, Gilmar Mendes e Eros Grau defenderam uma '
            'mutação: a decisão do Plenário já valeria para todos, e o Senado '
            'apenas daria publicidade.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Sepúlveda Pertence, Joaquim Barbosa, Lewandowski e Marco Aurélio '
            'rejeitaram a tese. A reclamação foi julgada procedente por outro '
            'fundamento: a Súmula Vinculante 26.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'Em 2017, nas ADIs 3406 e 3470, o tema voltou. Gilmar falou em '
            'releitura; Celso de Mello, em verdadeira mutação constitucional. '
            'Marco Aurélio divergiu.',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'Para os críticos, como Lenio Streck, retirar do Senado uma '
            'competência escrita seria mutação inconstitucional.',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Ou seja: o mesmo texto pode ser lido de dois modos. A disputa é '
            'sobre até onde a leitura pode ir.',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            'Fixando: texto mudou? Reforma. Texto igual, sentido novo que cabe '
            'nas palavras? Mutação. Texto igual, sentido contrário ao texto ou '
            'aos princípios? Mutação inconstitucional.',
        emphasis: 'Fluxograma mental',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Esse último tipo é o tema do próximo ato. E é onde a linha entre '
            'interpretar e usurpar fica mais fina.',
      ),
    ],
  ),
  TrainingAct(
    id: 'training3',
    number: 'Ato 3',
    title: 'Os limites da mutação',
    subtitle: 'Quando interpretar vira usurpar',
    nextLabel: 'Começar os processos',
    summaryTitle: 'O essencial do Ato 3',
    summaryBullets: [
      'Limites: texto, princípios/cláusulas pétreas e separação de Poderes.',
      'Texto igual não basta: o sentido precisa caber nas palavras.',
      'Mutação inconstitucional contraria o texto ou atinge cláusula pétrea.',
      'O caso da segunda instância mostra o risco de insegurança jurídica.',
    ],
    lines: [
      DialogueLine(
        text:
            'Ato 3. Agora as luzes baixam e as perguntas ficam mais difíceis.',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            '{nome}, se a mutação não tivesse limites, a rigidez '
            'constitucional seria apenas decorativa.',
        emphasis: 'Por que limites importam',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'O primeiro limite é o texto. O novo sentido precisa caber nas '
            'possibilidades das palavras.',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Não se pode ler “secreto” como “identificado”. São sentidos '
            'opostos. A palavra não é um detalhe.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'O segundo limite são os princípios fundamentais e as cláusulas '
            'pétreas do art. 60, § 4º. Se nem uma emenda pode aboli-los, uma '
            'mutação também não pode.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'O terceiro é a separação de Poderes: o intérprete não pode '
            'retirar de um Poder uma competência que a Constituição lhe deu '
            'expressamente.',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Quando a mudança informal ultrapassa esses limites, falamos de '
            'mutação inconstitucional: o texto continua igual, mas o sentido '
            'atribuído o contraria.',
        emphasis: 'Mutação inconstitucional',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'Caso hipotético: um tribunal decide que “voto secreto” passa a '
            'significar voto identificado, para facilitar auditorias.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Isso não é interpretação. É contrariedade ao texto. E o voto '
            'direto, secreto, universal e periódico é cláusula pétrea.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'Nem por emenda seria possível abolir. Uma proposta tendente a '
            'abolir cláusula pétrea não pode sequer ser deliberada.',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Outro debate real: a prisão após condenação em segunda '
            'instância.',
      ),
      DialogueLine(
        mentorId: 'rafael',
        text:
            'O art. 5º, LVII, diz que ninguém será considerado culpado até o '
            'trânsito em julgado. O texto nunca mudou.',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'Em 2009, o HC 84.078 exigia o trânsito em julgado. Em 2016, o HC '
            '126.292 admitiu a execução após a segunda instância. Em 2019, as '
            'ADCs 43, 44 e 54 voltaram à exigência.',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Três entendimentos em dez anos. Além do limite do texto, há o '
            'risco de insegurança jurídica.',
      ),
      DialogueLine(
        mentorId: 'gabriel',
        text:
            'Por isso a mutação precisa ser fundamentada com rigor: não basta '
            'o tribunal querer; é preciso demonstrar que a nova leitura cabe '
            'no texto e nos princípios.',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            'E aí está o valor do seu treinamento, {nome}: você não vai '
            'decorar “mutação é isso”. Vai aprender a testar se uma mudança '
            'de sentido é legítima.',
        emphasis: 'O objetivo do treino',
      ),
      DialogueLine(
        mentorId: 'ian',
        text:
            'O teste prático tem três perguntas: o texto mudou? O novo sentido '
            'cabe nas palavras? A leitura respeita princípios fundamentais e '
            'a separação de Poderes?',
      ),
      DialogueLine(
        mentorId: 'luiza',
        text:
            'Se mudou o texto: reforma. Se não mudou e cabe: mutação. Se não '
            'mudou, mas contraria o texto ou as cláusulas pétreas: mutação '
            'inconstitucional.',
        emphasis: 'Teste de três perguntas',
      ),
      DialogueLine(
        mentorId: 'paola',
        text:
            'Guarde também: texto igual não é salvo-conduto. A legitimidade '
            'não está no rótulo, mas na fundamentação.',
      ),
      DialogueLine(
        mentorId: 'amanda',
        text:
            'Fim do treinamento. Agora você vai enfrentar quatro processos. '
            'Leia o texto, extraia a norma, teste os limites e só então '
            'classifique.',
        emphasis: 'Hora do gabinete',
      ),
    ],
  ),
];

MentorProfile? mutationMentorById(String id) {
  for (final mentor in mutationMentors) {
    if (mentor.id == id) return mentor;
  }
  return null;
}

TrainingAct? mutationTrainingById(String id) {
  for (final act in mutationTraining) {
    if (act.id == id) return act;
  }
  return null;
}
