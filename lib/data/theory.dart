import '../models/content.dart';

/// As duas telas de teoria essencial do roteiro.
const List<TheoryStep> theorySteps = [
  TheoryStep(
    id: 'theory1',
    title: 'Regras × princípios',
    lead: 'Norma é o gênero. Regras e princípios são as suas duas espécies.',
    nextLabel: 'Classificar dispositivos',
    table: ComparisonTable(
      leftTitle: 'Regras',
      rightTitle: 'Princípios',
      rows: [
        ComparisonRow(
          label: 'O que são',
          left: 'Comandos definitivos, com hipótese e consequência precisas',
          right:
              'Mandamentos de otimização: mandam realizar algo na maior '
              'medida possível',
        ),
        ComparisonRow(
          label: 'Como se aplicam',
          left: 'Subsunção, no "tudo ou nada"',
          right: 'Ponderação, conforme o peso no caso concreto',
        ),
        ComparisonRow(
          label: 'Quando entram em choque',
          left:
              'Conflito: resolve-se pela validade (uma sai do sistema) ou por '
              'uma cláusula de exceção',
          right:
              'Colisão: os dois continuam válidos; um prevalece só naquele '
              'caso',
        ),
        ComparisonRow(
          label: 'Exemplo na CF/88',
          left: 'Idade mínima de 35 anos para Presidente (art. 14, § 3º, VI, "a")',
          right: 'Dignidade da pessoa humana (art. 1º, III)',
        ),
      ],
    ),
    authors: [
      AuthorCard(
        name: 'Ronald Dworkin',
        text:
            'Regras valem no "tudo ou nada"; princípios têm uma dimensão de '
            'peso que as regras não têm.',
      ),
      AuthorCard(
        name: 'Robert Alexy',
        text:
            'Princípios são mandamentos de otimização. Na colisão, aplica-se a '
            'ponderação, guiada pela máxima da proporcionalidade (adequação, '
            'necessidade e proporcionalidade em sentido estrito).',
      ),
      AuthorCard(
        name: 'Humberto Ávila (crítica brasileira)',
        text:
            'A distinção não é tão rígida. Regras também podem ser superadas '
            'em casos excepcionais, e princípios também exigem fundamentação '
            'forte.',
      ),
    ],
    tip: InfoBox(
      title: 'Dica de prova',
      text:
          'Hierarquia, cronologia e especialidade resolvem conflito de regras. '
          'Em colisão de princípios constitucionais, esses critérios não '
          'funcionam: a saída é a ponderação.',
    ),
  ),
  TheoryStep(
    id: 'theory2',
    title: 'O que é mutação constitucional',
    lead:
        'Mutação constitucional é a mudança informal da Constituição: o '
        'sentido da norma muda, mas o texto continua o mesmo. Ela acompanha a '
        'evolução da sociedade sem passar pelo processo de emenda.',
    nextLabel: 'Próximo processo',
    table: ComparisonTable(
      leftTitle: 'Reforma constitucional',
      rightTitle: 'Mutação constitucional',
      rows: [
        ComparisonRow(
          label: 'Via',
          left: 'Formal: emenda (art. 60) ou revisão (art. 3º do ADCT)',
          right: 'Informal',
        ),
        ComparisonRow(
          label: 'O que muda',
          left: 'O texto',
          right: 'O sentido atribuído ao texto',
        ),
        ComparisonRow(
          label: 'Quem faz',
          left:
              'Congresso Nacional, com quórum de 3/5 em dois turnos em cada '
              'Casa',
          right:
              'Principalmente o Judiciário, pela interpretação; também '
              'costumes e práticas constitucionais',
        ),
      ],
    ),
    origin: InfoBox(
      title: 'Origem do conceito',
      text:
          'A doutrina alemã (Georg Jellinek falava em Verfassungswandlung). No '
          'Brasil, a referência clássica é Anna Cândida da Cunha Ferraz, em '
          'Processos informais de mudança da Constituição.',
    ),
    tip: InfoBox(
      title: 'Os limites da mutação',
      text:
          'Quando a mutação ultrapassa esses limites, fala-se em mutação '
          'inconstitucional. A mutação não pode:',
      bullets: [
        'contrariar o texto expresso (o texto é o limite da interpretação);',
        'violar os princípios fundamentais e as cláusulas pétreas '
            '(art. 60, § 4º).',
      ],
    ),
  ),
];

TheoryStep? theoryById(String id) {
  for (final t in theorySteps) {
    if (t.id == id) return t;
  }
  return null;
}
