<!-- components/ListaUsuarios.vue -->
<template>
  <div class="usuarios-lista">
    <h2>Lista de Usuarios</h2>
    <table>
      <thead>
        <tr>
          <th>DNI</th>
          <th>Nombre Completo</th>
          <th>Usuario</th>
          <th>Rol</th>
          <th>Tipo de Perfil</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="usuario in usuarios" :key="usuario.id">
          <td>{{ usuario.persona?.dni }}</td>
          <td>
            {{ usuario.persona?.nombres }} {{ usuario.persona?.apellido_paterno }} {{ usuario.persona?.apellido_materno }}
          </td>
          <td>{{ usuario.username }}</td>
          <td>{{ usuario.rol?.nombre }}</td>
          <td>{{ usuario.perfil?.tipo_perfil?.nombre || '—' }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { obtenerUsuarios } from '@/services/usuarios'

const config = useRuntimeConfig()
const apiBase = config.public.apiBaseUrl

const usuarios = ref([])

onMounted(async () => {
  try {
    usuarios.value = await obtenerUsuarios(apiBase)
  } catch (err) {
    console.error('Error cargando usuarios:', err)
  }
})
</script>

<style scoped lang="scss">
.usuarios-lista {
  margin: 2rem;

  h2 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    border: 1px solid #ccc;

    th, td {
      padding: 0.75rem;
      border: 1px solid #ddd;
      text-align: left;
    }

    th {
      background-color: #f5f5f5;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }
  }
}
</style>
