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
                v-model="username"
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
                v-model="loginPassword"
                placeholder="••••••••"
                required
                autocomplete="current-password"
              />
            </div>

            <button type="submit" :disabled="loading" aria-live="polite" aria-busy="loadingLogin">
              <span v-if="loadingLogin" class="loader"></span>
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
          </form>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const activeTab = ref('login')

// Login data
const loginEmail = ref('')
const loginPassword = ref('')
const loadingLogin = ref(false)

// Register data
const regName = ref('')
const regEmail = ref('')
const regPassword = ref('')
const loadingRegister = ref(false)

const handleLogin = async () => {
  loadingLogin.value = true
  try {
    const res = await fetch('http://localhost:8000/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: loginEmail.value,
        password: loginPassword.value,
      }),
    })

    if (!res.ok) {
      const errorData = await res.json()
      throw new Error(errorData.detail || 'Error en login')
    }

    const data = await res.json()
    localStorage.setItem('access_token', data.access_token)
    alert('Login exitoso!')
  } catch (error) {
    alert('Error: ' + error.message)
  } finally {
    loadingLogin.value = false
  }
}

const handleRegister = () => {
  loadingRegister.value = true
  setTimeout(() => {
    alert(
      `Registro:\nNombre: ${regName.value}\nEmail: ${regEmail.value}\nPassword: ${regPassword.value}`
    )
    loadingRegister.value = false
  }, 1500)
}
</script>

<style lang="scss" scoped>
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
</style>
