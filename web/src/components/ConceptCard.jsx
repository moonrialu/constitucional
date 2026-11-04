export default function ConceptCard({
  card,
  index,
  total,
  selected,
  disabled,
  onClick,
}) {
  const middle = (total - 1) / 2;
  const rotation = (index - middle) * 2.8;
  const lift = Math.abs(index - middle) * 4;

  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      data-selected={selected}
      aria-pressed={selected}
      className="card-fan group relative shrink-0 rounded-2xl text-left focus-visible:outline-none disabled:cursor-default"
      style={{
        transform: `rotate(${rotation}deg) translateY(${lift}px)`,
        zIndex: selected ? 50 : 10 + index,
      }}
    >
      <div
        className={`card-shine relative flex h-[192px] w-[142px] flex-col overflow-hidden rounded-2xl border bg-gradient-to-br p-3 shadow-card transition-colors sm:h-[208px] sm:w-[158px] ${card.surface} ${
          selected
            ? 'border-gold ring-2 ring-gold/70'
            : 'border-white/15 group-hover:border-white/35'
        }`}
        style={{
          boxShadow: selected
            ? `0 26px 60px -18px ${card.accent}66, 0 0 0 1px ${card.accent}88`
            : undefined,
        }}
      >
        <div className="flex items-center justify-between text-[7px] font-bold uppercase tracking-[0.22em] text-parchment/35">
          <span>Carta de conceito</span>
          <span className="tabular-nums">{String(index + 1).padStart(2, '0')}</span>
        </div>

        <div className="mt-2 flex items-start justify-between">
          <span
            className="font-serif text-[2.35rem] leading-none"
            style={{ color: card.accent }}
          >
            {card.symbol}
          </span>
          <span
            className="grid h-8 w-8 place-items-center rounded-full border text-[7px] font-extrabold uppercase tracking-[0.08em]"
            style={{
              borderColor: `${card.accent}55`,
              color: card.accent,
              background: `${card.accent}12`,
            }}
          >
            STF
          </span>
        </div>

        <h3 className="mt-2 font-display text-[13px] font-extrabold leading-[1.15] tracking-tight text-parchment sm:text-sm">
          {card.title}
        </h3>
        <p className="mt-1 text-[8px] font-semibold uppercase leading-snug tracking-[0.12em] text-parchment/45">
          {card.subtitle}
        </p>

        <div className="mt-auto border-t border-white/10 pt-2">
          <p className="line-clamp-3 text-[8.5px] leading-[1.45] text-parchment/55">
            {card.note}
          </p>
        </div>

        <span
          className="pointer-events-none absolute inset-x-0 bottom-0 h-1"
          style={{ background: `linear-gradient(90deg, transparent, ${card.accent}, transparent)` }}
        />

        {selected && (
          <span className="absolute right-2 top-2 grid h-6 w-6 place-items-center rounded-full bg-gold text-ink shadow-lg">
            <svg viewBox="0 0 24 24" className="h-3.5 w-3.5" fill="none" stroke="currentColor" strokeWidth="3">
              <path d="M5 12.5l4.5 4.5L20 6.5" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
          </span>
        )}
      </div>
    </button>
  );
}
