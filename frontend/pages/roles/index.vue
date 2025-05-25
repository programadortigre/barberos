<script setup>
import { onMounted } from 'vue'
definePageMeta({ layout: 'admin' })

const columnas = [
  { key: 'nombre', label: 'Nombre' },
  { key: 'descripcion', label: 'Descripción' }
]

const camposFormulario = [
  { key: 'nombre', label: 'Nombre' },
  { key: 'descripcion', label: 'Descripción' }
]


</script>

<template>
  <CrudTable endpoint="roles" :columnas="columnas" :camposFormulario="camposFormulario" />
</template>
