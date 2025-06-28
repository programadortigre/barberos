<script setup lang="ts">
import { Usuarios } from '@/configs/Usuarios'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="Usuarios" />
</template>