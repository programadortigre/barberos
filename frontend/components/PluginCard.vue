<template>
  <div class="plugin-card">
    <div class="header">
      <h3>{{ plugin.name }}</h3>
      <span :class="plugin.active ? 'status active' : 'status inactive'">
        {{ plugin.active ? 'Activo' : 'Inactivo' }}
      </span>
    </div>
    <p>{{ plugin.description }}</p>
    <div class="meta">
      <small>Versión: {{ plugin.version }}</small>
      <small>Autor: {{ plugin.author }}</small>
    </div>
    <div class="actions">
      <button @click="toggle">{{ plugin.active ? 'Desactivar' : 'Activar' }}</button>
    </div>
  </div>
</template>

<script setup>
defineProps({
  plugin: Object
})

const emit = defineEmits(['toggle'])

function toggle() {
  emit('toggle')
}
</script>

<style scoped lang="scss">
.plugin-card {
  border: 1px solid #ddd;
  border-radius: 1rem;
  padding: 1rem;
  margin: 0.5rem 0;
  background: #fff;
  .header {
    display: flex;
    justify-content: space-between;
    font-weight: bold;
  }
  .status {
    &.active {
      color: green;
    }
    &.inactive {
      color: gray;
    }
  }
  .meta {
    font-size: 0.8rem;
    margin-top: 0.5rem;
    color: #777;
    display: flex;
    justify-content: space-between;
  }
  .actions {
    margin-top: 1rem;
    text-align: right;
    button {
      padding: 0.4rem 1rem;
      border-radius: 0.5rem;
      background: #007bff;
      color: white;
      border: none;
      cursor: pointer;
    }
  }
}
</style>
