<template>
  <AppContainer v-if="isReady">
    <slot />
  </AppContainer>
</template>

<script setup>
import AppContainer from '@/components/AppContainer.vue'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
const isReady = ref(false)

onMounted(async () => {
  if (!auth.token) {
    await auth.init()
  }

  // Si ya hay token o está en página pública, mostrar el contenido
  isReady.value = true
})
</script>
