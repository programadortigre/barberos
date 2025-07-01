<template>
  <div class="role-management">
    <h2>Gestión de Roles y Permisos</h2>
    
    <!-- Lista de Roles -->
    <div class="role-list">
      <div v-for="role in roles" :key="role.id" class="role-card">
        <div class="role-header">
          <h4>{{ role.nombre }}</h4>
          <p>{{ role.descripcion }}</p>
        </div>
        
        <!-- Permisos asignados -->
        <div class="permissions-list">
          <div v-for="permission in role.permisos" :key="permission.id" class="permission-tag">
            {{ permission.nombre }}
            <span class="permission-key">{{ permission.clave }}</span>
          </div>
        </div>
        
        <button @click="editRole(role)" class="btn-edit">Editar Rol</button>
      </div>
    </div>

    <!-- Modal de Edición de Rol -->
    <RoleEditorModal 
      v-if="showRoleEditor"
      :roleData="selectedRole"
      @close="showRoleEditor = false"
    />
  </div>
</template>