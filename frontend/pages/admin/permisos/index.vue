<script setup lang="ts">
import { data } from '@/configs/Permisos'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="data" />
</template>