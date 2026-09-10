/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        accent: {
          DEFAULT: '#F58220',
          50: '#FFF4E8',
          100: '#FFE6CF',
          200: '#FFCD9F',
          300: '#FFB570',
          400: '#FD9C40',
          500: '#F58220',
          600: '#D96A14',
          700: '#B05212',
          800: '#823D14',
          900: '#5C2C10',
        },
        navy: {
          DEFAULT: '#0B1235',
          50: '#E8EAF2',
          100: '#C6CCDF',
          200: '#94A0C2',
          300: '#6275A5',
          400: '#3A4D80',
          500: '#1B2A5C',
          600: '#0B1235',
          700: '#080E2A',
          800: '#060A20',
          900: '#040718',
        },
        charcoal: {
          DEFAULT: '#1A1A1A',
          light: '#2B2B2B',
          muted: '#6B6B6B',
        },
        ink: {
          DEFAULT: '#0B1235',
        },
        cream: '#FAF8F5',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
      },
      maxWidth: {
        container: '1440px',
      },
      borderRadius: {
        'sm-2': '6px',
      },
      boxShadow: {
        card: '0 1px 3px rgba(11,18,53,0.06), 0 1px 2px rgba(11,18,53,0.04)',
        'card-hover': '0 12px 30px -10px rgba(11,18,53,0.18)',
        nav: '0 2px 12px rgba(11,18,53,0.08)',
      },
      keyframes: {
        marquee: {
          '0%': { transform: 'translateX(0)' },
          '100%': { transform: 'translateX(-50%)' },
        },
        fadeIn: {
          from: { opacity: '0', transform: 'translateY(6px)' },
          to: { opacity: '1', transform: 'translateY(0)' },
        },
        slideIn: {
          from: { transform: 'translateX(100%)' },
          to: { transform: 'translateX(0)' },
        },
        slideUp: {
          from: { transform: 'translateY(100%)' },
          to: { transform: 'translateY(0)' },
        },
        shimmer: {
          '100%': { transform: 'translateX(100%)' },
        },
        scaleIn: {
          from: { opacity: '0', transform: 'scale(0.96)' },
          to: { opacity: '1', transform: 'scale(1)' },
        },
      },
      animation: {
        marquee: 'marquee 30s linear infinite',
        fadeIn: 'fadeIn 0.4s ease-out',
        slideIn: 'slideIn 0.3s ease-out',
        slideUp: 'slideUp 0.3s ease-out',
        scaleIn: 'scaleIn 0.2s ease-out',
        shimmer: 'shimmer 1.5s infinite',
      },
    },
  },
  plugins: [],
};
