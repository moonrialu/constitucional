# Assessora do STF por um dia — Mutação constitucional (v2.0)

OVA de Direito Constitucional I (Faculdade Baiana de Direito, 2026.2) em
**paisagem**, com dois modos:

1. **Jornada de mutação constitucional** (principal): onboarding com o nome do
   estudante, treinamento em estilo *visual novel* com seis mentores e, depois,
   quatro processos com dinâmica de fixação e teste final, em 16 telas.
2. **Baralho de argumentos** (extra): o jogo de cartas original, com cinco
   batalhas sobre regras, princípios e mutação.

Esta é a **versão 2.0**, em projeto separado. A v1.0 permanece intacta em
`/home/luiza/Projetos/meu_app` como backup. As duas podem ficar instaladas no
mesmo aparelho:

| | v1.0 | v2.0 |
|---|---|---|
| Pasta | `meu_app` | `meu_app_v2` |
| Pacote Dart | `meu_app` | `assessora_stf_cards` |
| applicationId | `com.luiza.meu_app` | `com.luiza.assessora_stf_cards` |
| Save | `ova_stf_progress_v1` | `ova_stf_cards_progress_v1` + `ova_mutacao_progress_v1` |
| Orientação | livre | paisagem |

## Jornada de mutação constitucional

O roteiro segue a lógica **onboarding → treinamento → prática**:

```
onboarding (nome) → capa → objetivos
  → treinamento 1 (texto × norma)
  → treinamento 2 (mutação × reforma × meios)
  → treinamento 3 (limites da mutação)
  → caso 1 → feedback
  → classificação (3 itens) → feedback
  → caso 3 (Senado) → feedback + linha do tempo
  → caso 4 (voto secreto) → feedback + linha do tempo
  → teste final (5 questões, feedback imediato) → diagnóstico → créditos
```

### Onboarding

Na primeira abertura, o app pede o nome antes de liberar a jornada. O nome é
salvo no aparelho, normalizado (espaços extras removidos) e passa a aparecer
nos balões dos mentores, no título das perguntas, no diagnóstico e nos
créditos. Na capa, a saudação “Olá, {nome}” tem um lápis para editar o nome a
qualquer momento. Sem nome salvo, o onboarding volta a ser exibido.

### Fase de treinamento (visual novel)

Três atos conduzidos pelos seis mentores — **Amanda, Ian, Gabriel, Luiza,
Rafael e Paola** — em balões de diálogo que avançam ao tocar na cena:

- **Ato 1 — Texto não é norma**: texto × norma, partitura e música,
  concretização (Müller), regras × princípios, *Verfassungswandlung* e a
  definição de mutação.
- **Ato 2 — Mutação, reforma e os meios**: reforma (art. 60) × mutação ×
  interpretação comum; os três meios (judicial, legislativo e costume); o
  debate do art. 52, X (Rcl 4335, ADIs 3406/3470).
- **Ato 3 — Os limites da mutação**: texto, princípios e cláusulas pétreas,
  separação de Poderes, mutação inconstitucional e o caso da segunda
  instância.

Cada ato termina em um **resumo didático** com os pontos essenciais. O estudante
pode voltar falas, rever o diálogo inteiro e só então seguir para o próximo ato.
O texto dos diálogos fica em `lib/data/training_dialogue.dart` e usa `{nome}`
para ser personalizado.

### Prática e avaliação

- **4 casos** com feedback específico para cada alternativa, inclusive as
  erradas.
- **11 interações**: Caso 1, três situações do Caso 2, Caso 3, Caso 4 e cinco
  questões do teste final.
- **2 aplicações práticas**: o papel do Senado (art. 52, X) e o “voto secreto”
  reinterpretado como mutação inconstitucional.
- **Diagnóstico** por faixa de acerto, com recomendação e atalho de revisão para
  cada questão errada; a revisão das questões teóricas abre o resumo do ato
  correspondente.
- **Progresso salvo** a cada resposta; “Continuar” retoma a tela exata.

O conteúdo fica isolado em `lib/data/mutation_content.dart` (casos e teste) e
`lib/data/training_dialogue.dart` (mentores e treinamento); a jornada é montada
a partir de `mutationFlow`, sem conteúdo preso às telas.

## A batalha de cartas

O modo extra transforma cada caso em um duelo contra uma tese adversa:

- **Convicção**: jogador e máquina começam com 18–22 pontos. Zerar a da tese
  vence; zerar a sua permite **retomar a batalha** (não há game over).
- **Energia**: 3 por turno; mão de 5 cartas; baralho de 10; descarte
  reembaralhado quando o monte acaba.
- **Tipos de carta**: ataque (dano), defesa (bloqueio) e apoio (compra carta,
  devolve energia).
- **Objeções**: cada turno a máquina ataca com o texto de uma alternativa
  incorreta do caso. A objeção indica o fundamento que a refuta (`Regra`,
  `Princípio`, `Mutação`, `Precedente`, `Competência`...). Jogar uma carta com a
  tag certa **refuta** o ataque (dano zero no turno) e dá **+3** de bônus.
- **Mão e leitura**: as cartas ficam com apenas 40% visíveis na base. Um toque
  levanta a carta para leitura e outro toque a abaixa; várias cartas podem
  ficar levantadas ao mesmo tempo. **Só o duplo toque joga** a carta — e a
  carta voa da mão até o campo de batalha antes de o efeito ser aplicado.
- **Conjunto de resposta**: com duas ou mais cartas levantadas, o duplo toque
  em qualquer uma delas joga o **conjunto**. Custo e efeitos somam numa única
  jogada (ex.: no caso do candidato de 34 anos, *Idade mínima* + *Subsunção*
  combatem a mesma objeção), e a refutação concede os +3 uma única vez.
- **Relatório pós-batalha**: ao vencer, o app mostra o feedback jurídico
  completo da alternativa correta, o precedente e as cartas recém-liberadas.

### Animações

Distribuição da mão em cascata, flip da objeção a cada turno, elevação das
cartas selecionadas, voo da carta (ou do conjunto, em cascata) até a objeção,
banner da jogada, número de dano flutuante e transições de baralho/mão. Tudo respeita `MediaQuery.disableAnimations`? As durações são
curtas (120–650 ms) e não bloqueiam a jogada.

## Fluxo do modo cartas

```
cover → battle1 → battle2 → battle3 → battle4 → battle5
```

- **battle1..battle5**: Casos 1–5 do roteiro, em duelos de cartas.
- A jornada de mutação é independente e tem o fluxo próprio descrito acima.

## Coleção e desbloqueio

São **44 cartas**, cumulativas. Vencer batalhas e concluir o teste liberam
fundamentos e precedentes (ADI 4815, ADPF 132, ADI 4277, MS 32.033, Rcl 4335).
A coleção fica no menu do gabinete e no painel.

## Como rodar

```bash
flutter pub get
flutter run          # trava em paisagem ao iniciar
```

APK de debug:

```bash
flutter build apk --debug
# build/app/outputs/flutter-apk/app-debug.apk
```

Instalar lado a lado com a v1:

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell am start -n com.luiza.assessora_stf_cards/.MainActivity
```

## Testes

```bash
flutter analyze   # limpo
flutter test      # 55 testes: motor de batalha, jornada de mutação, onboarding,
                  # treinamento em visual novel e renderização das telas
```

## Estrutura

```
lib/
  main.dart, app.dart           # bootstrap, paisagem, tema, Providers
  models/
    card.dart                   # ArgumentCard, CardKind, CardTag
    battle.dart                 # BattleConfig, Objection, BattleRecord, log
    content.dart                # casos, teoria, checks, quiz (modo cartas)
    mutation.dart               # tipos e progresso da jornada de mutação
    progress.dart               # save v2 (batalhas, cartas, visited, quiz)
  data/
    mutation_content.dart       # casos, check, quiz, diagnóstico e créditos
    training_dialogue.dart      # seis mentores e os três atos do treinamento
    cards.dart                  # catálogo de 44 cartas + desbloqueios
    battles.dart                # 5 batalhas: baralhos e objeções
    cases.dart                  # casos e feedbacks (fonte do relatório)
    checks.dart, theory.dart, quiz.dart, glossary.dart, badges.dart
    flow.dart                   # ordem linear do modo cartas
  engine/
    mutation_controller.dart    # telas, nome, respostas, pontuação e auto-save
    battle_engine.dart          # motor puro: turnos, energia, refutação
    game_controller.dart        # fluxo do baralho, desbloqueios, badges
  screens/
    mutation_journey_screen.dart # casca das 16 telas + top bar
    mutation_steps.dart          # capa, casos, check, quiz, diagnóstico
    training_step.dart           # treinamento em visual novel (balões)
    onboarding_screen.dart       # entrada do nome + apresentação dos mentores
    battle_screen.dart           # mesa em paisagem + relatório
    collection_screen.dart       # coleção de cartas
    cover_screen.dart, glossary_screen.dart, root_router.dart
  widgets/
    mentor_avatar.dart           # avatar circular com iniciais dos mentores
    mutation_widgets.dart        # cartões, tabela, linha do tempo, botões
    card_view.dart               # face/verso da carta
    theory_sheet.dart            # teoria em diálogo durante a batalha
    app_menu, game_scaffold...
  utils/
    personalize.dart             # substituição de {nome} nos diálogos
```

Os dois modos são **dado + motor**: para alterar a aula, edite
`lib/data/mutation_content.dart`; para criar uma batalha, inclua um
`BattleConfig` em `lib/data/battles.dart` e as cartas em `lib/data/cards.dart`.

## Persistência

A jornada de mutação usa a chave **`ova_mutacao_progress_v1`**:

```json
{
  "version": 2,
  "userName": "Ana",
  "stepIndex": 4,
  "startedAt": "2026-10-24T12:52:42",
  "finishedAt": null,
  "caseAnswers": {"case1": "B", "case3": "B"},
  "checkAnswers": {"check2/s1": "R", "check2/s2": "M"},
  "quizAnswers": {"q1": "B"}
}
```

Saves da versão 1 (sem `userName`) são lidos e migrados automaticamente para a
versão 2; o nome volta a ser pedido no onboarding quando estiver vazio.

O modo cartas usa a chave **`ova_stf_cards_progress_v1`**, em JSON versionado:

```json
{
  "version": 3,
  "currentStep": "battle3",
  "startedAt": "2026-10-24T12:52:42",
  "finishedAt": null,
  "battles": {
    "battle1": {
      "won": true, "attempts": 2, "turns": 4, "convictionLeft": 11,
      "refutations": 3, "cardsPlayed": 7, "finishedAt": "..."
    }
  },
  "unlockedCards": ["subsuncao", "ponderacao", "adi-4815"],
  "visited": ["cover", "objectives", "battle1", "theory1"],
  "quizAnswers": {"q2": "B"},
  "checkAnswers": {"check1/c1-1": "R"},
  "quizIds": ["q1", "q2", "q3", "q5", "q6", "q8"],
  "badges": ["primeiro-parecer", "refutador"],
  "history": [{"finishedAt": "...", "battlesWon": 5, "battlesTotal": 5,
               "quizScore": 5, "quizTotal": 6, "elapsedMs": 120000}]
}
```

O save da v2 é independente do save da v1; não há migração entre versões.
Fechar o app no meio de uma batalha retoma na batalha (o duelo recomeça, mas a
tentativa fica registrada).

## Próxima fase (v2.1)

- Persistir o estado exato da batalha (mão, monte e convicção) entre sessões.
- Trilha sonora opcional e efeitos de carta.
- Ícone próprio da v2 (carta + balança) para diferenciar da v1 no launcher.
- Modo "rever batalha" sem contar tentativa.
- Vozes ou retratos ilustrados para os seis mentores no treinamento.

## Marca e créditos

Ícone e splash usam a balança da justiça em creme sobre azul-marinho, com
destaque dourado (mesma marca da v1 nesta etapa). Fontes vetoriais em
`assets/branding/`.

Equipe e referências aparecem na tela de créditos; os seis mentores do
treinamento são também os integrantes do grupo (Amanda, Ian, Gabriel, Luiza,
Rafael e Paola).

## Nota de ambiente

No emulador com GPU Intel/Mesa aparece, em algumas capturas, um artefato de
composição (texto duplicado, inclusive na barra de status). É um problema do
compositor do emulador, não do layout do app: reabrir a tela ou capturar de novo
mostra o conteúdo correto. Vale conferir em aparelho físico antes de tratar como
bug de interface.
