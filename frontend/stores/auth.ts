import { ref } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(null)
  const user = ref<any>(null)
  const config = useRuntimeConfig()

  // Solo en cliente: cargar token desde localStorage
  if (process.client) {
    token.value = localStorage.getItem('token')
  }

  const login = async (username: string, password: string) => {
    const { data, error } = await useFetch('/login', {
      baseURL: config.public.apiBaseUrl,
      method: 'POST',
      body: { username, password }
    })

    if (error.value) throw error.value

    token.value = data.value.access_token
    if (process.client) {
      localStorage.setItem('token', token.value)
    }

    await getUser()
  }

  const getUser = async () => {
    const { data, error } = await useFetch('/usuarios/me', {
      baseURL: config.public.apiBaseUrl,
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
    if (process.client) {
      localStorage.removeItem('token')
    }
  }

  const init = async () => {
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
