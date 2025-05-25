import { useAuthStore } from '~/stores/auth'

export default defineNuxtRouteMiddleware(async (to, from) => {
    // No hacer nada en el servidor (SSR)
    if (process.server) return

    const auth = useAuthStore()

    const publicPages = ['/login']
    if (publicPages.includes(to.path)) return

    // Asegurarse de inicializar el store y cargar token y usuario
    if (!auth.token) {
        await auth.init()
    }

    if (!auth.token) {
        return navigateTo('/login')
    }
})
