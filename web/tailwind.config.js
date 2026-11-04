/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        ink: '#06151f',
        midnight: '#081e2b',
        navy: '#0a2637',
        steel: '#12384c',
        parchment: '#f4ede0',
        sand: '#e7dcc8',
        gold: '#d8b56a',
        'gold-soft': '#f0dfb8',
        'gold-deep': '#9f7a35',
        teal: '#63c7b8',
        'teal-deep': '#1d7d74',
        wine: '#7d2e46',
        rose: '#d97c92',
      },
      fontFamily: {
        display: ['Sora', 'system-ui', 'sans-serif'],
        body: ['Inter', 'system-ui', 'sans-serif'],
        serif: ['"Cormorant Garamond"', 'Georgia', 'serif'],
      },
      boxShadow: {
        stage: '0 40px 120px -30px rgba(0, 0, 0, 0.75)',
        card: '0 24px 60px -18px rgba(0, 0, 0, 0.65)',
        glow: '0 0 60px rgba(216, 181, 106, 0.18)',
        'inner-line': 'inset 0 1px 0 rgba(255, 255, 255, 0.08)',
      },
      backgroundImage: {
        'stage-radial':
          'radial-gradient(ellipse at 50% 0%, rgba(99, 199, 184, 0.16), transparent 58%), radial-gradient(ellipse at 12% 82%, rgba(216, 181, 106, 0.14), transparent 46%), linear-gradient(160deg, #0b2b3d 0%, #071a26 48%, #04121a 100%)',
        'table-radial':
          'radial-gradient(ellipse at 50% 38%, rgba(216, 181, 106, 0.12), transparent 55%), radial-gradient(ellipse at 50% 110%, rgba(99, 199, 184, 0.12), transparent 48%), linear-gradient(180deg, #0a2332 0%, #061722 62%, #041019 100%)',
        'paper':
          'linear-gradient(135deg, rgba(255,255,255,0.98), rgba(244,237,224,0.96))',
        'gold-line':
          'linear-gradient(90deg, transparent, rgba(216,181,106,0.75), transparent)',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        bobble: {
          '0%, 100%': { transform: 'rotate(-1.5deg) translateY(0)' },
          '50%': { transform: 'rotate(1.5deg) translateY(-5px)' },
        },
        rise: {
          '0%': { opacity: '0', transform: 'translateY(18px) scale(0.985)' },
          '100%': { opacity: '1', transform: 'translateY(0) scale(1)' },
        },
        fade: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
        pulseGlow: {
          '0%, 100%': { boxShadow: '0 0 0 0 rgba(216,181,106,0.32)' },
          '50%': { boxShadow: '0 0 0 14px rgba(216,181,106,0)' },
        },
      },
      animation: {
        float: 'float 7s ease-in-out infinite',
        bobble: 'bobble 2.6s ease-in-out infinite',
        rise: 'rise 500ms cubic-bezier(.22,.8,.3,1) both',
        fade: 'fade 400ms ease both',
        shimmer: 'shimmer 3.4s linear infinite',
        'pulse-glow': 'pulseGlow 2.2s ease-in-out infinite',
      },
    },
  },
  plugins: [],
};
