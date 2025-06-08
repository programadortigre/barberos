<template>
  <div class="p-4 rounded-lg shadow-md bg-surface-0 border border-surface-200">
    <div class="flex items-center space-x-4">
      <i :class="['text-xl', icon]"></i>
      <div>
        <div class="text-sm text-color-secondary">{{ title }}</div>
        <div class="text-xl font-bold">{{ value }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: String,
  icon: String,
  value: String
})
</script>
