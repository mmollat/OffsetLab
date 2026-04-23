import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        background: '#09090b',
        surface: '#111217',
        surface2: '#171923',
        accent: '#3b82f6',
        accent2: '#ef4444',
        border: '#272a36',
        muted: '#9ca3af',
      },
      boxShadow: {
        soft: '0 10px 30px rgba(0,0,0,0.28)',
      },
    },
  },
  plugins: [],
};

export default config;
