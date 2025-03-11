import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"
import path from "path"

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    // Optimize build for performance
    target: "esnext",
    minify: "terser",
    terserOptions: {
      compress: {
        drop_console: false, // Keep console logs for performance monitoring
        pure_funcs: ["console.info", "console.debug", "console.trace"],
      },
    },
    rollupOptions: {
      output: {
        manualChunks: {
          "react-vendor": ["react", "react-dom", "react-router-dom"],
          "chart-vendor": ["chart.js"],
          "animation-vendor": ["framer-motion"],
        },
      },
    },
  },
  server: {
    // Configure dev server
    host: true,
    port: 3000,
  },
})

