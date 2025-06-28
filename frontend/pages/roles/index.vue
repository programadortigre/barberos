<script setup lang="ts">
import { Roles } from '@/configs/Roles'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="Roles" />
</template>