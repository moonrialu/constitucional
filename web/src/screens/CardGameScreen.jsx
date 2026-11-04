import { useEffect } from 'react';
import ConceptCard from '../components/ConceptCard';
import MentorAvatar from '../components/MentorAvatar';
import { CornerMarks, Scales, Seal, Stars } from '../components/Ornaments';
import { CARD_ROUNDS, cardById } from '../data/cards';
import { mentorById } from '../data/mentors';
import { personalize, useGame } from '../state/GameContext';

const MAX_SCORE = CARD_ROUNDS.length * 20;

function ScoreRing({ score }) {
  const pct = Math.min(1, score / MAX_SCORE);
  return (
    <div
      className="relative grid h-24 w-24 shrink-0 place-items-center rounded-full"
      style={{
        background: `conic-gradient(#d8b56a ${pct * 360}deg, rgba(255,255,255,0.09) 0)`,
      }}
    >
      <div className="absolute inset-[7px] rounded-full bg-ink" />
      <div className="relative text-center">
        <p className="font-display text-2xl font-extrabold leading-none text-parchment">
          {score}
        </p>
        <p className="mt-1 text-[8px] font-bold uppercase tracking-[0.18em] text-parchment/35">
          de {MAX_SCORE}
        </p>
      </div>
    </div>
  );
}

function FeedbackModal({ round, result, onNext, isLast }) {
  const chosen = cardById(result.selected);
  const answer = cardById(result.answer);
  const positive = result.correct;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-ink/80 px-4 py-6 backdrop-blur-md">
      <div className="feedback-enter paper-card noise w-full max-w-2xl p-6 sm:p-8">
        <CornerMarks className="m-3 opacity-60" />
        <div className="relative z-10">
          <div className="flex items-start gap-4">
            <span
              className={`grid h-14 w-14 shrink-0 place-items-center rounded-full border ${
                positive
                  ? 'border-teal-deep/25 bg-teal-deep/10 text-teal-deep'
                  : 'border-wine/25 bg-wine/10 text-wine'
              }`}
            >
              {positive ? (
                <svg viewBox="0 0 24 24" className="h-7 w-7" fill="none" stroke="currentColor" strokeWidth="2.2">
                  <path d="M5 12.5l4.5 4.5L20 6.5" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              ) : (
                <svg viewBox="0 0 24 24" className="h-7 w-7" fill="none" stroke="currentColor" strokeWidth="2.2">
                  <path d="M6 6l12 12M18 6L6 18" strokeLinecap="round" />
                </svg>
              )}
            </span>
            <div className="min-w-0 flex-1">
              <div className="flex flex-wrap items-center gap-2">
                <p className={`eyebrow ${positive ? 'text-teal-deep' : 'text-wine'}`}>
                  Resultado da aplicação
                </p>
                <span
                  className={`rounded-full px-2 py-0.5 text-[9px] font-extrabold uppercase tracking-[0.14em] ${
                    positive
                      ? 'bg-teal-deep/10 text-teal-deep'
                      : 'bg-wine/10 text-wine'
                  }`}
                >
                  {positive ? '+20 pontos' : '0 ponto'}
                </span>
              </div>
              <h2 className="mt-1 font-display text-2xl font-extrabold leading-tight tracking-tight text-ink sm:text-3xl">
                {positive ? 'Carta certeira.' : 'A leitura não se sustenta.'}
              </h2>
              <p className="mt-1 text-[11px] uppercase tracking-[0.14em] text-ink/40">
                {round.caseLabel}
              </p>
            </div>
          </div>

          <p className="mt-5 text-[13px] leading-relaxed text-ink/70">
            {result.explanation}
          </p>

          {!positive && (
            <div className="mt-4 rounded-xl border border-wine/15 bg-wine/[0.045] p-4">
              <p className="text-[10px] font-extrabold uppercase tracking-[0.16em] text-wine">
                Onde a carta escolhida falha
              </p>
              <p className="mt-1.5 text-[12px] leading-relaxed text-ink/65">
                {round.traps?.[result.selected] ||
                  'A carta escolhida descreve outro fenômeno constitucional.'}
              </p>
            </div>
          )}

          <div className="mt-5 grid gap-3 sm:grid-cols-2">
            <div
              className={`rounded-xl border p-3 ${
                positive
                  ? 'border-teal-deep/20 bg-teal-deep/[0.05]'
                  : 'border-wine/15 bg-wine/[0.03]'
              }`}
            >
              <p className="text-[9px] font-extrabold uppercase tracking-[0.16em] text-ink/40">
                {positive ? 'Sua carta' : 'Você jogou'}
              </p>
              <p className="mt-1 font-display text-sm font-bold text-ink">
                {chosen.title}
              </p>
              <p className="mt-0.5 text-[10px] text-ink/45">{chosen.subtitle}</p>
            </div>
            <div className="rounded-xl border border-gold-deep/25 bg-gold-deep/[0.055] p-3">
              <p className="text-[9px] font-extrabold uppercase tracking-[0.16em] text-gold-deep">
                Carta correta
              </p>
              <p className="mt-1 font-display text-sm font-bold text-ink">
                {answer.title}
              </p>
              <p className="mt-0.5 text-[10px] text-ink/45">{answer.subtitle}</p>
            </div>
          </div>

          <button
            type="button"
            onClick={onNext}
            className="group mt-6 flex h-12 w-full items-center justify-center gap-2 rounded-xl bg-ink px-5 font-display text-[11px] font-bold uppercase tracking-[0.16em] text-parchment transition-all hover:-translate-y-0.5 hover:bg-navy"
          >
            {isLast ? 'Ver diagnóstico do gabinete' : 'Próximo processo'}
            <svg
              viewBox="0 0 24 24"
              className="h-4 w-4 transition-transform group-hover:translate-x-1"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <path d="M4 12h15M13 6l6 6-6 6" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  );
}

function FinalReport() {
  const { state, dispatch } = useGame();
  const correct = state.answers.filter((answer) => answer.correct).length;
  const total = CARD_ROUNDS.length;
  const pct = correct / total;

  const rank =
    correct === total
      ? {
          title: 'Gabinete aprovado',
          label: 'Leitura impecável',
          message:
            'Você separou texto e norma, reconheceu os meios da mutação e aplicou os limites com precisão.',
        }
      : correct >= total - 1
        ? {
            title: 'Assessor em destaque',
            label: 'Quase perfeito',
            message:
              'O gabinete confia no seu parecer. Reveja o único ponto que escapou e a régua fica completa.',
          }
        : correct >= Math.ceil(total / 2)
          ? {
              title: 'Gabinete em formação',
              label: 'Base construída',
              message:
                'Você já distingue os fenômenos principais. A revisão dos erros abaixo fecha o raciocínio.',
            }
          : {
              title: 'Treinamento em curso',
              label: 'Recomece o diálogo',
              message:
                'A mesa cobrou o que o treinamento ainda não fixou. Reveja os atos e volte às cartas.',
            };

  return (
    <div className="relative flex min-h-screen flex-col overflow-hidden bg-stage-radial">
      <div className="pointer-events-none absolute inset-0 grid-lines opacity-25" />
      <Stars className="pointer-events-none absolute left-1/2 top-0 h-[50rem] w-[50rem] -translate-x-1/2 -translate-y-1/3 text-gold opacity-[0.16]" />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-52 bg-gradient-to-t from-ink to-transparent" />

      <div className="relative z-10 mx-auto flex w-full max-w-5xl flex-1 flex-col justify-center px-4 py-8 sm:px-8">
        <div className="animate-rise paper-card noise p-6 sm:p-10">
          <CornerMarks className="m-4 opacity-60" />
          <div className="relative z-10">
            <div className="flex flex-col items-start justify-between gap-6 sm:flex-row sm:items-center">
              <div>
                <div className="flex items-center gap-3">
                  <span className="text-gold-deep">
                    <Seal className="h-10 w-10" />
                  </span>
                  <div>
                    <p className="eyebrow text-gold-deep">Diagnóstico do gabinete</p>
                    <p className="text-[10px] uppercase tracking-[0.18em] text-ink/35">
                      Mesa de fixação · {total} processos
                    </p>
                  </div>
                </div>
                <h1 className="mt-4 max-w-xl font-display text-3xl font-extrabold leading-[1.05] tracking-tight text-ink sm:text-4xl">
                  {personalize('{name}, o gabinete ouviu seu parecer.', state.name)}
                </h1>
                <p className="mt-2 max-w-xl text-[13px] leading-relaxed text-ink/55">
                  {rank.message}
                </p>
              </div>

              <div className="flex items-center gap-4">
                <div
                  className="relative grid h-28 w-28 place-items-center rounded-full"
                  style={{
                    background: `conic-gradient(#1d7d74 ${pct * 360}deg, rgba(10,38,55,0.12) 0)`,
                  }}
                >
                  <div className="absolute inset-[8px] rounded-full bg-parchment" />
                  <div className="relative text-center">
                    <p className="font-display text-3xl font-extrabold leading-none text-ink">
                      {correct}
                      <span className="text-lg text-ink/30">/{total}</span>
                    </p>
                    <p className="mt-1 text-[8px] font-bold uppercase tracking-[0.2em] text-ink/35">
                      acertos
                    </p>
                  </div>
                </div>
                <div>
                  <p className="rounded-full bg-teal-deep/10 px-3 py-1 text-[9px] font-extrabold uppercase tracking-[0.16em] text-teal-deep">
                    {rank.label}
                  </p>
                  <p className="mt-2 font-display text-lg font-extrabold text-ink">
                    {rank.title}
                  </p>
                  <p className="text-[10px] uppercase tracking-[0.16em] text-ink/35">
                    {state.score} de {MAX_SCORE} pontos
                  </p>
                </div>
              </div>
            </div>

            <div className="mt-8 border-t border-ink/10 pt-5">
              <div className="flex items-center justify-between">
                <p className="text-[10px] font-extrabold uppercase tracking-[0.2em] text-ink/45">
                  Folha de respostas
                </p>
                <p className="text-[10px] font-semibold uppercase tracking-[0.16em] text-ink/30">
                  {personalize('Assessor(a): {name}', state.name)}
                </p>
              </div>

              <div className="mt-3 grid gap-2 sm:grid-cols-2">
                {CARD_ROUNDS.map((round, index) => {
                  const answer = state.answers.find(
                    (item) => item.roundId === round.id,
                  );
                  const chosen = answer ? cardById(answer.selected) : null;
                  return (
                    <div
                      key={round.id}
                      className={`flex items-center gap-3 rounded-xl border px-3 py-2.5 ${
                        answer?.correct
                          ? 'border-teal-deep/20 bg-teal-deep/[0.045]'
                          : 'border-wine/15 bg-wine/[0.035]'
                      }`}
                    >
                      <span
                        className={`grid h-7 w-7 shrink-0 place-items-center rounded-full text-[10px] font-extrabold ${
                          answer?.correct
                            ? 'bg-teal-deep/15 text-teal-deep'
                            : 'bg-wine/10 text-wine'
                        }`}
                      >
                        {index + 1}
                      </span>
                      <div className="min-w-0 flex-1">
                        <p className="truncate font-display text-[11px] font-bold text-ink">
                          {round.title}
                        </p>
                        <p className="mt-0.5 text-[9px] leading-snug text-ink/40">
                          {chosen?.title || 'Não respondida'} · correta:{' '}
                          {cardById(round.answer).title}
                        </p>
                      </div>
                      <span
                        className={`text-[9px] font-extrabold uppercase tracking-[0.12em] ${
                          answer?.correct ? 'text-teal-deep' : 'text-wine'
                        }`}
                      >
                        {answer?.correct ? 'Certa' : 'Errada'}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>

            <div className="mt-7 flex flex-col-reverse gap-3 sm:flex-row">
              <button
                type="button"
                onClick={() => dispatch({ type: 'GO_WELCOME' })}
                className="flex h-12 flex-1 items-center justify-center gap-2 rounded-xl border border-ink/15 bg-white/40 px-4 text-[10px] font-bold uppercase tracking-[0.16em] text-ink/60 transition-colors hover:border-ink/30 hover:text-ink"
              >
                Voltar ao início
              </button>
              <button
                type="button"
                onClick={() => dispatch({ type: 'RESTART_CARDS' })}
                className="group flex h-12 flex-[1.4] items-center justify-center gap-2 rounded-xl bg-ink px-5 font-display text-[10px] font-bold uppercase tracking-[0.16em] text-parchment transition-all hover:-translate-y-0.5 hover:bg-navy"
              >
                Refazer a mesa
                <svg
                  viewBox="0 0 24 24"
                  className="h-4 w-4 transition-transform group-hover:rotate-180"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                >
                  <path d="M20 11a8 8 0 10-2.3 5.7M20 4v7h-7" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <p className="mt-4 text-center text-[9px] uppercase tracking-[0.24em] text-parchment/25">
          O parecer fica no gabinete · revise os atos sempre que quiser
        </p>
      </div>
    </div>
  );
}

export default function CardGameScreen() {
  const {
    state,
    dispatch,
    currentRound,
    totalRounds,
  } = useGame();

  const mentor = mentorById(currentRound?.mentor);
  const selected = state.selectedCard ? cardById(state.selectedCard) : null;
  const isLast = state.questionIndex === totalRounds - 1;
  const roundNumber = state.questionIndex + 1;

  const options = currentRound.options.map((id) => cardById(id));
  const optionIds = currentRound.options;

  useEffect(() => {
    function onKeyDown(event) {
      if (state.finished || state.result) return;
      const number = Number(event.key);
      if (number >= 1 && number <= optionIds.length) {
        dispatch({ type: 'SELECT_CARD', cardId: optionIds[number - 1] });
      }
      if (event.key === 'Enter' && state.selectedCard) {
        event.preventDefault();
        dispatch({ type: 'APPLY_CARD' });
      }
    }
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [dispatch, optionIds, state.finished, state.result, state.selectedCard]);

  if (state.finished) {
    return <FinalReport />;
  }

  return (
    <div className="relative flex min-h-screen flex-col overflow-hidden bg-table-radial">
      <div className="pointer-events-none absolute inset-0 grid-lines opacity-20" />
      <Stars className="pointer-events-none absolute -left-56 top-1/2 h-[44rem] w-[44rem] -translate-y-1/2 text-teal opacity-[0.12]" />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-56 bg-gradient-to-t from-ink to-transparent" />

      <header className="relative z-30 border-b border-white/[0.07] bg-ink/35 backdrop-blur-xl">
        <div className="mx-auto flex w-full max-w-[1440px] items-center gap-3 px-4 py-3 sm:px-7 lg:px-10">
          <button
            type="button"
            onClick={() => dispatch({ type: 'GO_WELCOME' })}
            className="flex items-center gap-2 rounded-full border border-white/10 px-3 py-1.5 text-[10px] font-semibold uppercase tracking-[0.16em] text-parchment/55 transition-colors hover:border-gold/40 hover:text-gold"
          >
            <svg viewBox="0 0 24 24" className="h-3.5 w-3.5" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M15 6l-6 6 6 6" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
            Sair
          </button>

          <div className="hidden h-6 w-px bg-white/10 sm:block" />

          <div className="min-w-0 flex-1">
            <div className="flex items-center gap-2">
              <span className="rounded-full border border-gold/30 bg-gold/5 px-2.5 py-0.5 font-display text-[9px] font-bold uppercase tracking-[0.18em] text-gold">
                Mesa de fixação
              </span>
              <p className="truncate font-display text-xs font-bold tracking-wide text-parchment/85 sm:text-sm">
                Mutação constitucional
              </p>
            </div>
            <p className="hidden text-[10px] text-parchment/35 sm:block">
              Aplique o conceito certo a cada processo
            </p>
          </div>

          <div className="hidden items-center gap-4 sm:flex">
            <div className="text-right">
              <p className="text-[8px] font-bold uppercase tracking-[0.2em] text-parchment/30">
                Processo
              </p>
              <p className="font-display text-sm font-extrabold tabular-nums text-parchment">
                {String(roundNumber).padStart(2, '0')}
                <span className="text-parchment/30"> / {String(totalRounds).padStart(2, '0')}</span>
              </p>
            </div>
            <span className="h-7 w-px bg-white/10" />
            <div className="text-right">
              <p className="text-[8px] font-bold uppercase tracking-[0.2em] text-parchment/30">
                Pontos
              </p>
              <p className="font-display text-sm font-extrabold tabular-nums text-gold">
                {state.score}
                <span className="text-parchment/30"> / {MAX_SCORE}</span>
              </p>
            </div>
          </div>
        </div>
      </header>

      <main className="relative z-10 mx-auto flex w-full max-w-[1440px] flex-1 flex-col px-4 py-5 sm:px-7 lg:px-10">
        <div className="grid flex-1 grid-cols-1 items-stretch gap-4 lg:grid-cols-[280px_minmax(0,1fr)]">
          <aside className="relative hidden overflow-hidden rounded-2xl border border-white/10 bg-white/[0.04] p-4 shadow-stage lg:flex lg:flex-col">
            <CornerMarks className="m-3 opacity-40" />
            <div className="flex items-center gap-2">
              <span className="h-1.5 w-1.5 rounded-full bg-teal" />
              <p className="text-[9px] font-bold uppercase tracking-[0.2em] text-parchment/40">
                Quem pergunta
              </p>
            </div>
            <div className="flex flex-1 flex-col items-center justify-center py-2">
              <MentorAvatar
                id={mentor.id}
                size="lg"
                speaking
                showName
                showRole
              />
            </div>
            <div className="relative rounded-xl border border-white/10 bg-ink/45 p-3.5">
              <p className="text-[9px] font-extrabold uppercase tracking-[0.16em] text-gold/80">
                {mentor.trait}
              </p>
              <p className="mt-1.5 font-serif text-[15px] italic leading-snug text-parchment/70">
                {personalize(
                  'Sua vez, {name}. Leia o processo e escolha a carta que traduz o que a Constituição exige.',
                  state.name,
                )}
              </p>
            </div>
          </aside>

          <section className="paper-card noise min-w-0 p-5 sm:p-7">
            <CornerMarks className="m-3 opacity-50" />
            <div className="relative z-10 flex h-full flex-col">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div className="flex items-center gap-3">
                  <span className="grid h-11 w-11 place-items-center rounded-full border border-gold-deep/25 bg-gold-deep/[0.06] text-gold-deep">
                    <Scales className="h-8 w-8" />
                  </span>
                  <div>
                    <p className="text-[9px] font-extrabold uppercase tracking-[0.18em] text-gold-deep">
                      {currentRound.caseLabel}
                    </p>
                    <p className="text-[10px] uppercase tracking-[0.14em] text-ink/35">
                      Gabinete 09 · processo {roundNumber} de {totalRounds}
                    </p>
                  </div>
                </div>
                <div className="rounded-full border border-ink/10 bg-ink/[0.035] px-3 py-1 text-[9px] font-bold uppercase tracking-[0.16em] text-ink/40">
                  Aguardando sua carta
                </div>
              </div>

              <div className="mt-4 flex items-start gap-3 lg:hidden">
                <MentorAvatar id={mentor.id} size="sm" showName />
                <div className="rounded-xl border border-ink/10 bg-ink/[0.035] p-2.5">
                  <p className="text-[9px] font-extrabold uppercase tracking-[0.14em] text-gold-deep">
                    Pergunta de {mentor.name}
                  </p>
                  <p className="mt-0.5 text-[11px] leading-snug text-ink/55">
                    Escolha a carta que traduz o que a Constituição exige.
                  </p>
                </div>
              </div>

              <h2 className="mt-4 font-display text-2xl font-extrabold leading-tight tracking-tight text-ink sm:text-[1.8rem]">
                {currentRound.title}
              </h2>
              <p className="mt-2 text-[12.5px] leading-relaxed text-ink/60 sm:text-[13px]">
                {currentRound.scenario}
              </p>

              <div className="mt-5 rounded-xl border border-ink/10 bg-white/35 p-3.5">
                <p className="text-[9px] font-extrabold uppercase tracking-[0.18em] text-ink/35">
                  Régua de decisão
                </p>
                <div className="mt-2 grid gap-1.5 sm:grid-cols-3">
                  {[
                    'O texto mudou?',
                    'O sentido cabe nas palavras?',
                    'Os limites foram respeitados?',
                  ].map((item, index) => (
                    <div key={item} className="flex items-center gap-2">
                      <span className="grid h-5 w-5 shrink-0 place-items-center rounded-md bg-ink/[0.055] font-display text-[8px] font-extrabold text-ink/45">
                        {index + 1}
                      </span>
                      <p className="text-[10px] leading-tight text-ink/55">{item}</p>
                    </div>
                  ))}
                </div>
              </div>

              <div className="mt-auto pt-4">
                <div className="rounded-xl border border-gold-deep/20 bg-gold-deep/[0.055] px-4 py-3">
                  <p className="text-[9px] font-extrabold uppercase tracking-[0.18em] text-gold-deep">
                    Pergunta do mentor
                  </p>
                  <p className="mt-1 font-serif text-[17px] italic leading-snug text-ink/80">
                    {currentRound.question}
                  </p>
                </div>
              </div>
            </div>
          </section>
        </div>

        <section className="mt-4 flex flex-1 flex-col">
          <div className="mb-2 flex flex-wrap items-end justify-between gap-3">
            <div>
              <div className="flex items-center gap-2">
                <p className="eyebrow">Sua mão</p>
                <span className="rounded-full border border-white/10 px-2 py-0.5 text-[9px] font-bold uppercase tracking-[0.14em] text-parchment/35">
                  {options.length} cartas
                </span>
              </div>
              <p className="mt-0.5 text-[10px] text-parchment/35">
                Selecione um conceito e aplique ao processo.
              </p>
            </div>
            <div className="flex items-center gap-3">
              {selected ? (
                <div className="hidden items-center gap-2 rounded-full border border-gold/30 bg-gold/10 px-3 py-1.5 sm:flex">
                  <span className="h-1.5 w-1.5 rounded-full bg-gold" />
                  <span className="text-[9px] font-bold uppercase tracking-[0.14em] text-gold-soft">
                    {selected.title}
                  </span>
                </div>
              ) : (
                <p className="hidden text-[9px] uppercase tracking-[0.16em] text-parchment/25 sm:block">
                  Clique em uma carta
                </p>
              )}
              <button
                type="button"
                onClick={() => dispatch({ type: 'APPLY_CARD' })}
                disabled={!selected}
                className={`group flex h-11 items-center gap-2 rounded-xl px-5 font-display text-[10px] font-bold uppercase tracking-[0.16em] transition-all ${
                  selected
                    ? 'bg-gold text-ink hover:-translate-y-0.5 hover:bg-gold-soft'
                    : 'cursor-not-allowed border border-white/10 bg-white/[0.03] text-parchment/25'
                }`}
              >
                Aplicar carta
                <svg
                  viewBox="0 0 24 24"
                  className="h-4 w-4 transition-transform group-hover:translate-x-0.5"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                >
                  <path d="M4 12h15M13 6l6 6-6 6" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              </button>
            </div>
          </div>

          <div className="scrollbar-none -mx-4 flex flex-1 items-end overflow-x-auto px-6 pb-5 pt-10 sm:mx-0 sm:px-4">
            <div className="mx-auto flex min-w-max items-end justify-center gap-1.5 sm:gap-3">
              {options.map((card, index) => (
                <ConceptCard
                  key={card.id}
                  card={card}
                  index={index}
                  total={options.length}
                  selected={state.selectedCard === card.id}
                  disabled={Boolean(state.result)}
                  onClick={() =>
                    dispatch({ type: 'SELECT_CARD', cardId: card.id })
                  }
                />
              ))}
            </div>
          </div>

          <div className="flex flex-wrap items-center justify-between gap-2 border-t border-white/[0.07] pt-3">
            <div className="flex items-center gap-1.5">
              {CARD_ROUNDS.map((round, index) => {
                const answer = state.answers.find(
                  (item) => item.roundId === round.id,
                );
                return (
                  <span
                    key={round.id}
                    className={`h-1.5 rounded-full transition-all ${
                      answer
                        ? answer.correct
                          ? 'w-7 bg-teal'
                          : 'w-7 bg-wine'
                        : index === state.questionIndex
                          ? 'w-7 bg-gold'
                          : 'w-3 bg-white/15'
                    }`}
                  />
                );
              })}
            </div>
            <p className="text-[9px] uppercase tracking-[0.16em] text-parchment/25">
              {personalize('Mesa de {name}', state.name)} · validação imediata
            </p>
          </div>
        </section>
      </main>

      {state.result && (
        <FeedbackModal
          round={currentRound}
          result={state.result}
          isLast={isLast}
          onNext={() => dispatch({ type: 'NEXT_QUESTION' })}
        />
      )}
    </div>
  );
}
