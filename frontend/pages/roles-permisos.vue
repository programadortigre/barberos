<script setup lang="ts">
import { rolesPermisosConfig } from '@/configs/rolesPermisosConfig'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="rolesPermisosConfig" />
</template>
