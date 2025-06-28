<script setup>
definePageMeta({ layout: 'admin' })

const config = useRuntimeConfig()
const { data: roles, refresh } = await useFetch(`${config.public.apiBaseUrl}/roles`)
</script>

<template>
  <div>
    <h1 class="text-2xl font-bold mb-4">Roles</h1>
    <ul>
      <li v-for="rol in roles" :key="rol.id">
        {{ rol.nombre }} - {{ rol.descripcion }}
      </li>
    </ul>
  </div>
</template>
