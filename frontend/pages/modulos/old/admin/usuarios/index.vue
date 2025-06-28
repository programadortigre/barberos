<script setup lang="ts">

import { onMounted, ref } from 'vue'
import { useUsuarios } from '~/composables/useUsuarios'
import BaseTable from '~/components/BaseTable.vue'   // <-- Aquí importas

const { usuarios, loading, error, fetchUsuarios, deleteUsuario } = useUsuarios()

onMounted(() => {
  fetchUsuarios()
})

function eliminarUsuario(id: number) {
  if (confirm('¿Seguro que quieres eliminar este usuario?')) {
    deleteUsuario(id)
  }
}

function editarUsuario(usuario: any) {
  // Puedes usar router.push o cualquier otra lógica
  // Como estás con script setup, puedes importar useRouter
  router.push(`/usuarios/${usuario.id}`)
}

// Para definir headers que pasaremos al componente
const headers = [
  { key: 'id', label: 'ID' },
  { key: 'username', label: 'Username' },
  { key: 'rolNombre', label: 'Rol' },
]

// Dado que tu usuario tiene `rol.nombre`, pero el componente espera
// que cada campo esté en la raíz, crea un computed para transformar

import { computed } from 'vue'

const usuariosTransformados = computed(() => {
  return usuarios.value.map(u => ({
    id: u.id,
    username: u.username,
    rolNombre: u.rol.nombre,
  }))
})

// Para router en script setup:
import { useRouter } from 'vue-router'
const router = useRouter()
definePageMeta({ layout: 'admin' })

</script>

<template>
  <section class="usuarios-list">
    <h1>Usuarios</h1>

    <button @click="router.push('/usuarios/create')">Crear Usuario</button>

    <div v-if="loading">Cargando usuarios...</div>
    <div v-if="error" class="error">{{ error }}</div>

    <BaseTable
      v-if="usuarios.length"
      :data="usuariosTransformados"
      :headers="headers"
      @edit="editarUsuario"
      @delete="eliminarUsuario"
    />

    <div v-else>No hay usuarios.</div>
  </section>
</template>

<style scoped>
.usuarios-list {
  max-width: 800px;
  margin: auto;
}
.error {
  color: red;
}
</style>
