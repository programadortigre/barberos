export default defineNuxtConfig({
  ssr: true, // Habilita el rendering del lado del servidor (SSR)
  build: {
    transpile: ['@nuxtjs/axios'], // Si usas axios o librerías adicionales
  },
  axios: {
    baseURL: 'http://localhost:8000', // URL de la API FastAPI
  }
})
