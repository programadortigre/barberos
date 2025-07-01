// stores/auth.ts (o donde sea tu store)
import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const token = ref(null)

  const init = async () => {
    token.value = localStorage.getItem('token') || null
    if (token.value) {
      try {
        const data = await $fetch('/perfil', {
          headers: { Authorization: `Bearer ${token.value}` }
        })
        user.value = data
      } catch {
        logout()
      }
    }
  }

  const login = async (credenciales) => {
    try {
      const data = await $fetch('/login', {
        method: 'POST',
        body: credenciales,
      })
      token.value = data.access_token
      localStorage.setItem('token', token.value)
      await init()
      return true
    } catch (e) {
      console.error('Login fallido', e)
      logout()
      return false
    }
  }

  const logout = () => {
    token.value = null
    user.value = null
    if (process.client) {
      localStorage.removeItem('token')
    }
  }

  return {
    user,
    token,
    login,
    logout,
    init
  }
})
