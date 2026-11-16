import '../models/chat_script.dart';
import '../models/contact.dart';

/// Roteiro completo do jogo, baseado no OVA "Mutação constitucional no
/// gabinete do STF".
///
/// Todo o texto narrativo vive aqui. Para ajustar a história ou os casos,
/// basta editar os contatos e os nós abaixo, sem tocar em telas ou regras.
const List<Contact> gameContacts = <Contact>[
  Contact(
    id: 'sala',
    name: 'Sala de Dúvidas',
    kind: ChatKind.group,
    order: -1,
    preview: 'Profa. Lúcia: a matéria inteira, aberta a qualquer hora.',
    avatarLabel: 'SD',
    isReference: true,
    participants: <ChatParticipant>[
      ChatParticipant(
        name: 'Profa. Lúcia',
        initials: 'PL',
        avatarAsset: 'assets/mentors/amandapixel.png',
      ),
      ChatParticipant(
        name: 'Dra. Helena',
        initials: 'DH',
        avatarAsset: 'assets/mentors/luizapixel.png',
      ),
      ChatParticipant(
        name: 'Bruno',
        initials: 'B',
        avatarAsset: 'assets/mentors/ianpixel.png',
      ),
    ],
  ),
  Contact(
    id: 'gabinete',
    name: 'Grupo do Gabinete',
    kind: ChatKind.group,
    order: 0,
    preview: 'Dra. Helena: o ministro quer você na triagem de hoje.',
    avatarLabel: 'GG',
    participants: <ChatParticipant>[
      ChatParticipant(
        name: 'Ministro',
        initials: 'M',
        avatarAsset: 'assets/mentors/rafaelpixel.png',
      ),
      ChatParticipant(
        name: 'Dra. Helena',
        initials: 'DH',
        avatarAsset: 'assets/mentors/luizapixel.png',
      ),
      ChatParticipant(
        name: 'Bruno',
        initials: 'B',
        avatarAsset: 'assets/mentors/ianpixel.png',
      ),
    ],
  ),
  Contact(
    id: 'ministro',
    name: 'Ministro',
    kind: ChatKind.direct,
    order: 1,
    preview: 'O art. 226, § 3º, não mudou. E agora?',
    avatarLabel: 'M',
    avatarAsset: 'assets/mentors/rafaelpixel.png',
    unlocksAfter: 'gabinete',
  ),
  Contact(
    id: 'estudos',
    name: 'Grupo de Estudos',
    kind: ChatKind.group,
    order: 3,
    preview: 'Bruno: texto não é norma. anota isso.',
    avatarLabel: 'GE',
    unlocksAfter: 'bruno',
    participants: <ChatParticipant>[
      ChatParticipant(
        name: 'Dra. Helena',
        initials: 'DH',
        avatarAsset: 'assets/mentors/luizapixel.png',
      ),
      ChatParticipant(
        name: 'Bruno',
        initials: 'B',
        avatarAsset: 'assets/mentors/ianpixel.png',
      ),
      ChatParticipant(
        name: 'Profa. Lúcia',
        initials: 'PL',
        avatarAsset: 'assets/mentors/amandapixel.png',
      ),
    ],
  ),
  Contact(
    id: 'bruno',
    name: 'Bruno',
    kind: ChatKind.direct,
    order: 2,
    preview: 'Três papéis na sua mesa. Classifica cada um.',
    avatarLabel: 'B',
    avatarAsset: 'assets/mentors/ianpixel.png',
    unlocksAfter: 'ministro',
  ),
  Contact(
    id: 'helena',
    name: 'Dra. Helena',
    kind: ChatKind.group,
    order: 4,
    preview: 'Gente, o rascunho do estagiário está cheio de erros…',
    avatarLabel: 'DH',
    unlocksAfter: 'estudos',
    participants: <ChatParticipant>[
      ChatParticipant(
        name: 'Dra. Helena',
        initials: 'DH',
        avatarAsset: 'assets/mentors/luizapixel.png',
      ),
      ChatParticipant(
        name: 'Profa. Lúcia',
        initials: 'PL',
        avatarAsset: 'assets/mentors/amandapixel.png',
      ),
      ChatParticipant(
        name: 'Bruno',
        initials: 'B',
        avatarAsset: 'assets/mentors/ianpixel.png',
      ),
    ],
  ),
  Contact(
    id: 'lucia',
    name: 'Profa. Lúcia',
    kind: ChatKind.direct,
    order: 5,
    preview: '“Voto secreto” pode significar “identificado”?',
    avatarLabel: 'PL',
    avatarAsset: 'assets/mentors/amandapixel.png',
    unlocksAfter: 'helena',
  ),
  Contact(
    id: 'banca',
    name: 'Banca do Ministro',
    kind: ChatKind.group,
    order: 6,
    preview: 'Ministro: cinco respostas antes do plenário.',
    avatarLabel: 'BM',
    unlocksAfter: 'lucia',
    participants: <ChatParticipant>[
      ChatParticipant(
        name: 'Ministro',
        initials: 'M',
        avatarAsset: 'assets/mentors/rafaelpixel.png',
      ),
      ChatParticipant(
        name: 'Dra. Helena',
        initials: 'DH',
        avatarAsset: 'assets/mentors/luizapixel.png',
      ),
    ],
  ),
];

const Map<String, ChatScript> gameScripts = <String, ChatScript>{
  'sala': ChatScript(
    contactId: 'sala',
    startNodeId: 'indice',
    nodes: <String, ChatNode>{
      'indice': ChatNode(
        id: 'indice',
        lines: <BotLine>[
          BotLine(
            'Esta sala fica aberta o tempo todo. Aqui a gente revisa a matéria inteira, sem avançar fase nenhuma.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Se você travou em algum caso, escolha o tema e vá direto. Nada aqui bloqueia o expediente.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'e dá pra voltar aqui depois do teste também.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'texto_norma',
            label: 'Texto e norma: por que o sentido pode mudar?',
            nextNodeId: 'textoNorma',
          ),
          ChatChoice(
            id: 'conceitos',
            label: 'Mutação, reforma e interpretação comum',
            nextNodeId: 'conceitos',
          ),
          ChatChoice(
            id: 'meios',
            label: 'Quais são os meios da mutação?',
            nextNodeId: 'meios',
          ),
          ChatChoice(
            id: 'casos',
            label: 'Os casos do STF, um por um',
            nextNodeId: 'casos',
          ),
          ChatChoice(
            id: 'limites',
            label: 'Limites e mutação inconstitucional',
            nextNodeId: 'limites',
          ),
          ChatChoice(
            id: 'aplicacao',
            label: 'Como reconhecer uma mutação na prova',
            nextNodeId: 'aplicacao',
          ),
        ],
      ),
      'textoNorma': ChatNode(
        id: 'textoNorma',
        lines: <BotLine>[
          BotLine(
            'O texto é a formulação linguística: o que está escrito no artigo. A norma é o sentido que se extrai desse texto diante de um caso concreto.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Friedrich Müller mostrou que entre texto e norma há uma distância. O mesmo texto pode produzir normas diferentes quando mudam a realidade, os princípios e a interpretação.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'tipo o art. 226, § 3º: o texto continua “entre o homem e a mulher”, mas a norma passou a abranger a união entre pessoas do mesmo sexo.',
            sender: 'Bruno',
          ),
          BotLine(
            'Cuidado com o atalho: isso não quer dizer que o intérprete cria a Constituição. Ele atribui sentido dentro das possibilidades do texto.',
            sender: 'Dra. Helena',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'conceitos',
            label: 'Entendi. E a diferença entre mutação e reforma?',
            nextNodeId: 'conceitos',
          ),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'conceitos': ChatNode(
        id: 'conceitos',
        lines: <BotLine>[
          BotLine(
            'São três fenômenos diferentes: reforma, mutação e interpretação comum.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Reforma: altera o texto pela via formal do art. 60 — a emenda constitucional. A revisão do art. 3º do ADCT também foi uma via formal.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Mutação: o texto permanece, mas mudam o sentido, o significado ou o alcance da norma. É um processo informal.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'interpretação comum é quando você apenas aplica o sentido que já está consolidado. não há mudança relevante.',
            sender: 'Bruno',
          ),
          BotLine(
            'Resumo de bolso: texto mudou = reforma; texto igual e sentido novo = mutação; texto igual e sentido já aceito = interpretação comum.',
            sender: 'Profa. Lúcia',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'meios',
            label: 'Como a mutação acontece na prática?',
            nextNodeId: 'meios',
          ),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'meios': ChatNode(
        id: 'meios',
        lines: <BotLine>[
          BotLine(
            'Os meios mais estudados são a interpretação judicial, a interpretação legislativa e o costume constitucional.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'A interpretação judicial é o meio mais visível no Brasil: o STF fixa sentido novo sem emendar o texto.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'A interpretação legislativa aparece quando o Congresso regulamenta um dispositivo e, na prática, consolida um sentido novo.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'e o costume constitucional é a repetição de práticas institucionais aceitas como constitucionais.',
            sender: 'Bruno',
          ),
          BotLine(
            'Jellinek chamou o fenômeno de Verfassungswandlung. Hesse e Anna Cândida da Cunha Ferraz lembram: a mutação só é legítima dentro das possibilidades do texto.',
            sender: 'Dra. Helena',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'casos',
            label: 'Quero ver isso nos casos do STF',
            nextNodeId: 'casos',
          ),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'casos': ChatNode(
        id: 'casos',
        lines: <BotLine>[
          BotLine(
            'Quatro casos ajudam a fixar. Escolha um para ver o que o STF decidiu e onde está a mutação.',
            sender: 'Profa. Lúcia',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'caso1',
            label: 'União estável — ADPF 132 e ADI 4277',
            nextNodeId: 'caso1',
          ),
          ChatChoice(
            id: 'caso2',
            label: 'Senado e art. 52, X — Rcl 4335 e ADIs 3406/3470',
            nextNodeId: 'caso2',
          ),
          ChatChoice(
            id: 'caso3',
            label: 'Voto secreto — exemplo hipotético',
            nextNodeId: 'caso3',
          ),
          ChatChoice(
            id: 'caso4',
            label: 'Segunda instância — HC 84.078, HC 126.292 e ADCs 43/44/54',
            nextNodeId: 'caso4',
          ),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'caso1': ChatNode(
        id: 'caso1',
        lines: <BotLine>[
          BotLine(
            'Caso 1 — união estável (ADPF 132 e ADI 4277, 2011). O art. 226, § 3º, não foi emendado.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'O STF leu o dispositivo em conjunto com a dignidade (art. 1º, III), a igualdade e a proibição de discriminação (art. 3º, IV), e reconheceu a união entre pessoas do mesmo sexo como entidade familiar.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'texto igual, sentido novo. é o exemplo mais didático de mutação constitucional no Brasil.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(id: 'casos', label: 'Ver outro caso', nextNodeId: 'casos'),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'caso2': ChatNode(
        id: 'caso2',
        lines: <BotLine>[
          BotLine(
            'Caso 2 — o art. 52, X, e o Senado. O texto atribui ao Senado suspender a execução de lei declarada inconstitucional pelo STF.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'Na Rcl 4335/AC (2014), Gilmar Mendes e Eros Grau defenderam que o Plenário já dá eficácia geral e o Senado só publica. A tese não formou maioria; a reclamação foi julgada procedente pela Súmula Vinculante 26.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'Nas ADIs 3406 e 3470 (2017), o STF deu efeito vinculante e erga omnes à declaração incidental de inconstitucionalidade. Celso de Mello falou em verdadeira mutação; Marco Aurélio divergiu.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'críticos como Lenio Streck dizem que retirar do Senado uma competência escrita seria mutação inconstitucional.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(id: 'casos', label: 'Ver outro caso', nextNodeId: 'casos'),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'caso3': ChatNode(
        id: 'caso3',
        lines: <BotLine>[
          BotLine(
            'Caso 3 — voto secreto (hipotético). Um tribunal decide que “voto secreto” passou a significar voto identificado, para facilitar auditorias.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            '“secreto” e “identificado” são sentidos opostos. a decisão não interpreta o texto: contraria o texto.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'além disso, voto direto, secreto, universal e periódico é cláusula pétrea (art. 60, § 4º, II). nem por emenda seria possível abolir.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'limites',
            label: 'Então quais são os limites da mutação?',
            nextNodeId: 'limites',
          ),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'caso4': ChatNode(
        id: 'caso4',
        lines: <BotLine>[
          BotLine(
            'Caso 4 — segunda instância. O art. 5º, LVII, diz que ninguém será considerado culpado até o trânsito em julgado da sentença penal condenatória. O texto nunca foi emendado.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'O STF oscilou: em 2009, o HC 84.078 exigia o trânsito em julgado; em 2016, o HC 126.292 admitiu a execução após a segunda instância; em 2019, as ADCs 43, 44 e 54 voltaram a exigir o trânsito em julgado, por 6 a 5.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'é o exemplo brasileiro mais discutido de mutação judicial — e também do custo de insegurança jurídica.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(id: 'casos', label: 'Ver outro caso', nextNodeId: 'casos'),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'limites': ChatNode(
        id: 'limites',
        lines: <BotLine>[
          BotLine(
            'Três limites: 1) o texto — o novo sentido precisa caber nas palavras; 2) os princípios fundamentais e as cláusulas pétreas do art. 60, § 4º; 3) a separação de Poderes.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'O novo sentido precisa caber nas possibilidades do texto. Se ele contraria o que está escrito, não é interpretação: é mutação inconstitucional.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Nem uma emenda pode abolir cláusula pétrea; uma mutação também não pode. E o intérprete não pode retirar de um Poder uma competência que a Constituição lhe deu expressamente.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'resumindo: texto igual não basta. tem que caber no texto e não atropelar a Constituição.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'caso3',
            label: 'Ver o exemplo de mutação inconstitucional',
            nextNodeId: 'caso3',
          ),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
      'aplicacao': ChatNode(
        id: 'aplicacao',
        lines: <BotLine>[
          BotLine(
            'Na prova ou no parecer, siga este roteiro: 1) o texto mudou? Se sim, é reforma. 2) Se não, qual sentido era aplicado antes e qual é agora? 3) O novo sentido cabe nas palavras do dispositivo? 4) Ele viola princípio fundamental, cláusula pétrea ou separação de Poderes?',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Se a resposta ao item 3 for “não” ou ao item 4 for “sim”, classifique como mutação inconstitucional.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'e não confunda resultado político com mutação. o STF pode decidir algo de que você discorda sem que seja mutação.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'limites',
            label: 'Rever os limites',
            nextNodeId: 'limites',
          ),
          ChatChoice(
            id: 'voltar',
            label: 'Voltar ao índice',
            nextNodeId: 'indice',
          ),
        ],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine(
        'Nesta sala, escolha um tema do índice. Eu explico do zero, sem pressa.',
        sender: 'Profa. Lúcia',
      ),
      BotLine(
        'a consulta é livre. toca em um dos temas acima.',
        sender: 'Bruno',
      ),
    ],
  ),
  'gabinete': ChatScript(
    contactId: 'gabinete',
    startNodeId: 'abertura',
    nodes: <String, ChatNode>{
      'abertura': ChatNode(
        id: 'abertura',
        lines: <BotLine>[
          BotLine(
            'Bom dia. O ministro pediu que você assumisse a triagem de hoje.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'Antes de qualquer processo: a Constituição pode mudar de sentido sem que o Congresso altere uma palavra?',
            sender: 'Ministro',
          ),
          BotLine(
            'quatro processos na mesa. o primeiro é o mais famoso.',
            sender: 'Bruno',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'interpretacao',
            label: 'Pode, pela interpretação — sem tocar no texto.',
            react: <BotLine>[
              BotLine(
                'Boa intuição. Mas intuição não basta no gabinete: precisamos saber por quê e até onde.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'metodo',
          ),
          ChatChoice(
            id: 'emenda',
            label: 'Só uma emenda pode mudar a Constituição.',
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'Emenda muda o texto. A pergunta é outra: e o sentido? É isso que vamos investigar.',
                sender: 'Dra. Helena',
              ),
            ],
            nextNodeId: 'metodo',
          ),
          ChatChoice(
            id: 'processo',
            label: 'Prefiro ver o processo antes de responder.',
            react: <BotLine>[
              BotLine(
                'Resposta de assessor. Vamos ao caso.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'metodo',
          ),
        ],
      ),
      'metodo': ChatNode(
        id: 'metodo',
        lines: <BotLine>[
          BotLine(
            'Método do gabinete: leia o caso, escolha uma tese e receba o porquê. Cada erro também ensina.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'Comece pelo Caso 1: união estável entre pessoas do mesmo sexo. O texto do art. 226, § 3º, segue intacto.',
            sender: 'Ministro',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'vou',
            label: 'Vou analisar o caso.',
            style: AnswerStyle.informal,
            react: <BotLine>[
              BotLine(
                'O processo está comigo. Abra a minha conversa e me diga a sua leitura.',
                sender: 'Ministro',
              ),
              BotLine('te espero lá.', sender: 'Bruno'),
            ],
          ),
          ChatChoice(
            id: 'resultado',
            label: 'Já sei o que o STF decidiu.',
            style: AnswerStyle.informal,
            react: <BotLine>[
              BotLine(
                'Saber o resultado não é saber o caminho. O processo está comigo: abra a minha conversa e vamos por partes.',
                sender: 'Ministro',
              ),
            ],
          ),
        ],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine(
        'No gabinete a gente responde com uma tese, não com um áudio. Escolha uma das opções.',
        sender: 'Dra. Helena',
      ),
      BotLine(
        'digita menos, escolhe uma resposta. o ministro tá esperando.',
        sender: 'Bruno',
      ),
    ],
  ),
  'ministro': ChatScript(
    contactId: 'ministro',
    startNodeId: 'caso1',
    isRiskChat: true,
    nodes: <String, ChatNode>{
      'caso1': ChatNode(
        id: 'caso1',
        lines: <BotLine>[
          BotLine(
            'Você é o estagiário novo que a equipe recomendou? Preciso de uma resposta técnica agora. Se eu errar a fundamentação sobre mutação constitucional, minha reputação vai para o chão.',
          ),
          BotLine(
            'Art. 226, § 3º: união estável “entre o homem e a mulher”. O texto nunca foi emendado. Ana e Beatriz pedem o reconhecimento. Qual é a sua leitura? Responda.',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'acolher',
            label: 'Acolher: ler o texto com dignidade, igualdade e vedação à discriminação.',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Menos mal. Pelo menos alguém nesse gabinete estudou o limite semântico da Constituição. Vou usar esse argumento.',
              ),
              BotLine(
                'ADPF 132 e ADI 4277, 2011: nenhuma palavra mudou, mudou o sentido. Isso é mutação constitucional.',
              ),
              BotLine(
                'Pode ir. O Bruno está com a triagem e não gosta de esperar.',
              ),
            ],
          ),
          ChatChoice(
            id: 'negar',
            label:
                'Negar: o texto fala em homem e mulher; só emenda muda isso.',
            isCorrect: false,
            style: AnswerStyle.wrong,
            prestigeDelta: -25,
            react: <BotLine>[
              BotLine(
                'Isso é um absurdo jurídico! Você quer me fazer passar vergonha no Plenário?! Mais um deslize desses e você será exonerado hoje mesmo.',
              ),
              BotLine(
                'A dignidade e a igualdade estão na própria Constituição. O texto não mudou; o sentido, sim. Tente outra vez. AGORA.',
              ),
            ],
            nextNodeId: 'insistencia',
          ),
          ChatChoice(
            id: 'reescrever',
            label: 'Acolher: o STF pode reescrever o artigo quando quiser.',
            isCorrect: false,
            style: AnswerStyle.wrong,
            prestigeDelta: -25,
            react: <BotLine>[
              BotLine(
                'Isso é um absurdo jurídico! Você quer me fazer passar vergonha no Plenário?! Mais um deslize desses e você será exonerado hoje mesmo.',
              ),
              BotLine(
                'O STF não reescreve a Constituição. Interpreta dentro das possibilidades do texto. Me dê a resposta correta.',
              ),
            ],
            nextNodeId: 'insistencia',
          ),
        ],
      ),
      'insistencia': ChatNode(
        id: 'insistencia',
        lines: <BotLine>[
          BotLine(
            'Não me venha com teoria decorada. O texto não mudou. O STF pode reconhecer a união de Ana e Beatriz sem emenda?',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'acolher',
            label:
                'Pode: é mutação constitucional, dentro do sentido do texto.',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Menos mal. Pelo menos alguém nesse gabinete estudou o limite semântico da Constituição. Vou usar esse argumento.',
              ),
              BotLine(
                'Pode ir. O Bruno está com a triagem e não gosta de esperar.',
              ),
            ],
          ),
          ChatChoice(
            id: 'negar',
            label: 'Não: sem emenda, o texto continua dizendo homem e mulher.',
            isCorrect: false,
            style: AnswerStyle.wrong,
            prestigeDelta: -25,
            react: <BotLine>[
              BotLine(
                'Isso é um absurdo jurídico! Você quer me fazer passar vergonha no Plenário?! Mais um deslize desses e você será exonerado hoje mesmo.',
              ),
            ],
            nextNodeId: 'insistencia',
          ),
          ChatChoice(
            id: 'reescrever',
            label:
                'Pode: o STF tem poder para reescrever o texto constitucional.',
            isCorrect: false,
            style: AnswerStyle.wrong,
            prestigeDelta: -25,
            react: <BotLine>[
              BotLine(
                'Isso é um absurdo jurídico! Você quer me fazer passar vergonha no Plenário?! Mais um deslize desses e você será exonerado hoje mesmo.',
              ),
              BotLine(
                'O STF interpreta o texto. Não o reescreve. De novo, e rápido.',
              ),
            ],
            nextNodeId: 'insistencia',
          ),
        ],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine('Não tenho tempo para áudio. Escolha uma leitura e sustente.'),
      BotLine('Me dê uma tese. Agora.'),
    ],
  ),
  'estudos': ChatScript(
    contactId: 'estudos',
    startNodeId: 'teoria',
    nodes: <String, ChatNode>{
      'teoria': ChatNode(
        id: 'teoria',
        lines: <BotLine>[
          BotLine(
            'Saímos do Caso 1 com uma pergunta: se o texto não mudou, o que mudou? Vamos fechar a base antes de seguir.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'A Profa. Lúcia acompanha nossos estudos. Ela vai conduzir a parte teórica.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'Vamos alinhar a base. O texto é o ponto de partida; a norma é o sentido que se extrai dele.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Müller: o mesmo texto pode gerar normas diferentes conforme a realidade e a interpretação mudam.',
            sender: 'Bruno',
          ),
          BotLine(
            'E por que isso importa para a mutação?',
            sender: 'Dra. Helena',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'distancia',
            label: 'Porque a distância entre texto e norma torna a mudança de sentido possível.',
            react: <BotLine>[
              BotLine(
                'Exatamente. Sem essa distância, só restaria a reforma.',
                sender: 'Profa. Lúcia',
              ),
            ],
            nextNodeId: 'meios',
          ),
          ChatChoice(
            id: 'principios',
            label: 'Porque os princípios puxam o sentido das regras.',
            react: <BotLine>[
              BotLine(
                'Também. Princípios abertos, como dignidade e igualdade, são o principal motor da mutação.',
                sender: 'Profa. Lúcia',
              ),
            ],
            nextNodeId: 'meios',
          ),
          ChatChoice(
            id: 'stf',
            label: 'Porque o STF pode alterar o texto.',
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'Não. O STF interpreta; não altera o texto. Quem altera é o Congresso, pelo art. 60.',
                sender: 'Dra. Helena',
              ),
            ],
            nextNodeId: 'meios',
          ),
        ],
      ),
      'meios': ChatNode(
        id: 'meios',
        lines: <BotLine>[
          BotLine(
            'Então: quais são os meios pelos quais a mutação acontece?',
            sender: 'Profa. Lúcia',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'tres',
            label: 'Interpretação judicial, interpretação legislativa e costume constitucional.',
            react: <BotLine>[
              BotLine(
                'isso. a interpretação judicial é o meio mais estudado no Brasil.',
                sender: 'Bruno',
              ),
              BotLine(
                'Jellinek chamou o fenômeno de Verfassungswandlung. Hesse e Anna Cândida da Cunha Ferraz insistem: a mutação só é legítima dentro das possibilidades do texto.',
                sender: 'Profa. Lúcia',
              ),
            ],
            nextNodeId: 'comparativo',
          ),
          ChatChoice(
            id: 'emenda',
            label: 'Emenda e revisão constitucionais.',
            react: <BotLine>[
              BotLine(
                'Não. Emenda e revisão são reforma: alteram o texto. Mutação é informal.',
                sender: 'Dra. Helena',
              ),
              BotLine(
                'Os meios são interpretação judicial, legislativa e costume constitucional.',
                sender: 'Profa. Lúcia',
              ),
            ],
            nextNodeId: 'comparativo',
          ),
          ChatChoice(
            id: 'costume',
            label: 'Só o costume constitucional.',
            react: <BotLine>[
              BotLine(
                'só não. a interpretação judicial e a legislativa também mudam sentido sem mexer no texto.',
                sender: 'Bruno',
              ),
            ],
            nextNodeId: 'comparativo',
          ),
        ],
      ),
      'comparativo': ChatNode(
        id: 'comparativo',
        lines: <BotLine>[
          BotLine(
            'Resumo: na reforma o texto muda. Na mutação o texto fica igual e o sentido muda. Na interpretação comum, nada muda: aplica-se o sentido já aceito.',
            sender: 'Profa. Lúcia',
          ),
          BotLine(
            'Se o novo sentido contraria o texto, não é mutação legítima: é mutação inconstitucional.',
            sender: 'Dra. Helena',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'proximo',
            label: 'Vou falar com a Dra. Helena sobre o Senado.',
            react: <BotLine>[
              BotLine('te espero com o caso do Senado.', sender: 'Dra. Helena'),
            ],
          ),
          ChatChoice(
            id: 'revisar',
            label: 'Quero rever o quadro comparativo.',
            react: <BotLine>[
              BotLine(
                'texto mudou, reforma. texto igual e sentido novo, mutação. sentido contrário ao texto, mutação inconstitucional.',
                sender: 'Profa. Lúcia',
              ),
            ],
          ),
        ],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine(
        'texto livre não entra na ata. escolhe uma alternativa.',
        sender: 'Bruno',
      ),
      BotLine(
        'A discussão está boa, mas precisamos fechar uma tese. Use uma das opções.',
        sender: 'Dra. Helena',
      ),
    ],
  ),
  'bruno': ChatScript(
    contactId: 'bruno',
    startNodeId: 'triagem1',
    nodes: <String, ChatNode>{
      'triagem1': ChatNode(
        id: 'triagem1',
        lines: <BotLine>[
          BotLine(
            'O ministro liberou a triagem. Três cartões chegaram na sua mesa.',
          ),
          BotLine(
            'Preciso despachar esses casos pro Ministro AGORA! Vou te mandar as cartas dos casos e você tem 40 segundos para classificar cada uma. Não deixa o tempo zerar!',
          ),
        ],
        card: CardChallenge(
          situation: 'O Congresso aprova uma emenda acrescentando um novo inciso ao art. 5º, criando um novo direito fundamental.',
          index: 1,
          total: 3,
          seconds: 40,
          timeoutNextNodeId: 'triagem2',
          timeoutLine: BotLine(
            '⏳ O tempo zerou! Emenda é reforma formal: o texto constitucional mudou pela via do art. 60. Anota e corre pro próximo!',
            sender: 'Bruno',
          ),
        ),
        choices: <ChatChoice>[
          ChatChoice(
            id: 'reforma',
            label: 'É reforma formal (PEC)',
            isCorrect: true,
            react: <BotLine>[
              BotLine('Boa!! Mandou muito rápido, já anexei no processo! 👏🔥'),
              BotLine(
                'isso. o texto foi alterado pela via formal do art. 60. mutação nunca mexe no texto.',
              ),
            ],
            nextNodeId: 'triagem2',
          ),
          ChatChoice(
            id: 'mutacao',
            label: 'É mutação constitucional',
            isCorrect: false,
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'Opa, cuidado! Se mudou o texto da Constituição, é reforma formal, não mutação! ⏳⚠️',
              ),
              BotLine('aqui o texto mudou: é reforma, não mutação.'),
            ],
            nextNodeId: 'triagem2',
          ),
          ChatChoice(
            id: 'inconstitucional',
            label: 'É inconstitucionalidade',
            isCorrect: false,
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'não. emenda é a via formal de reforma. a questão é só classificar o processo.',
              ),
            ],
            nextNodeId: 'triagem2',
          ),
        ],
      ),
      'triagem2': ChatNode(
        id: 'triagem2',
        lines: <BotLine>[BotLine('boa. próxima carta, rápido!')],
        card: CardChallenge(
          situation: 'Sem qualquer alteração no texto, o STF passa a ler um dispositivo de forma mais ampla, com apoio na dignidade e na igualdade.',
          index: 2,
          total: 3,
          seconds: 40,
          timeoutNextNodeId: 'triagem3',
          timeoutLine: BotLine(
            '⏳ Zerou! Aqui não houve emenda: texto igual, sentido novo e dentro das palavras = mutação. Respira e vai pra última carta!',
            sender: 'Bruno',
          ),
        ),
        choices: <ChatChoice>[
          ChatChoice(
            id: 'mutacao',
            label: 'É mutação constitucional',
            isCorrect: true,
            react: <BotLine>[
              BotLine('Isso! Duas de duas, tá voando! 👏🔥'),
              BotLine(
                'isso. texto igual, sentido novo, e a leitura cabe nas palavras do dispositivo.',
              ),
            ],
            nextNodeId: 'triagem3',
          ),
          ChatChoice(
            id: 'reforma',
            label: 'É reforma formal (PEC)',
            isCorrect: false,
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'Opa, cuidado! Nenhuma palavra foi alterada. Se o texto ficou igual e o sentido mudou, é mutação! ⏳⚠️',
              ),
            ],
            nextNodeId: 'triagem3',
          ),
          ChatChoice(
            id: 'inconstitucional',
            label: 'É inconstitucionalidade',
            isCorrect: false,
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'não. aqui a nova leitura cabe no texto e se apoia em princípios. isso é mutação legítima.',
              ),
            ],
            nextNodeId: 'triagem3',
          ),
        ],
      ),
      'triagem3': ChatNode(
        id: 'triagem3',
        lines: <BotLine>[BotLine('última carta. não deixa zerar!')],
        card: CardChallenge(
          situation: 'Uma lei estabelece que, onde a Constituição diz “é vedado”, deve-se ler “é permitido em casos de urgência”.',
          index: 3,
          total: 3,
          seconds: 40,
          timeoutNextNodeId: 'resumo',
          timeoutLine: BotLine(
            '⏳ Acabou o tempo! “Vedado” virou “permitido”: sentido contrário ao texto = mutação inconstitucional. Ainda dá tempo de fechar bem.',
            sender: 'Bruno',
          ),
        ),
        choices: <ChatChoice>[
          ChatChoice(
            id: 'inconstitucional',
            label: 'É inconstitucionalidade',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Fechou a triagem! Mandou bem demais, pode despachar! 👏🔥',
              ),
              BotLine(
                '“vedado” e “permitido” são opostos: a lei não interpreta, contraria o texto. e lei não altera a Constituição.',
              ),
            ],
            nextNodeId: 'resumo',
          ),
          ChatChoice(
            id: 'mutacao',
            label: 'É mutação constitucional',
            isCorrect: false,
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'Opa! O sentido é contrário às palavras: isso é mutação inconstitucional, não mutação legítima! ⏳⚠️',
              ),
            ],
            nextNodeId: 'resumo',
          ),
          ChatChoice(
            id: 'reforma',
            label: 'É reforma formal (PEC)',
            isCorrect: false,
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'não. não houve emenda. houve uma tentativa de inverter o sentido por lei: mutação inconstitucional.',
              ),
            ],
            nextNodeId: 'resumo',
          ),
        ],
      ),
      'resumo': ChatNode(
        id: 'resumo',
        lines: <BotLine>[
          BotLine(
            'fecha o critério: texto mudou? reforma. texto igual e sentido cabe nas palavras? mutação. texto igual, mas sentido contrário ao texto ou aos princípios? mutação inconstitucional.',
          ),
          BotLine(
            'Agora passa no Grupo de Estudos: a Profa. Lúcia vai fechar a teoria antes da Helena.',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'proximo',
            label: 'Vou ao Grupo de Estudos.',
            react: <BotLine>[
              BotLine(
                'a Profa. Lúcia te espera. depois é a Helena com o caso do Senado.',
              ),
            ],
          ),
        ],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine('calma, não consigo ler tudo. escolhe uma classificação.'),
      BotLine(
        'a triagem é objetiva: reforma, mutação ou mutação inconstitucional.',
      ),
    ],
  ),
  'helena': ChatScript(
    contactId: 'helena',
    startNodeId: 'rascunho',
    nodes: <String, ChatNode>{
      'rascunho': ChatNode(
        id: 'rascunho',
        lines: <BotLine>[
          BotLine(
            'Gente, o estagiário antigo escreveu esse resumo sobre Mutação Constitucional antes de sair, mas tá cheio de erro conceitual.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'Cliquem nas mensagens que estão ERRADAS para a gente apagar antes que o Ministro veja!',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'olha o tamanho do problema. seis conceitos no rascunho.',
            sender: 'Bruno',
          ),
          BotLine(
            'Vou colar aqui embaixo, do jeito que ele deixou.',
            sender: 'Dra. Helena',
          ),
        ],
        inspection: InspectionChallenge(
          statements: <DraftStatement>[
            DraftStatement(
              id: 's1',
              text: 'A mutação constitucional altera a letra da Constituição.',
              isFalse: true,
              sender: 'Dra. Helena',
            ),
            DraftStatement(
              id: 's2',
              text: 'A mutação ocorre por meio de Emenda Constitucional.',
              isFalse: true,
              sender: 'Dra. Helena',
            ),
            DraftStatement(
              id: 's3',
              text: 'Mutação e reforma constitucional são sinônimos.',
              isFalse: true,
              sender: 'Dra. Helena',
            ),
            DraftStatement(
              id: 's4',
              text: 'A mutação constitucional é sempre legítima, mesmo quando contraria o texto.',
              isFalse: true,
              sender: 'Dra. Helena',
            ),
            DraftStatement(
              id: 's5',
              text: 'A mutação constitucional muda o sentido da norma sem alterar o texto.',
              isFalse: false,
              sender: 'Dra. Helena',
            ),
            DraftStatement(
              id: 's6',
              text: 'A reforma constitucional altera o texto pela via formal do art. 60.',
              isFalse: false,
              sender: 'Dra. Helena',
            ),
          ],
          successLines: <BotLine>[
            BotLine(
              'Boa! Era isso mesmo: mutação muda o sentido, não a letra.',
              sender: 'Dra. Helena',
            ),
            BotLine(
              'E não se faz por emenda: emenda é reforma formal.',
              sender: 'Profa. Lúcia',
            ),
            BotLine(
              'rascunho limpo. agora o Ministro não vê besteira.',
              sender: 'Bruno',
            ),
            BotLine(
              'Vou anexar a versão corrigida. A Profa. Lúcia te espera para o caso do voto secreto.',
              sender: 'Dra. Helena',
            ),
          ],
        ),
        choices: <ChatChoice>[],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine(
        'Depois do rascunho. Agora clica nos balões errados.',
        sender: 'Dra. Helena',
      ),
      BotLine('foca: marca só o que está errado.', sender: 'Bruno'),
    ],
  ),
  'lucia': ChatScript(
    contactId: 'lucia',
    startNodeId: 'caso4',
    nodes: <String, ChatNode>{
      'caso4': ChatNode(
        id: 'caso4',
        lines: <BotLine>[
          BotLine(
            'A Helena te trouxe até os limites da mutação. Guarde esse critério: o último caso é hipotético e testa exatamente isso.',
          ),
          BotLine(
            'Um tribunal decide que, com as novas tecnologias, o “voto secreto” da Constituição passou a significar voto registrado com o nome do eleitor, para facilitar auditorias.',
          ),
          BotLine(
            'O texto continua dizendo “voto secreto”. Os autores da decisão afirmam: “é apenas uma mutação constitucional”. Como classificar?',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'inconstitucional',
            label: 'Mutação inconstitucional: contraria o texto expresso e atinge cláusula pétrea.',
            react: <BotLine>[
              BotLine(
                'isso. “secreto” e “identificado” são sentidos opostos: a decisão não interpreta, contraria. E o voto secreto é cláusula pétrea (art. 60, § 4º, II).',
              ),
            ],
            nextNodeId: 'debate',
          ),
          ChatChoice(
            id: 'valida',
            label: 'Mutação válida: o texto ficou igual e acompanhou a tecnologia.',
            react: <BotLine>[
              BotLine(
                'cuidado: texto igual não basta. a mutação precisa caber dentro das possibilidades do texto. aqui o sentido é o oposto: mutação inconstitucional.',
              ),
            ],
            nextNodeId: 'debate',
          ),
          ChatChoice(
            id: 'emenda',
            label: 'Seria válida se feita por emenda constitucional.',
            react: <BotLine>[
              BotLine(
                'nem por emenda. voto direto, secreto, universal e periódico é cláusula pétrea. proposta tendente a aboli-lo não pode sequer ser deliberada.',
              ),
            ],
            nextNodeId: 'debate',
          ),
        ],
      ),
      'debate': ChatNode(
        id: 'debate',
        lines: <BotLine>[
          BotLine(
            'Agora um debate real. O art. 5º, LVII, diz que “ninguém será considerado culpado até o trânsito em julgado de sentença penal condenatória”.',
          ),
          BotLine(
            'O texto nunca mudou, mas o STF mudou de entendimento três vezes: 2009, HC 84.078 — só após o trânsito em julgado; 2016, HC 126.292 — admitiu a execução após a segunda instância; 2019, ADCs 43, 44 e 54 — voltou a exigir o trânsito em julgado, por 6 a 5.',
          ),
          BotLine('Três mudanças em dez anos. O que isso revela?'),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'inseguranca',
            label: 'Que há um risco de insegurança jurídica.',
            react: <BotLine>[
              BotLine(
                'sim. estabilidade também é um valor constitucional. e esse é um dos custos de uma mutação mal conduzida.',
              ),
            ],
            nextNodeId: 'reflexao',
          ),
          ChatChoice(
            id: 'mutacao',
            label: 'Que o STF fez mutação constitucional em 2016.',
            react: <BotLine>[
              BotLine(
                'muitos críticos dizem que sim: a decisão teria contrariado a expressão “até o trânsito em julgado”. outros defendem que era interpretação possível. o debate é legítimo.',
              ),
            ],
            nextNodeId: 'reflexao',
          ),
          ChatChoice(
            id: 'texto',
            label: 'Que o texto do art. 5º, LVII, foi alterado.',
            style: AnswerStyle.wrong,
            react: <BotLine>[
              BotLine(
                'não. o texto nunca foi emendado. é justamente por isso que o caso é usado para discutir mutação.',
              ),
            ],
            nextNodeId: 'reflexao',
          ),
        ],
      ),
      'reflexao': ChatNode(
        id: 'reflexao',
        lines: <BotLine>[
          BotLine(
            'Antes da banca: a Constituição pode mudar de sentido sem mudar uma palavra? Sim, desde que o novo sentido caiba no texto e não viole princípios fundamentais, cláusulas pétreas ou a separação de Poderes.',
          ),
          BotLine(
            'Se ultrapassar esses limites, não é mutação legítima: é mutação inconstitucional.',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'banca',
            label: 'Estou pronto para a banca do Ministro.',
            react: <BotLine>[
              BotLine(
                'O Ministro está te esperando. Cinco questões. Não me decepcione.',
              ),
            ],
          ),
          ChatChoice(
            id: 'revisar',
            label: 'Rever os limites antes de encarar a banca.',
            react: <BotLine>[
              BotLine(
                'bom. texto, cláusulas pétreas e separação de Poderes. revise com calma e me avise quando estiver pronto.',
              ),
            ],
            nextNodeId: 'revisao',
          ),
        ],
      ),
      'revisao': ChatNode(
        id: 'revisao',
        lines: <BotLine>[
          BotLine(
            'Recapitulando os três limites: 1) o novo sentido precisa caber nas palavras do texto; 2) não pode violar princípios fundamentais nem cláusulas pétreas (art. 60, § 4º); 3) não pode retirar de um Poder uma competência que a Constituição lhe deu.',
          ),
          BotLine(
            'Se o sentido contraria o texto, a resposta é uma só: mutação inconstitucional. Agora você está pronto para a banca.',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'banca',
            label: 'Enfrentar a banca do Ministro.',
            react: <BotLine>[
              BotLine(
                'Vai lá. O gabinete inteiro acompanhou seu raciocínio — e ele está sólido.',
              ),
            ],
          ),
        ],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine(
        'Boa pergunta, mas preciso que você feche uma tese. Escolha uma opção.',
      ),
      BotLine(
        'No debate, cada resposta precisa de fundamento. Use uma das alternativas.',
      ),
    ],
  ),
  'banca': ChatScript(
    contactId: 'banca',
    startNodeId: 'q1',
    isQuiz: true,
    nodes: <String, ChatNode>{
      'q1': ChatNode(
        id: 'q1',
        lines: <BotLine>[
          BotLine(
            'Você passou pelo Caso 1, pela triagem, pelo Senado e pelo voto secreto. Agora fecho o expediente com cinco respostas rápidas.',
            sender: 'Ministro',
          ),
          BotLine(
            'Uma de cada vez. Questão 1: o que diferencia a mutação da reforma constitucional?',
            sender: 'Ministro',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'b',
            label: 'Na mutação, muda o sentido e o texto permanece; na reforma, o texto é alterado.',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Correto. Reforma é a via formal do art. 60, que altera o texto. A mutação é informal e mantém o texto.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q2',
          ),
          ChatChoice(
            id: 'a',
            label: 'A mutação é feita só pelo Congresso.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto. O Congresso faz reforma. A mutação é difusa: juízes, Legislativo, Executivo e a própria sociedade.',
                sender: 'Ministro',
              ),
              BotLine(
                'Anote: na mutação o texto fica; na reforma, o texto muda.',
                sender: 'Dra. Helena',
              ),
            ],
            nextNodeId: 'q2',
          ),
          ChatChoice(
            id: 'c',
            label: 'A reforma é informal e a mutação é formal.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto — é o inverso. A reforma é formal (emenda, art. 60); a mutação é informal.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q2',
          ),
        ],
      ),
      'q2': ChatNode(
        id: 'q2',
        lines: <BotLine>[
          BotLine(
            'Questão 2. Por que a mutação é possível?',
            sender: 'Ministro',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'a',
            label: 'Porque texto e norma não se confundem: o mesmo texto pode gerar sentidos diferentes ao longo do tempo.',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Correto. A norma é o sentido extraído do texto. A CF/88 é rígida, e o STF não altera o texto: interpreta.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q3',
          ),
          ChatChoice(
            id: 'b',
            label: 'Porque o STF pode alterar o texto da Constituição.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto. O STF interpreta; não emenda a Constituição.',
                sender: 'Ministro',
              ),
              BotLine(
                'Quem altera o texto é o Congresso, pelo art. 60.',
                sender: 'Dra. Helena',
              ),
            ],
            nextNodeId: 'q3',
          ),
          ChatChoice(
            id: 'c',
            label: 'Porque a Constituição de 1988 é flexível.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto. A CF/88 é rígida. O que muda, sem tocar no texto, é o sentido da norma.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q3',
          ),
        ],
      ),
      'q3': ChatNode(
        id: 'q3',
        lines: <BotLine>[
          BotLine(
            'Questão 3. Qual destes NÃO é um meio de mutação constitucional?',
            sender: 'Ministro',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'emenda',
            label: 'Emenda constitucional.',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Correto. Emenda é reforma, pois altera o texto. Interpretação e costume mudam o sentido sem tocar no texto.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q4',
          ),
          ChatChoice(
            id: 'judicial',
            label: 'Interpretação judicial.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Atenção: a pergunta pede o que NÃO é meio de mutação. Interpretação judicial é o meio mais estudado no Brasil.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q4',
          ),
          ChatChoice(
            id: 'costume',
            label: 'Costume constitucional.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Atenção: costume constitucional é, sim, um meio de mutação. A resposta era emenda.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q4',
          ),
        ],
      ),
      'q4': ChatNode(
        id: 'q4',
        lines: <BotLine>[
          BotLine(
            'Questão 4. Na Rcl 4335/AC, a tese de mutação do art. 52, X...',
            sender: 'Ministro',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'b',
            label: 'Foi defendida por Gilmar Mendes e Eros Grau, mas não formou maioria.',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Correto. A reclamação foi julgada procedente com base na Súmula Vinculante 26. O tema voltou nas ADIs 3406 e 3470, em 2017.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q5',
          ),
          ChatChoice(
            id: 'a',
            label: 'Foi aprovada por unanimidade.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto. Houve divergência: Sepúlveda Pertence, Joaquim Barbosa, Lewandowski e Marco Aurélio rejeitaram a tese.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q5',
          ),
          ChatChoice(
            id: 'c',
            label: 'Nunca foi discutida no STF.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto. Foi o debate mais famoso sobre mutação no Brasil, na Rcl 4335/AC (2014).',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'q5',
          ),
        ],
      ),
      'q5': ChatNode(
        id: 'q5',
        lines: <BotLine>[
          BotLine(
            'Questão 5. Uma “mutação” que atribui ao texto um sentido oposto ao que ele diz é...',
            sender: 'Ministro',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'b',
            label: 'Mutação inconstitucional.',
            isCorrect: true,
            react: <BotLine>[
              BotLine(
                'Correto. O texto é o limite da interpretação. Ultrapassá-lo, ou atingir cláusula pétrea, configura mutação inconstitucional.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'encerramento',
          ),
          ChatChoice(
            id: 'a',
            label: 'Legítima, desde que feita pelo STF.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto. O STF não tem poder de reescrever a Constituição.',
                sender: 'Ministro',
              ),
              BotLine(
                'Texto igual não basta: o sentido precisa caber no texto.',
                sender: 'Dra. Helena',
              ),
            ],
            nextNodeId: 'encerramento',
          ),
          ChatChoice(
            id: 'c',
            label: 'Reforma constitucional.',
            isCorrect: false,
            react: <BotLine>[
              BotLine(
                'Incorreto. Não houve alteração do texto, então não é reforma. É mutação inconstitucional.',
                sender: 'Ministro',
              ),
            ],
            nextNodeId: 'encerramento',
          ),
        ],
      ),
      'encerramento': ChatNode(
        id: 'encerramento',
        lines: <BotLine>[
          BotLine('Fim do expediente. O diagnóstico saiu.', sender: 'Ministro'),
          BotLine(
            'Para revisar: FERRAZ, Anna Cândida da Cunha. Processos informais de mudança da Constituição; HESSE, Konrad. A força normativa da Constituição; MÜLLER, Friedrich. Teoria estruturante do direito.',
            sender: 'Dra. Helena',
          ),
          BotLine(
            'E as decisões: ADPF 132 e ADI 4277 (2011); Rcl 4335/AC (2014); ADIs 3406 e 3470 (2017); HC 84.078 (2009); HC 126.292 (2016); ADCs 43, 44 e 54 (2019).',
            sender: 'Ministro',
          ),
        ],
        choices: <ChatChoice>[
          ChatChoice(
            id: 'fechar',
            label: 'Encerrar o expediente.',
            react: <BotLine>[
              BotLine(
                'Bom trabalho. A Constituição continua a mesma — e o sentido, em movimento.',
                sender: 'Ministro',
              ),
            ],
          ),
          ChatChoice(
            id: 'revisar',
            label: 'Quero rever o critério dos limites.',
            react: <BotLine>[
              BotLine(
                'Texto, cláusulas pétreas e separação de Poderes. Se o novo sentido contraria algum deles, é mutação inconstitucional.',
                sender: 'Dra. Helena',
              ),
            ],
          ),
        ],
      ),
    },
    freeTextReplies: <BotLine>[
      BotLine(
        'O plenário está esperando. Escolha uma resposta.',
        sender: 'Ministro',
      ),
      BotLine('Foco: uma alternativa por questão.', sender: 'Dra. Helena'),
    ],
    praiseLines: <BotLine>[
      BotLine(
        'Precisão de assessor. É assim que se responde no gabinete.',
        sender: 'Ministro',
      ),
      BotLine(
        'Exato. Guarde esse raciocínio para o plenário.',
        sender: 'Dra. Helena',
      ),
      BotLine('Resposta limpa. Sem atalho, sem achismo.', sender: 'Ministro'),
      BotLine(
        'Fundamento certeiro. O gabinete está bem representado.',
        sender: 'Ministro',
      ),
      BotLine(
        'Perfeito. Você está no ponto para sustentar essa tese.',
        sender: 'Dra. Helena',
      ),
    ],
  ),
};
