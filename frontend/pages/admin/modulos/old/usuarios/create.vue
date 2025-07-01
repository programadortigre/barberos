<template>
  <section class="usuario-create">
    <h1>Crear Usuario</h1>
    <form @submit.prevent="crearUsuario">
      <label>
        Username:
        <input v-model="username" required />
      </label>
      <label>
        Password:
        <input type="password" v-model="password" required />
      </label>
      <label>
        Rol:
        <select v-model="rolId" required>
          <option v-for="rol in roles" :key="rol.id" :value="rol.id">{{ rol.nombre }}</option>
        </select>
      </label>

      <button type="submit" :disabled="loading">Crear</button>
      <button type="button" @click="$router.push('/usuarios')">Cancelar</button>

      <div v-if="error" class="error">{{ error }}</div>
    </form>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRuntimeConfig } from '#app'

const config = useRuntimeConfig()

const username = ref('')
const password = ref('')
const rolId = ref<number | null>(null)
const roles = ref<{id: number, nombre: string}[]>([])
const loading = ref(false)
const error = ref<string | null>(null)

async function fetchRoles() {
  try {
    const res = await fetch(`${config.public.apiBaseUrl}/roles`)
    if (!res.ok) throw new Error('Error al cargar roles')
    roles.value = await res.json()
  } catch (err: any) {
    error.value = err.message || 'Error desconocido'
  }
}

async function crearUsuario() {
  loading.value = true
  error.value = null
  try {
    const res = await fetch(`${config.public.apiBaseUrl}/usuarios`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: username.value,
        password: password.value,
        rol_id: rolId.value
      })
    })
    if (!res.ok) throw new Error('Error al crear usuario')
    // Redirigir al listado
    window.location.href = '/usuarios'
  } catch (err: any) {
    error.value = err.message || 'Error desconocido'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRoles()
})
</script>

<style scoped>
.usuario-create {
  max-width: 400px;
  margin: auto;
}
label {
  display: block;
  margin-bottom: 1rem;
}
.error {
  color: red;
  margin-top: 1rem;
}
</style>
