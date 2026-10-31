/// Glossário do OVA. Termos citados nas telas de teoria e nos feedbacks.
class GlossaryEntry {
  const GlossaryEntry({
    required this.term,
    required this.definition,
    required this.tag,
  });

  final String term;
  final String definition;

  /// Área do conteúdo, usada para filtrar e colorir.
  final String tag;
}

const List<GlossaryEntry> glossaryEntries = [
  GlossaryEntry(
    term: 'Norma jurídica',
    tag: 'Fundamentos',
    definition:
        'Gênero que abrange regras e princípios. É o texto constitucional já '
        'interpretado, com força vinculante.',
  ),
  GlossaryEntry(
    term: 'Regra',
    tag: 'Regras × princípios',
    definition:
        'Norma com hipótese e consequência definidas, aplicada por subsunção '
        'no "tudo ou nada". Exemplo: idade mínima de 35 anos para Presidente.',
  ),
  GlossaryEntry(
    term: 'Princípio',
    tag: 'Regras × princípios',
    definition:
        'Mandamento de otimização: manda realizar um valor na maior medida '
        'possível, conforme as possibilidades fáticas e jurídicas. Exemplo: '
        'dignidade da pessoa humana.',
  ),
  GlossaryEntry(
    term: 'Subsunção',
    tag: 'Regras × princípios',
    definition:
        'Operação de enquadrar o fato na hipótese da norma e extrair a '
        'consequência. É o modo típico de aplicação das regras.',
  ),
  GlossaryEntry(
    term: 'Colisão de princípios',
    tag: 'Ponderação',
    definition:
        'Choque entre princípios válidos. Nenhum é revogado: um prevalece no '
        'caso concreto, e o outro continua aplicável em outras situações.',
  ),
  GlossaryEntry(
    term: 'Ponderação',
    tag: 'Ponderação',
    definition:
        'Método de solução de colisão entre princípios, guiado pela máxima da '
        'proporcionalidade. Exige justificar o peso atribuído a cada lado.',
  ),
  GlossaryEntry(
    term: 'Adequação',
    tag: 'Proporcionalidade',
    definition:
        'Primeiro teste: o meio escolhido é apto a realizar o fim pretendido?',
  ),
  GlossaryEntry(
    term: 'Necessidade',
    tag: 'Proporcionalidade',
    definition:
        'Segundo teste: existe meio igualmente eficaz e menos gravoso? Se '
        'existir, ele deve ser preferido.',
  ),
  GlossaryEntry(
    term: 'Proporcionalidade em sentido estrito',
    tag: 'Proporcionalidade',
    definition:
        'Terceiro teste: o benefício obtido supera o custo da medida? É a '
        'comparação entre gravidade da intervenção e ganho para o direito.',
  ),
  GlossaryEntry(
    term: 'Reforma constitucional',
    tag: 'Mutação',
    definition:
        'Alteração formal do texto pela via do art. 60 (emenda) ou do art. 3º '
        'do ADCT (revisão), com quórum e procedimento próprios.',
  ),
  GlossaryEntry(
    term: 'Mutação constitucional',
    tag: 'Mutação',
    definition:
        'Mudança informal do sentido da Constituição, sem alterar o texto. '
        'Decorre da interpretação, de costumes e de práticas institucionais.',
  ),
  GlossaryEntry(
    term: 'Mutação inconstitucional',
    tag: 'Mutação',
    definition:
        'Mutação que ultrapassa os limites: contraria o texto expresso ou '
        'viola princípios fundamentais e cláusulas pétreas.',
  ),
  GlossaryEntry(
    term: 'Cláusulas pétreas',
    tag: 'Limites',
    definition:
        'Núcleo do art. 60, § 4º: forma federativa de Estado, voto direto, '
        'secreto, universal e periódico, separação dos Poderes e direitos e '
        'garantias individuais. Não podem ser objeto de deliberação de emenda.',
  ),
  GlossaryEntry(
    term: 'Controle de constitucionalidade',
    tag: 'Limites',
    definition:
        'Verificação da compatibilidade de uma norma com a Constituição. Pode '
        'ser difuso (qualquer juiz, no caso concreto) ou concentrado (STF, em '
        'ação direta).',
  ),
  GlossaryEntry(
    term: 'Reserva do possível',
    tag: 'Direitos sociais',
    definition:
        'Limite orçamentário invocado pelo Estado para não cumprir prestações '
        'sociais. Não é cheque em branco: entra na ponderação com o mínimo '
        'existencial.',
  ),
  GlossaryEntry(
    term: 'Mínimo existencial',
    tag: 'Direitos sociais',
    definition:
        'Núcleo de prestações indispensáveis à dignidade, que o Estado não pode '
        'simplesmente deixar de garantir alegando falta de recursos.',
  ),
  GlossaryEntry(
    term: 'Direito à saúde',
    tag: 'Direitos sociais',
    definition:
        'Direito social do art. 6º e 196 da CF/88, de eficácia imediata, mas '
        'cuja concretização considera a capacidade do sistema público.',
  ),
  GlossaryEntry(
    term: 'Controle preventivo',
    tag: 'Limites',
    definition:
        'Análise de constitucionalidade antes da promulgação, como o mandado de '
        'segurança de parlamentar contra proposta que viola cláusula pétrea.',
  ),
];

const List<String> glossaryTags = [
  'Todos',
  'Fundamentos',
  'Regras × princípios',
  'Ponderação',
  'Proporcionalidade',
  'Mutação',
  'Limites',
  'Direitos sociais',
];
