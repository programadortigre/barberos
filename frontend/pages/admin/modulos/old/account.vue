<script setup>
definePageMeta({ layout: 'admin' })

import { useAuthStore } from '~/stores/auth'
import { computed, onMounted } from 'vue'

const auth = useAuthStore()

// Asegúrate de cargar el usuario si no está aún
onMounted(async () => {
  if (!auth.user) {
    await auth.init()
  }
})

const user = computed(() => auth.user)
</script>

<template>
  <div>
    <h1 v-if="user">Bienvenido {{ user?.persona?.nombres || user?.username }}</h1>

    <div v-if="user?.rol">
      Rol: {{ user.rol.nombre }}
      <div v-if="user.rol.permisos?.length">
        <h3>Permisos:</h3>
        <ul>
          <li v-for="permiso in user.rol.permisos" :key="permiso.id">
            {{ permiso.nombre }} ({{ permiso.clave }})
          </li>
        </ul>
      </div>
    </div>

    <button @click="auth.logout">Cerrar sesión</button>
  </div>
</template>
