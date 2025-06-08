<script setup lang="ts">
const props = defineProps<{ search: string }>()
const emit = defineEmits(['update:search', 'nuevo'])

const searchLocal = ref(props.search)

watch(() => props.search, (val) => {
  searchLocal.value = val
})

watch(searchLocal, (val) => {
  emit('update:search', val)
})
</script>

<template>
  <div class="toolbar">
    <input
      type="text"
      v-model="searchLocal"
      placeholder="Buscar..."
    />
    <button @click="emit('nuevo')">+ Nuevo</button>
  </div>
</template>
