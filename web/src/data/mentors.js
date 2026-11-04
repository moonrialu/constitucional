// Fotos dos mentores em public/fotos/[nome]pixel.jpg.
// O recorte da cabeça é feito por CSS em MentorAvatar (object-cover +
// object-position + transform), sem alterar os arquivos originais.
export const MENTOR_PHOTOS = {
  amanda: '/fotos/amandapixel.jpg',
  ian: '/fotos/ianpixel.jpg',
  gabriel: '/fotos/gabrielpixel.jpg',
  luiza: '/fotos/luizapixel.jpg',
  rafael: '/fotos/rafaelpixel.jpg',
  paola: '/fotos/paolapixel.jpg',
};

export const MENTOR_PLACEHOLDERS = {
  amanda: '/mentors/link_da_foto_da_amanda.jpg',
  ian: '/mentors/link_da_foto_do_ian.jpg',
  gabriel: '/mentors/link_da_foto_do_gabriel.jpg',
  luiza: '/mentors/link_da_foto_da_luiza.jpg',
  rafael: '/mentors/link_da_foto_do_rafael.jpg',
  paola: '/mentors/link_da_foto_da_paola.jpg',
};

export const DEFAULT_CROP = {
  x: '50%',
  y: '8%',
  zoom: 1,
};

export const MENTORS = [
  {
    id: 'amanda',
    name: 'Amanda',
    initials: 'AM',
    role: 'Coordenação do gabinete',
    trait: 'organiza o raciocínio',
    color: '#7b5aa6',
    glow: 'rgba(123, 90, 166, 0.45)',
    avatar: MENTOR_PHOTOS.amanda,
    placeholder: MENTOR_PLACEHOLDERS.amanda,
    crop: { x: '50%', y: '8%', zoom: 1 },
  },
  {
    id: 'ian',
    name: 'Ian',
    initials: 'IA',
    role: 'Constitucionalista',
    trait: 'preciso e direto',
    color: '#b85c7a',
    glow: 'rgba(184, 92, 122, 0.45)',
    avatar: MENTOR_PHOTOS.ian,
    placeholder: MENTOR_PLACEHOLDERS.ian,
    crop: { x: '50%', y: '8%', zoom: 1 },
  },
  {
    id: 'gabriel',
    name: 'Gabriel',
    initials: 'GA',
    role: 'Jurisprudência',
    trait: 'explica com exemplos',
    color: '#4c6fa8',
    glow: 'rgba(76, 111, 168, 0.45)',
    avatar: MENTOR_PHOTOS.gabriel,
    placeholder: MENTOR_PLACEHOLDERS.gabriel,
    crop: { x: '50%', y: '8%', zoom: 1 },
  },
  {
    id: 'luiza',
    name: 'Luiza',
    initials: 'LU',
    role: 'Didática e mnemônicos',
    trait: 'transforma teoria em imagem',
    color: '#b8862f',
    glow: 'rgba(184, 134, 47, 0.45)',
    avatar: MENTOR_PHOTOS.luiza,
    placeholder: MENTOR_PLACEHOLDERS.luiza,
    crop: { x: '50%', y: '8%', zoom: 1 },
  },
  {
    id: 'rafael',
    name: 'Rafael',
    initials: 'RA',
    role: 'Precedentes',
    trait: 'conecta os casos reais',
    color: '#3f8a5f',
    glow: 'rgba(63, 138, 95, 0.45)',
    avatar: MENTOR_PHOTOS.rafael,
    placeholder: MENTOR_PLACEHOLDERS.rafael,
    crop: { x: '50%', y: '8%', zoom: 1 },
  },
  {
    id: 'paola',
    name: 'Paola',
    initials: 'PA',
    role: 'Revisão crítica',
    trait: 'faz as perguntas difíceis',
    color: '#a53d4c',
    glow: 'rgba(165, 61, 76, 0.45)',
    avatar: MENTOR_PHOTOS.paola,
    placeholder: MENTOR_PLACEHOLDERS.paola,
    crop: { x: '50%', y: '8%', zoom: 1 },
  },
];

export function normalizeMentorId(value = '') {
  return String(value)
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');
}

export const mentorById = (id) =>
  MENTORS.find((mentor) => mentor.id === normalizeMentorId(id));

export const mentorByName = (value) => {
  const key = normalizeMentorId(value);
  return (
    MENTORS.find(
      (mentor) =>
        mentor.id === key || normalizeMentorId(mentor.name) === key,
    ) || null
  );
};
