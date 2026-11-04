export function Scales({ className = '', stroke = 'currentColor' }) {
  return (
    <svg
      viewBox="0 0 240 260"
      fill="none"
      className={className}
      aria-hidden="true"
    >
      <path
        d="M120 24v192M96 222h48M78 232h84M120 40l-58 18M120 40l58 18"
        stroke={stroke}
        strokeWidth="3"
        strokeLinecap="round"
      />
      <path
        d="M62 58c0 22-14 34-32 34 18 0 32 12 32 34 0-22 14-34 32-34-18 0-32-12-32-34Z"
        fill={stroke}
        opacity=".18"
      />
      <path
        d="M178 58c0 22-14 34-32 34 18 0 32 12 32 34 0-22 14-34 32-34-18 0-32-12-32-34Z"
        fill={stroke}
        opacity=".18"
      />
      <path
        d="M18 96h88M134 96h88"
        stroke={stroke}
        strokeWidth="3"
        strokeLinecap="round"
      />
      <path
        d="M18 96c0 20 14 36 44 36s44-16 44-36M134 96c0 20 14 36 44 36s44-16 44-36"
        stroke={stroke}
        strokeWidth="3"
      />
      <circle cx="120" cy="24" r="7" stroke={stroke} strokeWidth="3" />
      <circle cx="120" cy="216" r="5" fill={stroke} />
    </svg>
  );
}

export function Seal({ className = '' }) {
  return (
    <svg viewBox="0 0 96 96" className={className} aria-hidden="true">
      <circle cx="48" cy="48" r="44" fill="none" stroke="currentColor" strokeWidth="1.5" opacity=".55" />
      <circle cx="48" cy="48" r="36" fill="none" stroke="currentColor" strokeWidth=".8" opacity=".4" />
      <path d="M48 22v52M31 31h34M26 39h18M52 39h18" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" opacity=".9" />
      <path d="M26 39c0 8-4 13-9 13s-9-5-9-13M70 39c0 8-4 13-9 13s-9-5-9-13" stroke="currentColor" strokeWidth="1.5" opacity=".9" />
      <path d="M39 74h18M43 80h10" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" opacity=".9" />
    </svg>
  );
}

export function Stars({ className = '' }) {
  return (
    <svg viewBox="0 0 400 400" className={className} aria-hidden="true">
      <defs>
        <radialGradient id="starGlow">
          <stop offset="0%" stopColor="currentColor" stopOpacity=".55" />
          <stop offset="100%" stopColor="currentColor" stopOpacity="0" />
        </radialGradient>
      </defs>
      <circle cx="200" cy="200" r="190" fill="url(#starGlow)" opacity=".2" />
      {Array.from({ length: 48 }).map((_, i) => {
        const angle = (i / 48) * Math.PI * 2;
        const radius = 120 + (i % 5) * 28;
        const x = 200 + Math.cos(angle) * radius;
        const y = 200 + Math.sin(angle) * radius;
        const r = i % 3 === 0 ? 2.2 : 1.2;
        return <circle key={i} cx={x} cy={y} r={r} fill="currentColor" opacity={0.25 + (i % 4) * 0.12} />;
      })}
    </svg>
  );
}

export function CornerMarks({ className = '' }) {
  return (
    <div className={`pointer-events-none absolute inset-0 ${className}`} aria-hidden="true">
      <span className="absolute left-0 top-0 h-8 w-8 border-l border-t border-gold/40" />
      <span className="absolute right-0 top-0 h-8 w-8 border-r border-t border-gold/40" />
      <span className="absolute bottom-0 left-0 h-8 w-8 border-b border-l border-gold/40" />
      <span className="absolute bottom-0 right-0 h-8 w-8 border-b border-r border-gold/40" />
    </div>
  );
}
