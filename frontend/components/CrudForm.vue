<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  form: Record<string, any>
  campos: {
    key: string
    label: string
    type?: string // text, number, select, date, etc.
    options?: { label: string, value: any }[] // para selects manuales
  }[]
  relaciones?: {
    key: string
    recurso: string
    label: string | ((item: any) => string)
    items?: any[]
  }[]
  loading: boolean
}>()

const emit = defineEmits(['guardar', 'cancelar'])

function esRelacion(key: string) {
  return props.relaciones?.some(r => r.key === key)
}

function getRelacionItems(key: string) {
  return props.relaciones?.find(r => r.key === key)?.items || []
}

function getOptionLabel(relKey: string, item: any) {
  const rel = props.relaciones?.find(r => r.key === relKey)
  if (!rel) return ''
  return typeof rel.label === 'function' ? rel.label(item) : item[rel.label]
}
</script>

<template>
  <div class="modal">
    <div class="formulario">
      <h2>Formulario</h2>

      <form @submit.prevent="$emit('guardar')">
        <div
          v-for="campo in props.campos"
          :key="campo.key"
          class="campo"
        >
          <label :for="campo.key">{{ campo.label }}</label>

          <!-- Campo de relación: select dinámico -->
          <select
            v-if="esRelacion(campo.key)"
            v-model="form[campo.key]"
            :id="campo.key"
          >
            <option disabled value="">-- Selecciona --</option>
            <option
              v-for="opcion in getRelacionItems(campo.key)"
              :key="opcion.id"
              :value="opcion.id"
            >
              {{ getOptionLabel(campo.key, opcion) }}
            </option>
          </select>

          <!-- Campo tipo select manual -->
          <select
            v-else-if="campo.type === 'select'"
            v-model="form[campo.key]"
            :id="campo.key"
          >
            <option disabled value="">-- Selecciona --</option>
            <option
              v-for="opcion in campo.options || []"
              :key="opcion.value"
              :value="opcion.value"
            >
              {{ opcion.label }}
            </option>
          </select>

          <!-- Campo normal -->
          <input
            v-else
            :type="campo.type || 'text'"
            :id="campo.key"
            v-model="form[campo.key]"
          />
        </div>

        <div class="acciones">
          <button type="submit" :disabled="loading">Guardar</button>
          <button type="button" @click="$emit('cancelar')">Cancelar</button>
        </div>
      </form>
    </div>
  </div>
</template>
<style scoped lang="scss">


.modal {
  background: rgba(0, 0, 0, 0.45);
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 50;
  backdrop-filter: blur(4px);
}

.formulario {
  background: var(--bg-modal);
  padding: 2rem;
  border-radius: 1rem;
  width: 100%;
  max-width: 480px;
  max-height: 85vh;
  overflow-y: auto;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
  animation: fadeIn 0.3s ease-in-out;
  color: var(--text-color);
  font-family: 'Inter', system-ui, sans-serif;
}

h2 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  text-align: center;
  font-weight: 600;
}

.campo {
  margin-bottom: 1.25rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.campo label {
  font-weight: 500;
  font-size: 0.95rem;
}

.campo input,
.campo select {
  font-size: 1rem;
  padding: 0.6rem 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: 0.5rem;
  background-color: var(--input-bg);
  color: var(--text-color);
  transition: border-color 0.2s ease, box-shadow 0.2s ease;

  &:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
  }
}

.acciones {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  margin-top: 1rem;
}

.acciones button {
  font-size: 0.95rem;
  padding: 0.55rem 1.25rem;
  border-radius: 0.5rem;
  border: none;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s ease, transform 0.1s ease;
}

.acciones button[type="submit"] {
  background-color: var(--primary-color);
  color: #fff;

  &:hover {
    background-color: var(--primary-color-hover);
    transform: translateY(-1px);
  }

  &:disabled {
    background-color: #c7d2fe;
    cursor: not-allowed;
  }
}

.acciones button[type="button"] {
  background-color: #e5e7eb;
  color: #374151;

  &:hover {
    background-color: #d1d5db;
  }
}

@keyframes fadeIn {
  from {
    transform: scale(0.95);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}
</style>
