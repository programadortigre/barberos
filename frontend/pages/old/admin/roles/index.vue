<template>
  <div>
    <h1>Roles</h1>
    <NuxtLink to="/roles/crear">+ Nuevo Rol</NuxtLink>
    <ul>
      <li v-for="rol in roles" :key="rol.id">
        {{ rol.nombre }} - {{ rol.descripcion }}
        <NuxtLink :to="`/roles/${rol.id}`">Editar</NuxtLink>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
const { listarRoles } = useRoles();
const { data: roles, refresh } = await listarRoles();
</script>
