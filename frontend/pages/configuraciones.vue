<script setup lang="ts">
import { data } from '@/configs/Configuraciones'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="data" />
</template>