<script setup lang="ts">
import { logsUsuariosConfig } from '@/configs/logsUsuariosConfig'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="logsUsuariosConfig" />
</template>