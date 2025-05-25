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
  <div class="user-info">
    <h1>Bienvenido {{ user?.persona?.nombres || user?.username }}</h1>



    <button class="logout-button" @click="auth.logout">
      Cerrar sesión
    </button>
  </div>
</template>
