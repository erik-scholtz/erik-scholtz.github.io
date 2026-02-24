import { defineConfig } from "@solidjs/start/config";

export default defineConfig({
  ssr: false,
  server: {
    // For github pages, site is served at root
    baseURL: "/",
    prerender: {
      routes: ["/", "/about"],
    },
  },
});
