<template>
  <div class="modal-overlay">
    <div class="modal-content">
      <h3>{{ isEditing ? 'Editar Usuario' : 'Nuevo Usuario' }}</h3>
      
      <form @submit.prevent="submitForm">
        <!-- Sección de credenciales -->
        <div class="form-section">
          <label>Username:</label>
          <input v-model="formData.username" required>
          
          <label>Contraseña:</label>
          <input type="password" v-model="formData.password">
        </div>

        <!-- Selección de Rol -->
        <div class="form-section">
          <label>Rol:</label>
          <select v-model="formData.rol_id" required>
            <option v-for="role in roles" :value="role.id">{{ role.nombre }}</option>
          </select>
        </div>

        <!-- Información Personal vinculada -->
        <PersonaForm :personaData="formData.persona" @update="updatePersona"/>
        
        <div class="form-actions">
          <button type="button" @click="$emit('close')">Cancelar</button>
          <button type="submit">Guardar</button>
        </div>
      </form>
    </div>
  </div>
</template>