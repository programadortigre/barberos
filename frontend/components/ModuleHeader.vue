<template>
  <header class="module-header">
    <h1>{{ icon }} {{ title }}</h1>
    <p>{{ description }}</p>
  </header>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  icon: string
  description: string
}>()
</script>

<style scoped lang="scss">
.module-header {
  padding: 1.5rem;
  border-bottom: 1px solid #eee;
  h1 {
    font-size: 1.75rem;
    margin-bottom: 0.25rem;
  }
  p {
    color: #666;
  }
}
</style>
