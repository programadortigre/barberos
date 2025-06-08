<script setup>
import { onMounted } from 'vue'
definePageMeta({ layout: 'admin' })

const columnas = [
  { key: 'nombre', label: 'Nombre' },
  { key: 'clave', label: 'clave' },
  { key: 'descripcion', label: 'Descripción' }
]

const camposFormulario = [
  { key: 'nombre', label: 'Nombre' },
  { key: 'clave', label: 'clave' },
  { key: 'descripcion', label: 'Descripción' }
]


</script>

<template>
  <CrudTable endpoint="permisos" :columnas="columnas" :camposFormulario="camposFormulario" />
</template>
