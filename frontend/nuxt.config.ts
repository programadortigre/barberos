export default defineNuxtConfig({
  css: ['@/assets/styles/main.scss'],
  runtimeConfig: {
    public: {
      apiBaseUrl: process.env.API_BASE || 'http://localhost:8000',
    }
  },
  modules: [
    '@pinia/nuxt',
    '@nuxtjs/color-mode',
    //'@primevue/nuxt-module'
  ],
  colorMode: {
    classSuffix: '',
    preference: 'light',
    fallback: 'light'
  },
  pinia: {
    autoImports: [
      'defineStore',
      ['defineStore', 'definePiniaStore']
    ]
  },
  nitro: {
    devProxy: {
      '/api': {
        target: process.env.API_BASE || 'http://localhost:8000',
        changeOrigin: true,
        prependPath: true
      }
    }
  },


})
