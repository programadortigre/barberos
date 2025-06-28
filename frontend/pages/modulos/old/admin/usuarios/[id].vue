<template>
  <section class="usuario-edit">
    <h1>Editar Usuario</h1>
    <form v-if="usuario" @submit.prevent="actualizarUsuario">
      <label>
        Username:
        <input v-model="usuario.username" disabled />
      </label>
      <label>
        Rol:
        <select v-model="usuario.rol_id" required>
          <option v-for="rol in roles" :key="rol.id" :value="rol.id">{{ rol.nombre }}</option>
        </select>
      </label>

      <button type="submit" :disabled="loading">Actualizar</button>
      <button type="button" @click="$router.push('/usuarios')">Cancelar</button>

      <div v-if="error" class="error">{{ error }}</div>
    </form>

    <div v-else>Cargando usuario...</div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRuntimeConfig } from '#app'

const config = useRuntimeConfig()
const route = useRoute()
const router = useRouter()

const usuario = ref<any>(null)
const roles = ref<{id: number, nombre: string}[]>([])
const loading = ref(false)
const error = ref<string | null>(null)

async function fetchUsuario() {
  try {
    const res = await fetch(`${config.public.apiBaseUrl}/usuarios/${route.params.id}`)
    if (!res.ok) throw new Error('Error al cargar usuario')
    usuario.value = await res.json()
  } catch (err: any) {
    error.value = err.message || 'Error desconocido'
  }
}

async function fetchRoles() {
  try {
    const res = await fetch(`${config.public.apiBaseUrl}/roles`)
    if (!res.ok) throw new Error('Error al cargar roles')
    roles.value = await res.json()
  } catch (err: any) {
    error.value = err.message || 'Error desconocido'
  }
}

async function actualizarUsuario() {
  loading.value = true
  error.value = null
  try {
    const res = await fetch(`${config.public.apiBaseUrl}/usuarios/${route.params.id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        rol_id: usuario.value.rol_id
      })
    })
    if (!res.ok) throw new Error('Error al actualizar usuario')
    router.push('/usuarios')
  } catch (err: any) {
    error.value = err.message || 'Error desconocido'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRoles()
  fetchUsuario()
})
</script>

<style scoped>
.usuario-edit {
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
