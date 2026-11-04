import { useEffect, useState } from 'react';
import MentorAvatar from '../components/MentorAvatar';
import { CornerMarks, Scales, Seal, Stars } from '../components/Ornaments';
import { MENTORS } from '../data/mentors';
import { useGame } from '../state/GameContext';

const BRIEFING = [
  {
    number: 'I',
    label: 'Posse',
    text: 'Você assume o gabinete e escolhe como quer ser chamado.',
  },
  {
    number: 'II',
    label: 'Treinamento',
    text: 'Seis mentores conduzem três atos de explicação em diálogo.',
  },
  {
    number: 'III',
    label: 'Mesa de cartas',
    text: 'Seis processos, uma mão de conceitos e validação imediata.',
  },
];

function Hero() {
  return (
    <section className="animate-rise lg:col-start-1 lg:row-start-1 lg:self-end">
      <div className="flex items-center gap-3">
        <span className="h-px w-10 bg-gold/70" />
        <p className="eyebrow">Uma experiência de posse</p>
      </div>

      <h1 className="mt-4 max-w-3xl font-display text-[clamp(2.8rem,6.2vw,5.75rem)] font-extrabold leading-[0.92] tracking-[-0.055em] text-parchment">
        Assessor do STF
        <span className="mt-1 block font-serif text-[clamp(2.9rem,6.4vw,6rem)] font-medium italic leading-[0.88] tracking-[-0.035em] text-gold">
          por um dia.
        </span>
      </h1>

      <p className="mt-6 max-w-xl text-balance text-sm leading-relaxed text-parchment/65 sm:text-[15px]">
        Uma Constituição pode mudar de sentido sem que uma única palavra seja
        alterada? Assuma o gabinete, ouça os mentores e descubra — na mesa de
        cartas — quando a interpretação é legítima e quando se torna usurpação.
      </p>
    </section>
  );
}

function Details() {
  return (
    <section className="animate-rise lg:col-start-1 lg:row-start-2 lg:self-start">
      <div className="grid max-w-2xl gap-3 sm:grid-cols-3">
        {BRIEFING.map((item) => (
          <div
            key={item.number}
            className="group rounded-xl border border-white/10 bg-white/[0.035] p-3.5 transition-colors hover:border-gold/30 hover:bg-white/[0.055]"
          >
            <div className="flex items-center justify-between">
              <span className="font-serif text-xl italic text-gold/80">
                {item.number}
              </span>
              <span className="h-px w-6 bg-gold/25 transition-all group-hover:w-10 group-hover:bg-gold/60" />
            </div>
            <p className="mt-1 font-display text-[11px] font-bold uppercase tracking-[0.18em] text-parchment/85">
              {item.label}
            </p>
            <p className="mt-1 text-[11px] leading-snug text-parchment/45">
              {item.text}
            </p>
          </div>
        ))}
      </div>

      <div className="mt-6">
        <div className="flex items-center gap-3">
          <p className="eyebrow-teal">O conselho do gabinete</p>
          <span className="h-px flex-1 bg-gold-line opacity-60" />
        </div>
        <div className="mt-3 grid max-w-2xl grid-cols-3 gap-x-2 gap-y-4 sm:grid-cols-6">
          {MENTORS.map((mentor, index) => (
            <div
              key={mentor.id}
              title={`${mentor.name} · ${mentor.role}`}
              className="animate-rise"
              style={{ animationDelay: `${140 + index * 55}ms` }}
            >
              <MentorAvatar
                id={mentor.id}
                size="sm"
                showName
                className="mx-auto"
              />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

export default function WelcomeScreen() {
  const { state, dispatch } = useGame();
  const [draft, setDraft] = useState(state.name || '');
  const [error, setError] = useState('');

  useEffect(() => {
    if (state.name) setDraft(state.name);
  }, [state.name]);

  function handleSubmit(event) {
    event.preventDefault();
    const name = draft.trim().replace(/\s+/g, ' ');
    if (!name) {
      setError('Diga como o gabinete deve chamar você.');
      return;
    }
    if (name.length > 40) {
      setError('Use um nome com até 40 caracteres.');
      return;
    }
    setError('');
    dispatch({ type: 'START', name });
  }

  return (
    <div className="relative min-h-screen overflow-hidden bg-stage-radial">
      <div className="pointer-events-none absolute inset-0 grid-lines opacity-40" />
      <div className="pointer-events-none absolute -right-24 top-1/2 hidden -translate-y-1/2 text-gold/[0.08] lg:block">
        <Scales className="h-[92vh] w-auto" />
      </div>
      <Stars className="pointer-events-none absolute -left-40 -top-52 h-[44rem] w-[44rem] text-teal/50 opacity-40" />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-ink/90 to-transparent" />

      <div className="relative z-10 mx-auto flex min-h-screen w-full max-w-[1440px] flex-col px-5 py-5 sm:px-8 lg:px-12">
        <header className="flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <span className="grid h-11 w-11 place-items-center rounded-full border border-gold/40 bg-gold/5 text-gold">
              <Seal className="h-8 w-8" />
            </span>
            <div>
              <p className="font-display text-[11px] font-bold uppercase tracking-[0.3em] text-parchment/90">
                Gabinete 09
              </p>
              <p className="text-[10px] uppercase tracking-[0.24em] text-parchment/40">
                Gabinete-escola de mutação constitucional
              </p>
            </div>
          </div>
          <div className="hidden items-center gap-3 text-right sm:flex">
            <div>
              <p className="eyebrow-teal">Direito Constitucional I</p>
              <p className="text-[10px] uppercase tracking-[0.2em] text-parchment/35">
                Faculdade Baiana de Direito · 2026.2
              </p>
            </div>
            <span className="h-9 w-px bg-gold/25" />
            <span className="rounded-full border border-gold/30 px-3 py-1 font-display text-[10px] font-semibold tracking-[0.16em] text-gold/90">
              OVA 2.0
            </span>
          </div>
        </header>

        <main className="grid flex-1 grid-cols-1 gap-8 py-8 lg:grid-cols-[1.08fr_0.92fr] lg:grid-rows-[auto_auto] lg:items-center lg:gap-x-14 lg:gap-y-7 lg:py-10">
          <Hero />

          <section
            className="relative animate-rise lg:col-start-2 lg:row-span-2 lg:row-start-1 lg:self-center"
            style={{ animationDelay: '120ms' }}
          >
            <div className="pointer-events-none absolute -inset-5 rounded-[2rem] bg-gold/5 blur-3xl" />
            <div className="paper-card noise relative p-6 sm:p-8">
              <CornerMarks className="m-3 opacity-70" />
              <div className="relative z-10">
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <p className="eyebrow text-gold-deep">Termo de posse</p>
                    <h2 className="mt-1 font-display text-2xl font-extrabold tracking-tight text-ink">
                      Identifique-se
                    </h2>
                  </div>
                  <span className="grid h-14 w-14 place-items-center rounded-full border border-gold-deep/30 bg-gold-deep/5 text-gold-deep">
                    <Seal className="h-10 w-10" />
                  </span>
                </div>

                <p className="mt-3 max-w-sm text-[12px] leading-relaxed text-ink/55">
                  O nome informado entra nos balões dos mentores, na mesa de
                  cartas e no relatório final do gabinete.
                </p>

                <form onSubmit={handleSubmit} className="mt-6">
                  <label
                    htmlFor="assessor-name"
                    className="text-[10px] font-extrabold uppercase tracking-[0.22em] text-ink/55"
                  >
                    Como devemos te chamar?
                  </label>
                  <div className="relative mt-2">
                    <span className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-ink/35">
                      <svg viewBox="0 0 24 24" className="h-5 w-5" fill="none" stroke="currentColor" strokeWidth="1.7">
                        <circle cx="12" cy="8" r="3.4" />
                        <path d="M5 20c0-3.5 3.1-6 7-6s7 2.5 7 6" strokeLinecap="round" />
                      </svg>
                    </span>
                    <input
                      id="assessor-name"
                      name="name"
                      value={draft}
                      onChange={(event) => {
                        setDraft(event.target.value);
                        if (error) setError('');
                      }}
                      maxLength={40}
                      autoComplete="given-name"
                      placeholder="Ex.: Ana, Luiza, João..."
                      className="h-14 w-full rounded-xl border border-ink/15 bg-white/70 pl-12 pr-4 text-[15px] font-semibold text-ink placeholder:font-normal placeholder:text-ink/30 transition-colors focus:border-teal-deep focus:bg-white"
                    />
                  </div>
                  <div className="mt-1.5 flex items-center justify-between gap-3">
                    <p className={`text-[11px] ${error ? 'text-wine' : 'text-ink/40'}`}>
                      {error || 'Só neste aparelho, para personalizar a experiência.'}
                    </p>
                    <span className="text-[10px] tabular-nums text-ink/30">
                      {draft.length}/40
                    </span>
                  </div>

                  <button
                    type="submit"
                    className="group mt-5 flex h-14 w-full items-center justify-center gap-3 rounded-xl bg-ink px-5 font-display text-sm font-bold tracking-wide text-parchment shadow-[0_18px_40px_-18px_rgba(6,21,31,0.9)] transition-all hover:-translate-y-0.5 hover:bg-navy hover:shadow-[0_24px_50px_-20px_rgba(6,21,31,0.95)]"
                  >
                    Assumir o gabinete
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
                </form>

                <div className="mt-6 flex items-center gap-4 border-t border-ink/10 pt-4">
                  <div className="flex items-center gap-1.5 text-[10px] font-semibold uppercase tracking-[0.14em] text-ink/45">
                    <span className="h-1.5 w-1.5 rounded-full bg-teal-deep" />6 mentores
                  </div>
                  <div className="flex items-center gap-1.5 text-[10px] font-semibold uppercase tracking-[0.14em] text-ink/45">
                    <span className="h-1.5 w-1.5 rounded-full bg-gold-deep" />3 atos
                  </div>
                  <div className="flex items-center gap-1.5 text-[10px] font-semibold uppercase tracking-[0.14em] text-ink/45">
                    <span className="h-1.5 w-1.5 rounded-full bg-wine" />6 processos
                  </div>
                </div>
              </div>
            </div>

            <p className="mt-4 text-center text-[10px] uppercase tracking-[0.24em] text-parchment/30">
              Uma jornada do gabinete-escola · sem juridiquês
            </p>
          </section>

          <Details />
        </main>

        <footer className="flex items-center justify-between border-t border-white/[0.06] py-3 text-[9px] uppercase tracking-[0.24em] text-parchment/25">
          <span>Mutação constitucional · explicação + prática</span>
          <span className="hidden sm:inline">Clique, leia, decida</span>
        </footer>
      </div>
    </div>
  );
}
