import { ref } from 'vue'

export const useAuthStore = defineStore('auth', () => {
    const token = ref<string | null>(null)
    const user = ref<any>(null)

    // Cargar token desde localStorage solo en cliente
    if (process.client) {
        token.value = localStorage.getItem('token')
    }

    const login = async (username: string, password: string) => {
        const config = useRuntimeConfig()
        const { data, error } = await useFetch(`${config.public.apiBaseUrl}/login`, {
            method: 'POST',
            body: { username, password }
        })

        if (error.value) throw error.value

        token.value = data.value.access_token
        localStorage.setItem('token', token.value)

        await getUser()
    }

    const getUser = async () => {
        const config = useRuntimeConfig()
        const { data, error } = await useFetch(`${config.public.apiBaseUrl}/usuarios/me`, {
            headers: {
                Authorization: `Bearer ${token.value}`
            }
        })

        if (error.value) throw error.value

        user.value = data.value
    }

    const logout = () => {
        token.value = null
        user.value = null
        localStorage.removeItem('token')
    }

    const init = async () => {
        // En cliente, intentar cargar token de localStorage si no está cargado aún
        if (process.client && !token.value) {
            token.value = localStorage.getItem('token')
        }

        if (token.value) {
            try {
                await getUser()
            } catch (err) {
                logout()
            }
        }
    }

    return { token, user, login, logout, init }
})
