<template>
  <div class="user-management">
    <!-- Cabecera y botón de nuevo -->
    <div class="header">
      <h2>Gestión de Usuarios</h2>
      <button @click="showUserForm(null)" class="btn-new">Nuevo Usuario</button>
    </div>

    <!-- Tabla de usuarios -->
    <table class="user-table">
      <thead>
        <tr>
          <th>Usuario</th>
          <th>Estado</th>
          <th>Rol</th>
          <th>Último Login</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>{{ user.username }}</td>
          <td>
            <span :class="['status', user.estado.toLowerCase()]">
              {{ user.estado }}
            </span>
          </td>
          <td>{{ user.rol.nombre }}</td>
          <td>{{ formatDate(user.ultimo_login) || 'Nunca' }}</td>
          <td>
            <button @click="showUserForm(user)" class="btn-edit">Editar</button>
            <button @click="toggleStatus(user)" class="btn-status">
              {{ user.estado === 'activo' ? 'Desactivar' : 'Activar' }}
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Modal de edición/creación -->
    <UserFormModal 
      v-if="showModal"
      :userData="selectedUser"
      @close="showModal = false"
      @save="handleSave"
    />
  </div>
</template>