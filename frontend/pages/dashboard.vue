<template>
  <div>
    <h1>Dashboard</h1>
    <p>Bienvenido al panel de control.</p>
    <nuxt-link to="/logout">Cerrar sesión</nuxt-link>
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">
    <Card title="Usuarios" icon="pi pi-users" value="1200" />
    <Card title="Ventas" icon="pi pi-dollar" value="$25,000" />
    <Card title="Visitas" icon="pi pi-chart-line" value="3.2k" />
    <Card title="Tareas" icon="pi pi-check-square" value="47" />
  </div>
  </div>
</template>
<!-- pages/dashboard.vue -->
<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import Card from '~/components/ui/Card.vue'

</script>