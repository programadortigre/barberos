<script setup lang="ts">
import { Personas } from '@/configs/Personas'
definePageMeta({ layout: 'admin' })
</script>

<template>
  <CrudTable :config="Personas" />
</template>