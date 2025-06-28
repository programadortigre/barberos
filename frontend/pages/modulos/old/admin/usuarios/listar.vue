<script setup lang="ts">
import BaseTable from '~/components/BaseTable.vue'

const headers = [
  { key: 'id', label: 'ID' },
  { key: 'username', label: 'Usuario' },
  { key: 'nombres', label: 'Nombres' },
  { key: 'apellido_paterno', label: 'Apellido Paterno' },
  { key: 'apellido_materno', label: 'Apellido Materno' },
  { key: 'dni', label: 'DNI' },
  { key: 'rolNombre', label: 'Rol' },
  { key: 'estado', label: 'Estado' },
  { key: 'ultimo_login', label: 'Último Login' },
]

// Cargar datos del backend FastAPI usando useFetch
const { data: usuarios, pending, error, refresh } = await useFetch('/usuarios', {
  baseURL: 'http://localhost:8000',
})

// Métodos para editar y eliminar
function editarUsuario(usuario) {
  alert(`Editar usuario ${usuario.username}`)
}

function eliminarUsuario(usuario) {
  if (confirm(`¿Eliminar usuario ${usuario.username}?`)) {
    // Aquí podrías hacer un fetch DELETE si deseas
    console.log('Eliminar lógicamente en el backend')
  }
}
</script>

<template>
  <section>
    <h1>Listado de Usuarios</h1>

    <div v-if="pending">Cargando...</div>
    <div v-else-if="error">Error al cargar usuarios: {{ error.message }}</div>

    <BaseTable
      v-else
      :data="usuarios"
      :headers="headers"
      @edit="editarUsuario"
      @delete="eliminarUsuario"
    >
      <!-- Slots para campos anidados -->
      <template #cell-nombres="{ item }">{{ item.persona.nombres }}</template>
      <template #cell-apellido_paterno="{ item }">{{ item.persona.apellido_paterno }}</template>
      <template #cell-apellido_materno="{ item }">{{ item.persona.apellido_materno }}</template>
      <template #cell-dni="{ item }">{{ item.persona.dni }}</template>
      <template #cell-rolNombre="{ item }">{{ item.rol.nombre }}</template>
      <template #cell-ultimo_login="{ item }">{{ new Date(item.ultimo_login).toLocaleString() }}</template>
    </BaseTable>
  </section>
</template>

<style scoped>
section {
  max-width: 960px;
  margin: auto;
  padding: 2rem 1rem;
}
</style>
