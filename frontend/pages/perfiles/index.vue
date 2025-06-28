<script setup lang="ts">
import { data } from '@/configs/Perfiles'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="data" />
</template>