<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useCrud } from '@/composables/useCrud'

definePageMeta({ layout: 'admin' })

const columnas = [
  { key: 'username', label: 'Usuario' },
  { key: 'estado', label: 'Estado' },
  { key: 'persona_id', label: 'Persona' },   // Mostraremos nombre persona, no solo ID
  { key: 'rol_id', label: 'Rol' },           // Mostraremos nombre rol, no solo ID
]

const { items: personas, fetchAll: fetchPersonas } = useCrud<any>('personas')
const { items: roles, fetchAll: fetchRoles } = useCrud<any>('roles')

const camposFormulario = ref([
  { key: 'username', label: 'Usuario', type: 'text' },
  { key: 'password', label: 'Contraseña', type: 'password' },
  { key: 'estado', label: 'Estado', type: 'select', options: [
    { label: 'Activo', value: 'activo' },
    { label: 'Inactivo', value: 'inactivo' },
  ]},
  { key: 'persona_id', label: 'Persona', type: 'select', options: [] },
  { key: 'rol_id', label: 'Rol', type: 'select', options: [] },
])

onMounted(async () => {
  await Promise.all([fetchPersonas(), fetchRoles()])
  // Actualizar opciones de select en camposFormulario
  camposFormulario.value = camposFormulario.value.map(campo => {
    if (campo.key === 'persona_id') {
      return {
        ...campo,
        options: personas.value.map(p => ({ label: `${p.nombres} ${p.apellido_paterno}`, value: p.id }))
      }
    }
    if (campo.key === 'rol_id') {
      return {
        ...campo,
        options: roles.value.map(r => ({ label: r.nombre, value: r.id }))
      }
    }
    return campo
  })
})
</script>

<template>
  <CrudTable
    endpoint="usuarios"
    :columnas="columnas"
    :camposFormulario="camposFormulario"
  >
    <!-- Opcional: slots para mostrar nombre persona y rol en tabla -->

  </CrudTable>
</template>
