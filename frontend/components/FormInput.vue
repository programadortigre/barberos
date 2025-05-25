<script setup lang="ts">
defineProps<{
  modelValue: string,
  label: string,
  id: string
}>()

const emit = defineEmits(['update:modelValue'])
</script>

<template>
  <div>
    <label :for="id" class="block mb-1 text-sm font-medium text-gray-700">{{ label }}</label>
    <input
      :id="id"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      class="w-full border border-gray-300 p-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
    />
  </div>
</template>
