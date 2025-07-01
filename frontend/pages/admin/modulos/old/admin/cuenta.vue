<script setup>
definePageMeta({ layout: 'admin' })

import { useAuthStore } from '~/stores/auth'
import { computed, onMounted } from 'vue'

const auth = useAuthStore()

// Asegúrate de cargar el usuario si no está aún
onMounted(async () => {
  if (!auth.user) {
    await auth.init()
  }
})

const user = computed(() => auth.user)
</script>
<template>
  <div class="user-info">
    <h1>Bienvenido {{ user?.persona?.nombres || user?.username }}</h1>

    <section class="section">
      <h2>Datos personales</h2>
      <ul>
        <li><strong>Nombre completo:</strong> {{ user.persona.nombres }} {{ user.persona.apellido_paterno }} {{ user.persona.apellido_materno }}</li>
        <li><strong>DNI:</strong> {{ user.persona.dni }}</li>
        <li><strong>Fecha de nacimiento:</strong> {{ user.persona.fecha_nacimiento }}</li>
        <li><strong>Género:</strong> {{ user.persona.genero === 'M' ? 'Masculino' : 'Femenino' }}</li>
      </ul>
    </section>

    <section class="section">
      <h2>Cuenta</h2>
      <ul>
        <li><strong>Usuario:</strong> {{ user.username }}</li>
        <li><strong>Estado:</strong> {{ user.estado }}</li>
        <li><strong>Último login:</strong> {{ user.ultimo_login || 'Nunca' }}</li>
        <li><strong>Intentos fallidos:</strong> {{ user.intentos_fallidos }}</li>
      </ul>
    </section>

    <section class="section">
      <h2>Rol y permisos</h2>
      <p><strong>Rol:</strong> {{ user.rol.nombre }} — {{ user.rol.descripcion }}</p>

      <div v-if="user.rol.permisos?.length" class="permisos">
        <h3>Permisos:</h3>
        <ul>
          <li v-for="permiso in user.rol.permisos" :key="permiso.id">
            <strong>{{ permiso.nombre }}</strong> (<em>{{ permiso.clave }}</em>)<br />
            <small>{{ permiso.descripcion }}</small>
          </li>
        </ul>
      </div>
    </section>

    <button class="logout-button" @click="auth.logout">
      Cerrar sesión
    </button>
  </div>
</template>
