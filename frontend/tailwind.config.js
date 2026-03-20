/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      fontFamily: {
        sans: [
          "Segoe UI",
          "Helvetica Neue",
          "Helvetica",
          "Arial",
          "sans-serif",
        ],
      },
      colors: {
        fb: {
          blue: "#0866FF",
          "blue-hover": "#0756d6",
          "blue-light": "#E7F3FF",
          dark: "#1C1E21",
          "dark-card": "#242526",
          "dark-hover": "#3A3B3C",
          "dark-input": "#3A3B3C",
          "dark-border": "#3E4042",
          "dark-text": "#E4E6EB",
          "dark-secondary": "#B0B3B8",
          green: "#31A24C",
          red: "#FA3E3E",
          messenger: "#0084FF",
          "messenger-gradient-start": "#00C6FF",
          "messenger-gradient-end": "#0078FF",
        },
      },
      fontSize: {
        "2xs": ["0.6875rem", { lineHeight: "1rem" }],
      },
    },
  },
  plugins: [],
};
