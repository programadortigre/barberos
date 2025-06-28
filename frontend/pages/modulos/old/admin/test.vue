<script setup>
definePageMeta({ layout: 'admin' })

import { ref, onMounted } from 'vue'

const usuario = ref(null)
const error = ref(null)

// Aquí pega tu token JWT obtenido en login
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI3IiwidXNlcm5hbWUiOiJhZG1pbiIsInJvbF9pZCI6MSwiZXhwIjoxNzQ3NjY4NTUzfQ.h574O0LDsvHPjHxiDCHJFBzprVQevVNO1aX481avQ3g'

onMounted(async () => {
  try {
    const res = await fetch('http://localhost:8000/usuarios/me', {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json'
      }
    })

    if (!res.ok) {
      throw new Error(`Error ${res.status}`)
    }

    usuario.value = await res.json()
  } catch (e) {
    error.value = e.message
  }
})
</script>

<template>
  <div>
    <h1>Usuario Actual</h1>
    <div v-if="error" style="color: red">Error: {{ error }}</div>
    <pre v-if="usuario">{{ usuario }}</pre>
  </div>
</template>
