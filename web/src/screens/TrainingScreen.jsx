import { useEffect } from 'react';
import MentorAvatar from '../components/MentorAvatar';
import { CornerMarks, Scales, Seal, Stars } from '../components/Ornaments';
import { MENTORS, mentorById } from '../data/mentors';
import { personalize, useGame } from '../state/GameContext';

function DialogueTail({ color }) {
  return (
    <>
      <span
        className="absolute -top-3 left-1/2 h-4 w-4 -translate-x-1/2 rotate-45 border-l border-t border-white/10 lg:hidden"
        style={{ background: '#0c2634' }}
        aria-hidden="true"
      />
      <span
        className="absolute -left-2 top-[30%] hidden h-4 w-4 rotate-45 border-b border-l border-white/10 lg:block"
        style={{ background: '#0c2634', boxShadow: `-8px 8px 24px -16px ${color}` }}
        aria-hidden="true"
      />
    </>
  );
}

export default function TrainingScreen() {
  const {
    state,
    dispatch,
    currentAct,
    currentLine,
    totalActs,
    isManual,
  } = useGame();

  const mentor = currentLine?.mentor ? mentorById(currentLine.mentor) : null;
  const actNumber = state.actIndex + 1;
  const activeId = state.showSummary ? 'amanda' : currentLine?.mentor;

  function advance() {
    dispatch({ type: 'ADVANCE_LINE' });
  }

  function back() {
    dispatch({ type: 'BACK_LINE' });
  }

  function nextAct() {
    dispatch({ type: 'NEXT_ACT' });
  }

  useEffect(() => {
    function onKeyDown(event) {
      if (event.key === 'ArrowRight' || event.key === ' ' || event.key === 'Enter') {
        if (event.target instanceof HTMLElement && ['INPUT', 'TEXTAREA', 'BUTTON'].includes(event.target.tagName)) {
          return;
        }
        event.preventDefault();
        dispatch({ type: 'ADVANCE_LINE' });
      }
      if (event.key === 'ArrowLeft') {
        event.preventDefault();
        dispatch({ type: 'BACK_LINE' });
      }
      if (event.key === 'Escape') {
        dispatch({ type: 'GO_WELCOME' });
      }
    }
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [dispatch]);

  return (
    <div className="relative flex min-h-screen flex-col overflow-hidden bg-stage-radial">
      <div className="pointer-events-none absolute inset-0 grid-lines opacity-25" />
      <Stars className="pointer-events-none absolute -right-52 -top-64 h-[46rem] w-[46rem] text-gold opacity-[0.16]" />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-48 bg-gradient-to-t from-ink/95 to-transparent" />

      <header className="relative z-20 border-b border-white/[0.07] bg-ink/30 backdrop-blur-xl">
        <div className="mx-auto flex w-full max-w-[1440px] items-center gap-4 px-4 py-3 sm:px-7 lg:px-10">
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
                {currentAct.number}
              </span>
              <p className="truncate font-display text-xs font-bold tracking-wide text-parchment/85 sm:text-sm">
                {currentAct.title}
              </p>
            </div>
            <p className="hidden truncate text-[10px] text-parchment/35 sm:block">
              {currentAct.subtitle}
            </p>
          </div>

          <div className="hidden items-center gap-3 md:flex">
            <span className="text-[9px] font-semibold uppercase tracking-[0.2em] text-parchment/35">
              Ato {actNumber} de {totalActs}
            </span>
            <div className="flex items-center gap-1.5">
              {Array.from({ length: totalActs }).map((_, index) => (
                <span
                  key={index}
                  className={`h-1.5 rounded-full transition-all ${
                    index === state.actIndex
                      ? 'w-7 bg-gold'
                      : index < state.actIndex
                        ? 'w-3 bg-teal/70'
                        : 'w-3 bg-white/15'
                  }`}
                />
              ))}
            </div>
          </div>
        </div>
      </header>

      <main
        className="relative z-10 mx-auto grid w-full max-w-[1440px] flex-1 grid-cols-1 content-start items-start gap-3 px-4 py-5 sm:px-7 lg:grid-cols-[minmax(260px,0.72fr)_minmax(0,1.28fr)] lg:content-center lg:items-center lg:gap-8 lg:px-10 lg:py-7"
        onClick={state.showSummary ? undefined : advance}
        role={state.showSummary ? undefined : 'button'}
        tabIndex={state.showSummary ? -1 : 0}
        aria-label={state.showSummary ? undefined : 'Avançar o diálogo'}
      >
        <section className="relative flex min-h-[150px] self-start items-end justify-center overflow-hidden rounded-[1.75rem] border border-white/10 bg-gradient-to-b from-white/[0.055] to-white/[0.015] px-4 pb-0 pt-4 shadow-stage lg:min-h-[430px] lg:items-center lg:self-stretch lg:py-0">
          <div className="absolute inset-0 opacity-60">
            <div className="absolute left-1/2 top-[14%] h-56 w-56 -translate-x-1/2 rounded-full bg-gold/10 blur-3xl" />
            <div className="absolute bottom-0 left-1/2 h-36 w-[75%] -translate-x-1/2 rounded-t-[50%] border-t border-gold/15 bg-gradient-to-t from-black/40 to-transparent" />
          </div>
          <CornerMarks className="m-5 opacity-50" />

          <div className="absolute left-5 top-5 flex items-center gap-2">
            <span className="h-1.5 w-1.5 animate-pulse rounded-full bg-teal" />
            <span className="text-[9px] font-bold uppercase tracking-[0.22em] text-parchment/40">
              {state.showSummary ? 'Fim do ato' : 'Sala de treinamento'}
            </span>
          </div>

          <div className="relative z-10 flex flex-col items-center pb-1 lg:pb-0">
            {state.showSummary ? (
              <>
                <div className="lg:hidden">
                  <MentorAvatar
                    id="amanda"
                    size="lg"
                    speaking
                    headOnly
                  />
                </div>
                <div className="hidden lg:block">
                  <MentorAvatar id="amanda" size="xl" speaking showName />
                </div>
                <p className="mt-1 hidden max-w-[13rem] text-center text-[10px] uppercase leading-relaxed tracking-[0.16em] text-parchment/35 sm:block">
                  A coordenação fecha o ato com os pontos essenciais.
                </p>
              </>
            ) : mentor ? (
              <>
                <div className="lg:hidden">
                  <MentorAvatar
                    id={mentor.id}
                    size="lg"
                    speaking
                    headOnly
                  />
                </div>
                <div className="hidden lg:block">
                  <MentorAvatar
                    id={mentor.id}
                    size="xl"
                    speaking
                    showName
                    showRole
                  />
                </div>
                <div
                  className="mt-2 hidden rounded-full border px-3 py-1 text-[9px] font-bold uppercase tracking-[0.18em] lg:mt-3 lg:inline-flex"
                  style={{
                    borderColor: `${mentor.color}66`,
                    color: mentor.color,
                    background: `${mentor.color}14`,
                  }}
                >
                  {mentor.trait}
                </div>
              </>
            ) : (
              <>
                <div className="relative grid h-28 w-28 place-items-center rounded-full border border-gold/30 bg-gold/5 text-gold shadow-glow lg:h-40 lg:w-40">
                  <Scales className="h-20 w-20 lg:h-28 lg:w-28" />
                  <span className="absolute inset-3 rounded-full border border-gold/10" />
                </div>
                <p className="mt-5 font-serif text-2xl italic text-gold/90">
                  O gabinete
                </p>
                <p className="mt-1 text-[9px] uppercase tracking-[0.24em] text-parchment/30">
                  Cena
                </p>
              </>
            )}
          </div>
        </section>

        <section
          className="relative flex min-w-0 flex-col justify-center lg:min-h-[430px]"
          aria-live="polite"
        >
          {state.showSummary ? (
            <div className="paper-card noise feedback-enter relative p-6 sm:p-8">
              <CornerMarks className="m-3 opacity-60" />
              <div className="relative z-10">
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <p className="eyebrow text-gold-deep">Resumo do ato</p>
                    <h2 className="mt-1 max-w-lg font-display text-2xl font-extrabold leading-tight tracking-tight text-ink sm:text-3xl">
                      {currentAct.summaryTitle}
                    </h2>
                  </div>
                  <span className="grid h-12 w-12 shrink-0 place-items-center rounded-full border border-teal-deep/25 bg-teal-deep/10 text-teal-deep">
                    <svg viewBox="0 0 24 24" className="h-6 w-6" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M5 12.5l4.5 4.5L20 6.5" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                  </span>
                </div>

                <ul className="mt-5 space-y-3">
                  {currentAct.summary.map((item, index) => (
                    <li key={item} className="flex gap-3">
                      <span className="mt-0.5 grid h-6 w-6 shrink-0 place-items-center rounded-md bg-gold-deep/10 font-display text-[10px] font-extrabold text-gold-deep">
                        {index + 1}
                      </span>
                      <p className="text-[13px] leading-relaxed text-ink/70">
                        {item}
                      </p>
                    </li>
                  ))}
                </ul>

                <p className="mt-5 border-t border-ink/10 pt-4 font-serif text-sm italic text-ink/45">
                  Guarde este resumo. Ele é a régua para classificar os
                  próximos processos.
                </p>

                <div className="mt-6 flex flex-col-reverse gap-3 sm:flex-row">
                  <button
                    type="button"
                    onClick={(event) => {
                      event.stopPropagation();
                      dispatch({ type: 'BACK_LINE' });
                    }}
                    className="flex h-12 flex-1 items-center justify-center gap-2 rounded-xl border border-ink/15 bg-white/50 px-4 text-[11px] font-bold uppercase tracking-[0.14em] text-ink/60 transition-colors hover:border-ink/30 hover:text-ink"
                  >
                    <svg viewBox="0 0 24 24" className="h-4 w-4" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M9 18l6-6-6-6" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                    Rever o diálogo
                  </button>
                  <button
                    type="button"
                    onClick={(event) => {
                      event.stopPropagation();
                      nextAct();
                    }}
                    className="group flex h-12 flex-[1.5] items-center justify-center gap-2 rounded-xl bg-ink px-5 font-display text-[11px] font-bold uppercase tracking-[0.14em] text-parchment transition-all hover:-translate-y-0.5 hover:bg-navy"
                  >
                    {state.actIndex === totalActs - 1
                      ? 'Ir para a mesa de cartas'
                      : `Ir para o Ato ${state.actIndex + 2}`}
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
          ) : (
            <div className="relative animate-fade">
              <div className="mb-3 flex items-center justify-between gap-4">
                <div className="flex items-center gap-2">
                  <span
                    className="h-2 w-2 rounded-full"
                    style={{ backgroundColor: mentor?.color || '#d8b56a' }}
                  />
                  <p className="text-[9px] font-bold uppercase tracking-[0.22em] text-parchment/35">
                    {mentor ? 'Fala do mentor' : 'Narração'}
                  </p>
                </div>
                <p className="text-[9px] font-semibold uppercase tracking-[0.18em] text-parchment/30">
                  {isManual
                    ? 'Cena avulsa'
                    : `${state.lineIndex + 1} / ${currentAct.lines.length}`}
                </p>
              </div>

              <div className="relative rounded-[1.6rem] border border-white/10 bg-[#0c2634]/90 p-5 shadow-stage backdrop-blur-xl sm:p-7">
                <DialogueTail color={mentor?.glow || '#d8b56a'} />
                <div className="flex items-center gap-3 border-b border-white/[0.07] pb-4">
                  {mentor ? (
                    <span
                      className="grid h-9 w-9 shrink-0 place-items-center rounded-full border border-white/15 font-display text-[9px] font-extrabold text-white lg:hidden"
                      style={{
                        background: `linear-gradient(145deg, ${mentor.color}, #0a2637)`,
                      }}
                    >
                      {mentor.initials}
                    </span>
                  ) : (
                    <span className="grid h-9 w-9 place-items-center rounded-full border border-gold/30 bg-gold/10 text-gold">
                      <Scales className="h-6 w-6" />
                    </span>
                  )}
                  <div className="min-w-0">
                    <p className="font-display text-sm font-bold tracking-wide text-parchment">
                      {mentor ? mentor.name : 'O gabinete'}
                    </p>
                    <p className="truncate text-[10px] uppercase tracking-[0.16em] text-parchment/35">
                      {mentor ? `${mentor.role} · ${mentor.trait}` : 'Cena do treinamento'}
                    </p>
                  </div>
                  {currentLine.emphasis && (
                    <span
                      className="ml-auto hidden shrink-0 rounded-full border px-2.5 py-1 text-[9px] font-bold uppercase tracking-[0.14em] sm:block"
                      style={{
                        borderColor: `${mentor?.color || '#d8b56a'}55`,
                        color: mentor?.color || '#d8b56a',
                        background: `${mentor?.color || '#d8b56a'}12`,
                      }}
                    >
                      {currentLine.emphasis}
                    </span>
                  )}
                </div>

                <div className="min-h-[150px] pt-5 sm:min-h-[170px]">
                  <p
                    className={`text-balance text-[clamp(1.05rem,1.55vw,1.42rem)] leading-[1.6] ${
                      mentor
                        ? 'text-parchment/90'
                        : 'font-serif text-[clamp(1.25rem,1.8vw,1.65rem)] italic leading-[1.5] text-parchment/75'
                    }`}
                  >
                    {personalize(currentLine.text, state.name)}
                  </p>
                  {currentLine.emphasis && (
                    <p className="mt-4 text-[9px] font-bold uppercase tracking-[0.18em] text-gold/70 sm:hidden">
                      {currentLine.emphasis}
                    </p>
                  )}
                </div>

                <div className="mt-4 flex items-center gap-2 border-t border-white/[0.07] pt-4">
                  <span className="flex items-center gap-1.5 text-[9px] uppercase tracking-[0.16em] text-parchment/30">
                    <svg viewBox="0 0 24 24" className="h-3.5 w-3.5" fill="none" stroke="currentColor" strokeWidth="1.7">
                      <path d="M8 13V6.5a1.5 1.5 0 013 0V12M11 12V4.5a1.5 1.5 0 013 0V12M14 12V5.5a1.5 1.5 0 013 0V13M8 10.5l-1.6-.8A1.6 1.6 0 004 11.2V14c0 4 2.7 6 6 6h2c3.3 0 5-2 5-5v-2" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                    {isManual ? 'Cena avulsa do gabinete' : 'Toque na cena para avançar'}
                  </span>
                  <span className="ml-auto hidden text-[9px] uppercase tracking-[0.14em] text-parchment/20 sm:block">
                    ESPAÇO · →
                  </span>
                </div>
              </div>

              <div className="mt-4 flex items-center gap-3">
                <button
                  type="button"
                  onClick={(event) => {
                    event.stopPropagation();
                    back();
                  }}
                  disabled={!isManual && state.lineIndex === 0}
                  className="flex h-11 items-center gap-2 rounded-xl border border-white/10 px-4 text-[10px] font-bold uppercase tracking-[0.14em] text-parchment/60 transition-colors hover:border-white/25 hover:text-parchment disabled:cursor-not-allowed disabled:opacity-25"
                >
                  <svg viewBox="0 0 24 24" className="h-4 w-4" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M15 18l-6-6 6-6" strokeLinecap="round" strokeLinejoin="round" />
                  </svg>
                  <span className="hidden sm:inline">Fala anterior</span>
                </button>

                <div className="h-1 flex-1 overflow-hidden rounded-full bg-white/10">
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{
                      width: isManual
                        ? '100%'
                        : `${((state.lineIndex + 1) / currentAct.lines.length) * 100}%`,
                      background: `linear-gradient(90deg, ${mentor?.color || '#63c7b8'}, #d8b56a)`,
                    }}
                  />
                </div>

                <button
                  type="button"
                  onClick={(event) => {
                    event.stopPropagation();
                    advance();
                  }}
                  className="flex h-11 items-center gap-2 rounded-xl px-5 font-display text-[10px] font-bold uppercase tracking-[0.14em] text-ink transition-transform hover:-translate-y-0.5"
                  style={{ backgroundColor: mentor?.color || '#d8b56a', color: '#fff' }}
                >
                  {isManual
                    ? 'Encerrar cena'
                    : state.lineIndex === currentAct.lines.length - 1
                      ? 'Ver resumo'
                      : 'Avançar'}
                  <svg viewBox="0 0 24 24" className="h-4 w-4" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M9 6l6 6-6 6" strokeLinecap="round" strokeLinejoin="round" />
                  </svg>
                </button>
              </div>
            </div>
          )}
        </section>
      </main>

      <footer className="relative z-20 border-t border-white/[0.07] bg-ink/35 backdrop-blur-xl">
        <div className="mx-auto flex w-full max-w-[1440px] items-center gap-3 overflow-x-auto px-4 py-2.5 sm:px-7 lg:px-10">
          <span className="hidden shrink-0 text-[9px] font-bold uppercase tracking-[0.2em] text-parchment/30 sm:block">
            Mentores
          </span>
          <span className="hidden h-4 w-px shrink-0 bg-white/10 sm:block" />
          <div className="scrollbar-none flex flex-1 items-end justify-between gap-1 overflow-x-auto pb-0.5 sm:justify-start sm:gap-4">
            {MENTORS.map((item) => {
              const active = activeId === item.id;
              return (
                <button
                  key={item.id}
                  type="button"
                  onClick={() => {
                    if (!state.showSummary && item.id === currentLine.mentor) advance();
                  }}
                  className={`group relative flex shrink-0 items-center gap-2 rounded-full border px-2 py-1 transition-all ${
                    active
                      ? 'border-gold/40 bg-gold/10'
                      : 'border-transparent opacity-50 hover:opacity-80'
                  }`}
                  title={item.role}
                >
                  <span
                    className="grid h-7 w-7 place-items-center rounded-full border border-white/15 font-display text-[8px] font-extrabold text-white"
                    style={{
                      background: `linear-gradient(145deg, ${item.color}, #0a2637)`,
                    }}
                  >
                    {item.initials}
                  </span>
                  <span className={`hidden font-display text-[10px] font-semibold tracking-wide sm:block ${active ? 'text-gold-soft' : 'text-parchment/55'}`}>
                    {item.name}
                  </span>
                  {active && (
                    <span className="absolute -top-1 right-1 h-1.5 w-1.5 rounded-full bg-teal shadow-[0_0_8px_rgba(99,199,184,0.9)]" />
                  )}
                </button>
              );
            })}
          </div>
          <p className="hidden shrink-0 text-[9px] uppercase tracking-[0.16em] text-parchment/25 lg:block">
            {personalize('Bom trabalho, {name}.', state.name)}
          </p>
        </div>
      </footer>
    </div>
  );
}
