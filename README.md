# Mutação Constitucional

Jogo narrativo em formato de conversa para alunos de Direito. O jogador é
assessor(a) no gabinete de um ministro do STF e precisa atravessar quatro
processos sobre **mutação constitucional** — a mudança de sentido da
Constituição sem alteração do texto.

Conteúdo baseado no roteiro do OVA 2 — *Mutação constitucional no gabinete do
STF* (Direito Constitucional I, Faculdade Baiana de Direito, 2026.2).

## As fases

0. **Sala de Dúvidas** — grupo de consulta permanente, disponível desde o
   início. Reúne a explicação de todos os temas (texto x norma, mutação x
   reforma, meios, casos do STF e limites) e não conta como fase.
1. **Grupo do Gabinete** — a missão e a pergunta que atravessa o jogo.
2. **Ministro** — conversa de alto risco: uma posição técnica imediata sobre a união estável (ADPF 132 e ADI 4277). Errar custa 25% de prestígio; prestígio zerado gera o **Decreto de Exoneração**.
3. **Bruno** — minigame de cartas: três situações para classificar com cronômetro (reforma, mutação ou mutação inconstitucional).
4. **Grupo de Estudos** — texto x norma, mutação x reforma e os meios da mutação.
5. **Dra. Helena** — revisão do rascunho: o grupo precisa marcar os balões falsos do resumo sobre mutação antes que o Ministro veja.
6. **Profa. Lúcia** — Caso 4: o “voto secreto” reinterpretado e o debate da segunda instância, com a liberação da banca.
7. **Banca do Ministro** — teste final de 5 questões, com diagnóstico por desempenho e o **encerramento do treinamento**, com a efetivação como Assessor(a) do STF.

Cada fase é desbloqueada ao concluir a anterior. A **Sala de Dúvidas** é a
exceção: fica aberta desde o primeiro acesso, não entra na contagem de
progresso e funciona como material de consulta durante toda a jornada. Algumas
conversas são individuais; outras são grupos, com o nome e o retrato de quem
fala em cada mensagem. A
resposta do jogador é sempre uma lista de falas fixas para escolher. O campo de
texto livre já existe e é enviado de verdade, mas hoje não avança a fase — é o
gancho para um futuro modelo local.

## Gamificação

No topo do chat, a barra de status acompanha o expediente:

- **Cafés (vidas):** existem nos jogos de respostas (cartas do Bruno, Banca do
  Ministro) e na conversa de alto risco com o Ministro. O jogador começa com 3
  xícaras e cada erro apaga uma. Ao chegar a zero, o chat é bloqueado pelo
  modal “Seu cérebro travou!”, com o botão **Recarregar Cafés (Revisar)**, que
  recarrega as xícaras e abre a Sala de Dúvidas.
- **Prestígio no Gabinete (0–100%):** sobe +15 em respostas técnicas, +5 em
  respostas informais e cai −10 em erros conceituais. No teste, cada acerto
  também rende um elogio de um dos personagens da banca. A consulta permanente
  não altera o prestígio.
- **Alto risco (Ministro):** errar a interpretação custa **−25 de prestígio e
  1 café**, com bronca imediata. Se o prestígio chegar a 0 durante a conversa,
  o chat trava e abre a tela vermelha do **Decreto de Exoneração**, com o botão
  **Refazer Treinamento (Voltar ao Grupo 1)**, que zera o progresso e recomeça
  no Grupo do Gabinete. Acertar rende +15, o reconhecimento do Ministro e
  libera o chat do Bruno.
- **Combo 🔥:** dois acertos técnicos seguidos (inclusive fora do teste)
  acendem o selo “2x COMBO”, que pulsa enquanto a sequência continua. Um erro
  zera a sequência.
- **Reações nos balões:** um segundo depois de cada escolha, os outros
  participantes reagem à mensagem do jogador com emojis flutuantes no canto
  inferior do balão — ❤️ e 👏 para acertos, 👀 e 😂 para respostas parciais,
  😱 e 💀 para erros.
- **Cartas jurídicas (Bruno):** no chat do Bruno, a triagem vira um deck de
  cartas com cronômetro regressivo. A barra do tempo fica vermelha nos
  últimos 3 segundos; acertar pinta a carta de verde, soma +15 de prestígio e
  arranca um elogio do Bruno. Errar ou deixar zerar pinta a carta de vermelho,
  treme, custa 1 café e −10 de prestígio, e o Bruno explica o erro antes da
  próxima carta.
- **Revisão do rascunho (Dra. Helena):** o grupo recebe seis balões com o
  resumo que o estagiário antigo deixou. O jogador toca nos balões falsos para
  marcá-los com o selo “FALSO · APAGAR 🗑️” e ganha +10 de prestígio por
  acerto. Se tocar em uma informação verdadeira, a Profa. Lúcia reage com
  “Ei, essa parte tava certa! 👀” e o jogador perde 1 café. Ao marcar todos os
  falsos, a Helena fecha a revisão e a fase é concluída.
- **Encerramento seguro (Banca do Ministro):** ao responder à última interação
  do teste final, o jogo não tenta carregar uma nova pergunta. O estado de
  treinamento concluído é ativado antes da transição, as reações pendentes são
  ignoradas e o app abre o card de efetivação: “🎉 PARABÉNS! VOCÊ FOI
  EFETIVADO!”, com o Prestígio final, os cafés restantes, o aproveitamento da
  banca, o botão **Reiniciar jogo** e a opção de voltar para as conversas. O
  selo “ASSESSOR(A) EFETIVADO(A) · STF” passa a aparecer na lista.

Cafés, prestígio e combo são salvos junto com o progresso e sobrevivem ao
fechamento do app.

## Rodar

```bash
flutter pub get
flutter run -d emulator-5554
```

Android apenas nesta versão. O progresso é salvo com `shared_preferences`: as
fases concluídas e também as conversas em andamento. Se o app for fechado no
meio de uma fase, ao reabrir a conversa retoma no mesmo nó, com as mensagens e o
placar do teste final preservados. A lista marca essas fases como
“Em andamento”.

## Estrutura

```
lib/
  data/game_script.dart        roteiro completo: contatos, nós e escolhas
  models/                      contato, mensagem, nó e escolha
  state/game_controller.dart   progresso, desbloqueio, fluxo do chat e placar
  services/
    progress_store.dart        persistência das fases concluídas e conversas
    reply_strategy.dart        interface + respostas roteirizadas
  screens/                     lista de contatos e tela de chat
  widgets/                     barra de status, bolhas, escolhas, input, avatar
  theme/                       paleta terrosa e tipografia
```

## Editar a história

Todo o texto está em `lib/data/game_script.dart`. Cada contato aponta para um
`ChatScript` com nós; cada nó tem mensagens recebidas e escolhas. Uma escolha
com `nextNodeId` nulo encerra a fase e desbloqueia a próxima. No teste final,
cada questão marca a alternativa correta com `isCorrect: true`. Fora do teste,
`style: AnswerStyle.informal` vale +5 de prestígio e `style: AnswerStyle.wrong`
marca erro conceitual (−10 e zera o combo); sem `style`, a escolha conta como
técnica (+15). Um nó com `card:` vira uma carta jurídica cronometrada: as
escolhas são os três botões, `isCorrect` marca a alternativa certa e
`timeoutLine`/`timeoutNextNodeId` definem o que acontece quando o tempo zera.
Um nó com `inspection:` vira o jogo de marcar balões falsos: cada
`DraftStatement` indica se é erro conceitual, e `successLines` são enviadas
quando todos os falsos forem marcados.

## Referências do conteúdo

- BRASIL. Constituição da República Federativa do Brasil de 1988.
- FERRAZ, Anna Cândida da Cunha. *Processos informais de mudança da Constituição*. São Paulo: Max Limonad, 1986.
- HESSE, Konrad. *A força normativa da Constituição*. Porto Alegre: Sergio Antonio Fabris.
- MÜLLER, Friedrich. *Teoria estruturante do direito*. São Paulo: Revista dos Tribunais.
- MENDES, Gilmar Ferreira; BRANCO, Paulo Gustavo Gonet. *Curso de direito constitucional*. São Paulo: Saraiva.
- STF: ADPF 132 e ADI 4277 (2011); Rcl 4335/AC (2014); ADIs 3406 e 3470 (2017); HC 84.078 (2009); HC 126.292 (2016); ADCs 43, 44 e 54 (2019).

## Próximo passo: modelo local

`ReplyStrategy` em `lib/services/reply_strategy.dart` é o ponto de extensão.
Basta implementar a interface com o modelo local e injetar no `GameController`
em `lib/main.dart`, sem alterar telas ou widgets.
