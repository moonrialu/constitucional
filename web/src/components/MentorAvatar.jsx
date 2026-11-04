import { useEffect, useMemo, useState } from 'react';
import { DEFAULT_CROP, mentorById } from '../data/mentors';

const SIZES = {
  xs: {
    frame: 'h-16 w-12',
    head: 'h-10 w-10',
    body: 'h-6 w-8',
    neck: 'h-2 w-3',
    ring: 'border',
    name: 'text-[9px]',
  },
  sm: {
    frame: 'h-24 w-16',
    head: 'h-14 w-14',
    body: 'h-9 w-11',
    neck: 'h-2 w-3.5',
    ring: 'border',
    name: 'text-[10px]',
  },
  md: {
    frame: 'h-32 w-24',
    head: 'h-20 w-20',
    body: 'h-12 w-16',
    neck: 'h-2.5 w-4',
    ring: 'border-2',
    name: 'text-xs',
  },
  lg: {
    frame: 'h-44 w-32',
    head: 'h-28 w-28',
    body: 'h-16 w-20',
    neck: 'h-3 w-5',
    ring: 'border-2',
    name: 'text-sm',
  },
  xl: {
    frame: 'h-64 w-48',
    head: 'h-40 w-40',
    body: 'h-24 w-[7.5rem]',
    neck: 'h-4 w-6',
    ring: 'border-[3px]',
    name: 'text-base',
  },
};

export default function MentorAvatar({
  id,
  size = 'md',
  showName = false,
  showRole = false,
  speaking = false,
  muted = false,
  headOnly = false,
  className = '',
}) {
  const mentor = useMemo(() => mentorById(id), [id]);
  const [source, setSource] = useState(mentor?.avatar || mentor?.photo || '');
  const [failed, setFailed] = useState(false);
  const [loaded, setLoaded] = useState(false);
  const s = SIZES[size] || SIZES.md;
  const crop = mentor?.crop || DEFAULT_CROP;

  useEffect(() => {
    setSource(mentor?.avatar || mentor?.photo || '');
    setLoaded(false);
    setFailed(false);
  }, [mentor?.id, mentor?.avatar, mentor?.photo]);

  if (!mentor) return null;

  function handleError() {
    if (mentor.placeholder && source !== mentor.placeholder) {
      setSource(mentor.placeholder);
      setLoaded(false);
      return;
    }
    setFailed(true);
  }

  return (
    <div
      className={`mentor-card relative flex flex-col items-center ${muted ? 'opacity-45 saturate-50' : ''} ${className}`}
    >
      <div className={`relative ${headOnly ? s.head : s.frame} flex flex-col items-center justify-center`}>
        <div
          data-avatar-head
          className={`relative z-10 overflow-hidden rounded-full ${s.head} ${s.ring} border-white/80 bg-[#1b2c35] shadow-[0_18px_30px_-14px_rgba(0,0,0,0.8)] ${speaking ? 'animate-bobble' : ''}`}
          style={{
            boxShadow: `0 8px 18px -12px rgba(0,0,0,.55), 0 0 0 5px ${mentor.glow}`,
          }}
        >
          <div
            className="absolute inset-0 flex items-center justify-center"
            style={{
              background: `radial-gradient(circle at 35% 20%, ${mentor.color}, #122833 72%)`,
            }}
          >
            <span className="font-display text-lg font-extrabold tracking-[0.08em] text-white/75">
              {mentor.initials}
            </span>
          </div>

          {!failed && source && (
            <img
              src={source}
              alt={mentor.name}
              referrerPolicy="no-referrer"
              className={`relative h-full w-full object-cover transition-opacity duration-300 ${loaded ? 'opacity-100' : 'opacity-0'}`}
              style={{
                objectPosition: `${crop.x} ${crop.y}`,
                transform: `scale(${crop.zoom})`,
                transformOrigin: `${crop.x} ${crop.y}`,
                imageRendering: 'pixelated',
              }}
              onLoad={() => setLoaded(true)}
              onError={handleError}
              draggable="false"
            />
          )}

          <span className="pointer-events-none absolute inset-0 rounded-full bg-gradient-to-b from-white/15 via-transparent to-black/35" />
        </div>

        <div
          data-avatar-body
          className={`relative z-0 -mt-1 ${s.body} overflow-hidden rounded-t-[48%] ${headOnly ? 'hidden' : ''}`}
          style={{
            background: `linear-gradient(150deg, ${mentor.color} 0%, rgba(8,30,43,0.95) 115%)`,
            boxShadow: `0 -10px 30px -12px ${mentor.glow}`,
          }}
        >
          <span className="absolute left-1/2 top-0 h-full w-3 -translate-x-1/2 bg-white/10" />
          <span className="absolute left-1/2 top-1 h-2.5 w-2.5 -translate-x-1/2 rotate-45 border border-white/30 bg-white/10" />
          <span className="absolute bottom-0 left-1/2 h-2 w-8 -translate-x-1/2 rounded-t-full bg-black/20" />
        </div>

        <div
          className={`absolute left-1/2 top-[38%] h-1.5 w-8 -translate-x-1/2 rounded-full bg-black/20 blur-sm ${headOnly ? 'hidden' : ''}`}
          aria-hidden="true"
        />
      </div>

      {(showName || showRole) && (
        <div className="mt-2 text-center">
          {showName && (
            <p
              className={`font-display font-bold tracking-wide text-parchment ${s.name}`}
            >
              {mentor.name}
            </p>
          )}
          {showRole && (
            <p className="mt-0.5 max-w-[11rem] text-[9px] uppercase tracking-[0.16em] text-parchment/45">
              {mentor.role}
            </p>
          )}
        </div>
      )}
    </div>
  );
}
