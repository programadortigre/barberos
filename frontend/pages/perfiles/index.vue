<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import { ref, onMounted } from 'vue'
import { useCrud } from '@/composables/useCrud'

const columnas = [
  { key: 'persona_id', label: 'ID Persona' },
  { key: 'tipo_perfil_id', label: 'Tipo de Perfil' },
  { key: 'datos_personalizados_json', label: 'Datos Personalizados' },
]

const { items: personas, cargar: fetchPersonas } = useCrud<any>('personas')
const { items: tiposPerfil, cargar: fetchTiposPerfil } = useCrud<any>('tipos_perfil')

const camposFormulario = ref([
  {
    key: 'persona_id',
    label: 'Persona',
    type: 'select',
    options: []
  },
  {
    key: 'tipo_perfil_id',
    label: 'Tipo de Perfil',
    type: 'select',
    options: []
  },
  {
    key: 'datos_personalizados_json',
    label: 'Datos personalizados (JSON)',
    type: 'textarea',
  }
])

onMounted(async () => {
  await Promise.all([fetchPersonas(), fetchTiposPerfil()])

  camposFormulario.value[0].options = personas.value.map(p => ({
    label: `${p.nombres} ${p.apellido_paterno}`,
    value: p.id
  }))

  camposFormulario.value[1].options = tiposPerfil.value.map(tp => ({
    label: tp.descripcion,
    value: tp.id
  }))
})
</script>

<template>
  <CrudTable
    endpoint="perfiles"
    :columnas="columnas"
    :camposFormulario="camposFormulario"
  />
</template>
