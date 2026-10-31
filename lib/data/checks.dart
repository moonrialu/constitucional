import '../models/content.dart';

/// Etapas interativas novas da fase 2: classificar, associar e aplicar os
/// testes da proporcionalidade.
const List<CheckStep> checkSteps = [
  CheckStep(
    id: 'check1',
    kicker: 'Classifique',
    title: 'Regra ou princípio?',
    lead:
        'Passe os olhos sobre cada dispositivo e decida: ele funciona no '
        '"tudo ou nada" ou como mandamento de otimização?',
    nextLabel: 'Próximo processo',
    questions: [
      CheckQuestion(
        id: 'c1-1',
        prompt:
            'Idade mínima de 35 anos para Presidente (art. 14, § 3º, VI, "a").',
        feedback:
            'É regra: hipótese e consequência fechadas. Ou tem 35 anos, ou não '
            'tem.',
        options: [
          CheckOption(id: 'R', text: 'Regra', correct: true),
          CheckOption(id: 'P', text: 'Princípio', correct: false),
        ],
      ),
      CheckQuestion(
        id: 'c1-2',
        prompt: 'Dignidade da pessoa humana (art. 1º, III).',
        feedback:
            'É princípio: manda realizar algo na maior medida possível e se '
            'conforma com as circunstâncias do caso.',
        options: [
          CheckOption(id: 'R', text: 'Regra', correct: false),
          CheckOption(id: 'P', text: 'Princípio', correct: true),
        ],
      ),
      CheckQuestion(
        id: 'c1-3',
        prompt: 'Proibição de tortura (art. 5º, III).',
        feedback:
            'É regra: proibição absoluta, aplicada no "tudo ou nada", sem '
            'ponderação possível.',
        options: [
          CheckOption(id: 'R', text: 'Regra', correct: true),
          CheckOption(id: 'P', text: 'Princípio', correct: false),
        ],
      ),
      CheckQuestion(
        id: 'c1-4',
        prompt: 'Igualdade (art. 5º, caput).',
        feedback:
            'É princípio: exige tratamento igual e desigual conforme o critério '
            'constitucionalmente relevante, ponderado no caso.',
        options: [
          CheckOption(id: 'R', text: 'Regra', correct: false),
          CheckOption(id: 'P', text: 'Princípio', correct: true),
        ],
      ),
      CheckQuestion(
        id: 'c1-5',
        prompt: 'Prazo de 120 dias para impetrar mandado de segurança (art. 23 da Lei 12.016/2009).',
        feedback:
            'É regra: prazo certo, com consequência definida para quem perde o '
            'termo (decadência).',
        options: [
          CheckOption(id: 'R', text: 'Regra', correct: true),
          CheckOption(id: 'P', text: 'Princípio', correct: false),
        ],
      ),
    ],
    note: InfoBox(
      title: 'Critério prático',
      text:
          'Se a norma descreve uma conduta e uma consequência de forma precisa, '
          'é regra. Se manda realizar um valor na maior medida possível, é '
          'princípio.',
    ),
  ),
  CheckStep(
    id: 'check2',
    kicker: 'Associe',
    title: 'Quem disse o quê?',
    lead:
        'Cada tese abaixo pertence a um autor. Escolha a autoria correta e '
        'confira ao final.',
    nextLabel: 'Ver mutação constitucional',
    questions: [
      CheckQuestion(
        id: 'c2-1',
        prompt:
            'Regras valem no "tudo ou nada"; princípios têm uma dimensão de '
            'peso que as regras não têm.',
        feedback:
            'Ronald Dworkin. A dimensão de peso é o que permite a ponderação.',
        options: [
          CheckOption(id: 'dworkin', text: 'Ronald Dworkin', correct: true),
          CheckOption(id: 'alexy', text: 'Robert Alexy', correct: false),
          CheckOption(id: 'avila', text: 'Humberto Ávila', correct: false),
          CheckOption(
            id: 'ferraz',
            text: 'Anna Cândida da Cunha Ferraz',
            correct: false,
          ),
        ],
      ),
      CheckQuestion(
        id: 'c2-2',
        prompt:
            'Princípios são mandamentos de otimização; a colisão se resolve '
            'por ponderação, guiada pela proporcionalidade.',
        feedback:
            'Robert Alexy. Os três testes (adequação, necessidade e '
            'proporcionalidade em sentido estrito) vêm daí.',
        options: [
          CheckOption(id: 'dworkin', text: 'Ronald Dworkin', correct: false),
          CheckOption(id: 'alexy', text: 'Robert Alexy', correct: true),
          CheckOption(id: 'avila', text: 'Humberto Ávila', correct: false),
          CheckOption(
            id: 'ferraz',
            text: 'Anna Cândida da Cunha Ferraz',
            correct: false,
          ),
        ],
      ),
      CheckQuestion(
        id: 'c2-3',
        prompt:
            'A distinção entre regras e princípios não é rígida: regras também '
            'podem ceder em casos excepcionais.',
        feedback: 'Humberto Ávila, na crítica brasileira à distinção forte.',
        options: [
          CheckOption(id: 'dworkin', text: 'Ronald Dworkin', correct: false),
          CheckOption(id: 'alexy', text: 'Robert Alexy', correct: false),
          CheckOption(id: 'avila', text: 'Humberto Ávila', correct: true),
          CheckOption(
            id: 'ferraz',
            text: 'Anna Cândida da Cunha Ferraz',
            correct: false,
          ),
        ],
      ),
      CheckQuestion(
        id: 'c2-4',
        prompt:
            'A mudança informal da Constituição, sem alteração do texto, é '
            'estudada como processo de mutação.',
        feedback:
            'Anna Cândida da Cunha Ferraz, em "Processos informais de mudança '
            'da Constituição".',
        options: [
          CheckOption(id: 'dworkin', text: 'Ronald Dworkin', correct: false),
          CheckOption(id: 'alexy', text: 'Robert Alexy', correct: false),
          CheckOption(id: 'avila', text: 'Humberto Ávila', correct: false),
          CheckOption(
            id: 'ferraz',
            text: 'Anna Cândida da Cunha Ferraz',
            correct: true,
          ),
        ],
      ),
    ],
  ),
  CheckStep(
    id: 'check3',
    kicker: 'Caso 6 · Aplique',
    title: 'O remédio de alto custo',
    lead:
        'Uma pessoa sem recursos pede à Justiça um medicamento que não está na '
        'lista do SUS, com custo altíssimo. O Estado alega reserva do possível. '
        'Aplique os três testes da proporcionalidade.',
    nextLabel: 'Ir para o teste final',
    questions: [
      CheckQuestion(
        id: 'c3-adequacao',
        prompt:
            'Adequação: fornecer o medicamento é um meio adequado para '
            'proteger o direito à saúde?',
        feedback:
            'Sim. Se o fármaco trata a doença, ele realiza o direito à saúde. '
            'Adequação é só isso: aptidão do meio para o fim.',
        options: [
          CheckOption(
            id: 'a1',
            text: 'Sim: o tratamento realiza o direito à saúde.',
            correct: true,
          ),
          CheckOption(
            id: 'a2',
            text: 'Não: o custo alto já elimina a adequação.',
            correct: false,
          ),
          CheckOption(
            id: 'a3',
            text: 'Não há relação entre o remédio e a saúde.',
            correct: false,
          ),
        ],
      ),
      CheckQuestion(
        id: 'c3-necessidade',
        prompt:
            'Necessidade: existe meio menos gravoso ao orçamento que produza o '
            'mesmo resultado?',
        feedback:
            'A pergunta é comparativa: se houver alternativa terapêutica '
            'equivalente na rede pública, ela deve ser preferida. Sem '
            'alternativa, o fornecimento é necessário.',
        options: [
          CheckOption(
            id: 'n1',
            text: 'Sim, se houver alternativa equivalente disponível no SUS.',
            correct: true,
          ),
          CheckOption(
            id: 'n2',
            text: 'Não, nunca existe meio menos gravoso.',
            correct: false,
          ),
          CheckOption(
            id: 'n3',
            text: 'Sim, negar o pedido é sempre menos gravoso.',
            correct: false,
          ),
        ],
      ),
      CheckQuestion(
        id: 'c3-estrito',
        prompt:
            'Proporcionalidade em sentido estrito: o ganho para a vida e a '
            'saúde supera o impacto orçamentário?',
        feedback:
            'Depende do caso: medicamento essencial, custo que não inviabilize '
            'o sistema e inexistência de alternativa. A reserva do possível '
            'não é cheque em branco, e o mínimo existencial pesa.',
        options: [
          CheckOption(
            id: 'e1',
            text: 'Sim, quando o fármaco é essencial e o custo não inviabiliza o sistema.',
            correct: true,
          ),
          CheckOption(
            id: 'e2',
            text: 'Não: o orçamento sempre prevalece.',
            correct: false,
          ),
          CheckOption(
            id: 'e3',
            text: 'Não se pondera: saúde é regra absoluta.',
            correct: false,
          ),
        ],
      ),
    ],
    note: InfoBox(
      title: 'Síntese',
      text:
          'A reserva do possível é um limite real, mas não elimina o dever '
          'estatal: ela entra na ponderação, não antes dela. É o que o STF '
          'chama de "mínimo existencial" no acesso a medicamentos.',
    ),
  ),
];

CheckStep? checkStepById(String id) {
  for (final step in checkSteps) {
    if (step.id == id) return step;
  }
  return null;
}
