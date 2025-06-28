<script setup lang="ts">
import { Usuarios } from '@/configs/Usuarios'
definePageMeta({ layout: 'aplicacion' })
</script>

<template>
  <CrudTable :config="Usuarios" />
</template>