<template>
  <div class="persona-form">
    <h4>Datos Personales</h4>
    
    <div class="form-grid">
      <div>
        <label>Nombres:</label>
        <input v-model="localData.nombres" required>
      </div>
      
      <div>
        <label>Apellidos:</label>
        <div class="apellidos-group">
          <input v-model="localData.apellido_paterno" placeholder="Paterno" required>
          <input v-model="localData.apellido_materno" placeholder="Materno">
        </div>
      </div>
      
      <div>
        <label>DNI:</label>
        <input v-model="localData.dni" pattern="\d{8}" required>
      </div>
      
      <div>
        <label>Correo:</label>
        <input type="email" v-model="localData.correo_cifrado" required>
      </div>
    </div>
  </div>
</template>