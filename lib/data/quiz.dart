import '../models/content.dart';

/// Banco do teste final. O banco começa com as 5 questões do roteiro; a fase
/// seguinte amplia para 10 e sorteia.
const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 'q1',
    number: 1,
    statement:
        '"Ninguém será submetido a tortura" (art. 5º, III) funciona como:',
    reviewTopic: 'Regras × princípios',
    feedback:
        'A proibição é absoluta e se aplica no "tudo ou nada". Não há caso '
        'concreto que autorize tortura.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'Princípio, ponderável com a segurança pública',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text: 'Regra, sem espaço para ponderação',
        correct: true,
      ),
      QuizChoice(id: 'C', text: 'Norma programática', correct: false),
    ],
  ),
  QuizQuestion(
    id: 'q2',
    number: 2,
    statement:
        'Quando dois princípios constitucionais colidem, o que acontece com o '
        'princípio que "perde"?',
    reviewTopic: 'Ponderação e proporcionalidade (feedback do Caso 2)',
    feedback:
        'Colisão de princípios não elimina nenhum deles. A prevalência vale só '
        'para aquele caso concreto.',
    choices: [
      QuizChoice(id: 'A', text: 'É revogado', correct: false),
      QuizChoice(
        id: 'B',
        text: 'Continua válido e pode prevalecer em outro caso',
        correct: true,
      ),
      QuizChoice(id: 'C', text: 'Torna-se inconstitucional', correct: false),
    ],
  ),
  QuizQuestion(
    id: 'q3',
    number: 3,
    statement:
        'Qual destes é um caso de reforma constitucional, e não de mutação?',
    reviewTopic: 'Mutação × reforma',
    feedback:
        'Reforma muda o texto pela via formal do art. 60. As outras opções '
        'mudam o sentido sem tocar no texto: são mutação.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'O STF reconhece a união estável homoafetiva sem alterar o texto',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text:
            'O Congresso aprova uma Emenda Constitucional que altera a redação '
            'de um artigo',
        correct: true,
      ),
      QuizChoice(
        id: 'C',
        text: 'Uma prática institucional muda a forma como um dispositivo é aplicado',
        correct: false,
      ),
    ],
  ),
  QuizQuestion(
    id: 'q4',
    number: 4,
    statement: 'A mutação constitucional encontra limite:',
    reviewTopic: 'Limites da mutação',
    feedback:
        'O texto é o ponto de partida e o limite da interpretação. Sentidos '
        'contrários ao texto ou às cláusulas pétreas configuram mutação '
        'inconstitucional.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'Apenas na vontade da maioria da sociedade',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text: 'No texto da Constituição e nos seus princípios fundamentais',
        correct: true,
      ),
      QuizChoice(
        id: 'C',
        text: 'Em nenhum ponto, pois o STF é o intérprete final',
        correct: false,
      ),
    ],
  ),
  QuizQuestion(
    id: 'q5',
    number: 5,
    statement: 'Para Robert Alexy, princípios são:',
    reviewTopic: 'Regras × princípios',
    feedback:
        'Princípios mandam realizar algo na maior medida possível, dentro das '
        'possibilidades fáticas e jurídicas. Subsunção é a forma de aplicação '
        'das regras.',
    choices: [
      QuizChoice(id: 'A', text: 'Mandamentos de otimização', correct: true),
      QuizChoice(
        id: 'B',
        text: 'Normas aplicadas por subsunção',
        correct: false,
      ),
      QuizChoice(
        id: 'C',
        text: 'Meras recomendações sem força normativa',
        correct: false,
      ),
    ],
  ),
  QuizQuestion(
    id: 'q6',
    number: 6,
    statement:
        'Uma PEC aprovada em dois turnos, por 3/5 dos votos em cada Casa, '
        'pretende extinguir o STF e transferir suas funções a um conselho do '
        'Executivo. O gabinete deve responder que:',
    reviewTopic: 'Cláusulas pétreas (Caso 5)',
    feedback:
        'A proposta não pode nem ser objeto de deliberação: suprimir o STF e '
        'subordinar suas funções ao Executivo elimina a separação dos Poderes, '
        'cláusula pétrea do art. 60, § 4º, III.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'A PEC é válida, pois cumpriu o quórum de 3/5 em dois turnos',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text:
            'A PEC não pode ser deliberada: fere a separação dos Poderes, '
            'cláusula pétrea',
        correct: true,
      ),
      QuizChoice(
        id: 'C',
        text: 'A PEC é válida, mas depende de referendo popular',
        correct: false,
      ),
    ],
  ),
  QuizQuestion(
    id: 'q7',
    number: 7,
    statement: 'As cláusulas pétreas do art. 60, § 4º, da CF/88:',
    reviewTopic: 'Limites da mutação',
    feedback:
        'As cláusulas pétreas limitam o poder de reforma, não a interpretação '
        'evolutiva. O texto pode ganhar novos sentidos, desde que esses '
        'sentidos não contrariem o próprio texto nem o núcleo intangível.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'Podem ser alteradas por emenda com quórum de 3/5',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text:
            'São limites ao poder de reforma, não impedem a interpretação '
            'evolutiva',
        correct: true,
      ),
      QuizChoice(
        id: 'C',
        text: 'Impedem qualquer interpretação nova da Constituição',
        correct: false,
      ),
    ],
  ),
  QuizQuestion(
    id: 'q8',
    number: 8,
    statement:
        'No debate sobre medicamentos de alto custo, a reserva do possível:',
    reviewTopic: 'Reserva do possível',
    feedback:
        'A reserva do possível é um limite real, mas não um cheque em branco: '
        'ela entra na ponderação junto com o mínimo existencial e não afasta '
        'por si só o dever estatal de proteger a saúde.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'É um cheque em branco para o Estado descumprir a Constituição',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text: 'Entra na ponderação e não elimina o mínimo existencial',
        correct: true,
      ),
      QuizChoice(
        id: 'C',
        text: 'Afasta sempre o direito à saúde quando o custo é alto',
        correct: false,
      ),
    ],
  ),
  QuizQuestion(
    id: 'q9',
    number: 9,
    statement:
        'No teste da necessidade, dentro da proporcionalidade, a pergunta é:',
    reviewTopic: 'Proporcionalidade',
    feedback:
        'Necessidade é comparação entre meios: se existe alternativa igualmente '
        'eficaz e menos gravosa, ela deve ser preferida. Adequação pergunta se o '
        'meio serve ao fim; proporcionalidade em sentido estrito compara '
        'benefício e custo.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'O meio escolhido é apto a realizar o fim?',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text: 'Existe meio menos gravoso e igualmente eficaz?',
        correct: true,
      ),
      QuizChoice(
        id: 'C',
        text: 'O benefício supera o custo da medida?',
        correct: false,
      ),
    ],
  ),
  QuizQuestion(
    id: 'q10',
    number: 10,
    statement: 'Mutação constitucional é:',
    reviewTopic: 'Mutação × reforma',
    feedback:
        'Mutação é mudança informal de sentido, sem alteração do texto, e '
        'encontra limite no próprio texto e nas cláusulas pétreas. Reforma é a '
        'alteração formal pela via do art. 60.',
    choices: [
      QuizChoice(
        id: 'A',
        text: 'A alteração formal do texto pela via do art. 60',
        correct: false,
      ),
      QuizChoice(
        id: 'B',
        text:
            'A mudança informal de sentido, sem alterar o texto, dentro de '
            'seus limites',
        correct: true,
      ),
      QuizChoice(
        id: 'C',
        text: 'Qualquer decisão do STF, mesmo contra o texto constitucional',
        correct: false,
      ),
    ],
  ),
];

QuizQuestion? quizById(String id) {
  for (final q in quizQuestions) {
    if (q.id == id) return q;
  }
  return null;
}
