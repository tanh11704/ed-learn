/** @type {import('tailwindcss').Config} */
export default {
  darkMode: ["class"],
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        inter: ["Inter", "sans-serif"],
      },
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
        border: "var(--border)",
        card: {
          DEFAULT: "var(--card)",
          foreground: "var(--card-foreground)",
        },
        muted: {
          DEFAULT: "var(--muted)",
          foreground: "var(--muted-foreground)",
        },
        primary: {
          DEFAULT: "var(--primary)",
          foreground: "var(--primary-foreground)",
        },
        "primary-subtle": "var(--primary-subtle)",
        success: "var(--success)",
        warning: "var(--warning)",
        danger: "var(--danger)",
        sidebar: {
          DEFAULT: "var(--sidebar-bg)",
          border: "var(--sidebar-border)",
          hover: "var(--sidebar-hover)",
          muted: "var(--sidebar-text-muted)",
        },
      },
      boxShadow: {
        brand: "0 0 15px rgba(24, 144, 255, 0.35)",
      },
    },
  },
  plugins: [],
};
