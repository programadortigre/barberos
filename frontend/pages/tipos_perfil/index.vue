<!--script setup>
import { onMounted } from 'vue'
definePageMeta({ layout: 'admin' })

const columnas = [
  { key: 'nombre', label: 'Nombre' },
  { key: 'descripcion', label: 'Descripción' },
  { key: 'campos_json', label:'Campos JSON' }
]

const camposFormulario = [
  { key: 'nombre', label: 'Nombre' },
  { key: 'descripcion', label: 'Descripción' },
  { key: 'clave', label:'clave' },
  { key: 'campos_json', label:'Campos JSON' }

]

</script>

<template>
  <CrudTable endpoint="tipos_perfil" :columnas="columnas" :camposFormulario="camposFormulario" />
</template-->
<script setup lang="ts">
import { TiposPerfilConfig } from '@/configs/TiposPerfil'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="TiposPerfilConfig" />
</template>