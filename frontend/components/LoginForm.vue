<template>
  <div class="auth-page">
    <div class="auth-container">
      <div class="tabs" role="tablist" aria-label="Autenticación">
        <button
          :class="{ active: activeTab === 'login' }"
          @click="activeTab = 'login'"
          :aria-selected="activeTab === 'login'"
          role="tab"
          id="tab-login"
          aria-controls="panel-login"
          tabindex="0"
        >
          Iniciar Sesión
        </button>
        <button
          :class="{ active: activeTab === 'register' }"
          @click="activeTab = 'register'"
          :aria-selected="activeTab === 'register'"
          role="tab"
          id="tab-register"
          aria-controls="panel-register"
          tabindex="-1"
        >
          Registro Socio
        </button>
      </div>

      <div class="panels-wrapper" :class="activeTab">
        <section
          v-show="activeTab === 'login'"
          id="panel-login"
          role="tabpanel"
          aria-labelledby="tab-login"
          tabindex="0"
          class="tab-panel login-panel"
        >
          <form @submit.prevent="handleLogin" novalidate>
            <div class="input-group">
              <label for="login-email">Correo Electrónico</label>
              <input
                type="email"
                id="login-email"
                v-model="email"
                placeholder="tu@email.com"
                required
                autocomplete="username"
              />
            </div>

            <div class="input-group">
              <label for="login-password">Contraseña</label>
              <input
                type="password"
                id="login-password"
                v-model="password"
                placeholder="••••••••"
                required
                autocomplete="current-password"
              />
            </div>

            <button type="submit" :disabled="loading" aria-live="polite" aria-busy="loading">
              <span v-if="loading" class="loader"></span>
              <span v-else>Ingresar</span>
            </button>
            <p v-if="error" class="error">{{ error }}</p>
          </form>
        </section>

        <section
          v-show="activeTab === 'register'"
          id="panel-register"
          role="tabpanel"
          aria-labelledby="tab-register"
          tabindex="0"
          class="tab-panel register-panel"
        >
          <form @submit.prevent="handleRegister" novalidate>
            <div class="input-group">
              <label for="reg-name">Nombre Completo</label>
              <input
                type="text"
                id="reg-name"
                v-model="regName"
                placeholder="Tu nombre completo"
                required
                autocomplete="name"
              />
            </div>

            <div class="input-group">
              <label for="reg-email">Correo Electrónico</label>
              <input
                type="email"
                id="reg-email"
                v-model="regEmail"
                placeholder="tu@email.com"
                required
                autocomplete="email"
              />
            </div>

            <div class="input-group">
              <label for="reg-password">Contraseña</label>
              <input
                type="password"
                id="reg-password"
                v-model="regPassword"
                placeholder="••••••••"
                required
                autocomplete="new-password"
                minlength="6"
              />
            </div>

            <button type="submit" :disabled="loadingRegister" aria-live="polite" aria-busy="loadingRegister">
              <span v-if="loadingRegister" class="loader"></span>
              <span v-else>Registrarme</span>
            </button>
            <p v-if="errorRegister" class="error">{{ errorRegister }}</p>
          </form>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '~/stores/auth'

const activeTab = ref('login')
const auth = useAuthStore()
const router = useRouter()

// Login
const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

// Registro
const regName = ref('')
const regEmail = ref('')
const regPassword = ref('')
const errorRegister = ref('')
const loadingRegister = ref(false)

watch(activeTab, () => {
  error.value = ''
  errorRegister.value = ''
})

async function handleLogin() {
  error.value = ''
  loading.value = true
  try {
    await auth.login(email.value, password.value)
    await router.push('/dashboard')
  } catch (err) {
    error.value = 'Credenciales incorrectas'
  } finally {
    loading.value = false
  }
}

async function handleRegister() {
  errorRegister.value = ''
  loadingRegister.value = true
  try {
    await auth.register({
      name: regName.value,
      email: regEmail.value,
      password: regPassword.value
    })
    await router.push('/dashboard')
  } catch (err) {
    errorRegister.value = 'Error en el registro. Inténtalo de nuevo.'
  } finally {
    loadingRegister.value = false
  }
}
</script>

<style lang="scss" scoped>
/* Mantener los mismos estilos */
$blue-light: #a3c4f3;
$blue-medium: #466bb0;
$blue-dark: #1f2a4d;
$blue-darker: #121c2a;
$blue-accent: #5a7bd8;
$background: $blue-darker;
$text-light: #e1e9f0;
$text-muted: #9ab1d6;

.auth-page {
  min-height: 100vh;
  background: linear-gradient(135deg, $blue-dark, $blue-darker);
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1rem;
  font-family: 'Poppins', sans-serif;
  color: $text-light;
  width: 100%;
}

.auth-container {
  background: $background;
  padding: 2rem 2.5rem;
  border-radius: 15px;
  width: 100%;
  max-width: 420px;
  box-shadow: 0 0 25px rgba(26, 41, 82, 0.9);
  user-select: none;
  perspective: 1500px;

  .tabs {
    display: flex;
    margin-bottom: 2rem;
    border-bottom: 2px solid $blue-medium;
    user-select: none;

    button {
      flex: 1;
      background: transparent;
      border: none;
      padding: 0.75rem 0;
      font-weight: 600;
      font-size: 1.2rem;
      color: $text-muted;
      cursor: pointer;
      border-bottom: 4px solid transparent;
      transition: color 0.3s, border-color 0.3s;

      &.active {
        color: $blue-light;
        border-color: $blue-accent;
        font-weight: 700;
      }

      &:focus {
        outline: none;
        color: $blue-light;
        border-color: $blue-accent;
      }

      &:hover:not(.active) {
        color: $blue-light;
      }
    }
  }

  .panels-wrapper {
    position: relative;
    height: 320px;
    transform-style: preserve-3d;
    transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
    
    &.login {
      transform: rotateY(0deg);
    }
    
    &.register {
      transform: rotateY(180deg);
    }

    .tab-panel {
      position: absolute;
      width: 100%;
      backface-visibility: hidden;
      top: 0;
      left: 0;
      outline: none;

      form {
        .input-group {
          margin-bottom: 1.4rem;
        display: grid;
          label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: $text-muted;
          }

          input {
            padding: 0.7rem 1rem;
            border-radius: 8px;
            border: 1.5px solid transparent;
            background-color: lighten($background, 5%);
            color: $text-light;
            font-size: 1rem;
            transition: border-color 0.25s ease;

            &::placeholder {
              color: lighten($text-muted, 30%);
            }

            &:focus {
              outline: none;
              border-color: $blue-accent;
              background-color: darken(lighten($background, 5%), 5%);
              box-shadow: 0 0 10px $blue-accent;
            }
          }
        }

        button {
          width: 100%;
          padding: 0.85rem 0;
          background: $blue-accent;
          color: #fff;
          font-weight: 700;
          font-size: 1.1rem;
          border: none;
          border-radius: 12px;
          cursor: pointer;
          transition: background 0.3s ease;

          &:hover:not(:disabled) {
            background: lighten($blue-accent, 10%);
          }

          &:disabled {
            background: darken($blue-accent, 20%);
            cursor: not-allowed;
          }

          .loader {
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top: 3px solid #fff;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            animation: spin 0.8s linear infinite;
            display: inline-block;
            vertical-align: middle;
            margin-right: 0.5rem;
          }
        }
      }
    }

    .login-panel {
      transform: rotateY(0deg);
    }

    .register-panel {
      transform: rotateY(180deg);
    }
  }
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.error {
  color: #ff6b6b;
  text-align: center;
  margin-top: 1rem;
  font-size: 0.9rem;
}
</style>