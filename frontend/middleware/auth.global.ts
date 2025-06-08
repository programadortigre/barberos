// middleware/auth.global.ts
import { useAuthStore } from '~/stores/auth'

export default defineNuxtRouteMiddleware(async (to) => {
  // Solo ejecuta en el cliente
  if (process.server) return

  const auth = useAuthStore()

  const publicPages = ['/login']
  const isPublic = publicPages.includes(to.path)

  // Cargar desde localStorage si es necesario
  if (!auth.token) {
    await auth.init()
  }

  if (!auth.token && !isPublic) {
    return navigateTo('/login')
  }

  // Si ya está logueado y va al login, redirigir al home (opcional)
  if (auth.token && to.path === '/login') {
    return navigateTo('/')
  }
})
