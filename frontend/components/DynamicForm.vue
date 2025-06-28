<template>
  <form @submit.prevent="handleSubmit" class="form-container" novalidate>
    <div class="form-grid">
      <div
        v-for="(field, index) in config"
        :key="index"
        class="form-group"
        :class="{
          error: errors[field.name],
          [`col-${field.col}`]: field.col,
          inline: field.inline
        }"
      >
        <!-- Inputs estándar -->
        <div
          class="input-wrapper"
          v-if="[
            'text',
            'email',
            'password',
            'tel',
            'url',
            'number',
            'date',
            'time',
            'datetime-local'
          ].includes(field.type)"
        >
          <input
            :type="field.type"
            :id="field.name"
            v-model="formData[field.name]"
            :placeholder="field.placeholder || ' '"
            @blur="validateField(field)"
            @input="validateOnInput && validateField(field)"
            :class="{ invalid: errors[field.name] }"
            autocomplete="off"
            :aria-describedby="`${field.name}-error`"
          />
          <label :for="field.name">{{ field.label }}</label>
          <span v-if="field.suffix" class="input-suffix">{{ field.suffix }}</span>
        </div>

        <!-- Textarea -->
        <div v-else-if="field.type === 'textarea'" class="input-wrapper">
          <textarea
            :id="field.name"
            v-model="formData[field.name]"
            @blur="validateField(field)"
            @input="validateOnInput && validateField(field)"
            :placeholder="field.placeholder || ' '"
            :class="{ invalid: errors[field.name] }"
            :rows="field.rows || 4"
            :aria-describedby="`${field.name}-error`"
          ></textarea>
          <label :for="field.name">{{ field.label }}</label>
        </div>

        <!-- Select -->
        <div v-else-if="field.type === 'select'" class="input-wrapper">
          <select
            :id="field.name"
            v-model="formData[field.name]"
            @change="validateField(field)"
            :class="{ invalid: errors[field.name] }"
            :aria-describedby="`${field.name}-error`"
          >
            <option disabled value="">{{ field.placeholder || '-- Seleccionar --' }}</option>
            <option v-for="option in field.options" :key="option.value" :value="option.value">
              {{ option.label }}
            </option>
          </select>
          <label :for="field.name" class="select-label">{{ field.label }}</label>
        </div>

        <!-- Checkbox Group -->
        <fieldset
          v-else-if="field.type === 'checkbox-group'"
          class="checkbox-group"
          :class="{ grid: field.grid }"
        >
          <legend>{{ field.label }}</legend>
          <div
            v-for="option in field.options"
            :key="option.value"
            class="checkbox-item"
          >
            <input
              type="checkbox"
              :id="`${field.name}_${option.value}`"
              :value="option.value"
              v-model="formData[field.name]"
              @change="validateField(field)"
            />
            <label :for="`${field.name}_${option.value}`">{{ option.label }}</label>
          </div>
        </fieldset>

        <!-- Radio Group -->
        <fieldset
          v-else-if="field.type === 'radio-group'"
          class="radio-group"
          :class="{ grid: field.grid }"
        >
          <legend>{{ field.label }}</legend>
          <div
            v-for="option in field.options"
            :key="option.value"
            class="radio-item"
          >
            <input
              type="radio"
              :id="`${field.name}_${option.value}`"
              :value="option.value"
              v-model="formData[field.name]"
              @change="validateField(field)"
            />
            <label :for="`${field.name}_${option.value}`">{{ option.label }}</label>
          </div>
        </fieldset>

        <!-- Switch (Toggle) -->
        <div v-else-if="field.type === 'switch'" class="switch-wrapper">
          <label class="switch">
            <input
              type="checkbox"
              :id="field.name"
              v-model="formData[field.name]"
              @change="validateField(field)"
            />
            <span class="slider"></span>
          </label>
          <label :for="field.name" class="switch-label">{{ field.label }}</label>
        </div>

        <!-- File Upload -->
        <div v-else-if="field.type === 'file'" class="file-upload">
          <label :for="field.name" class="file-label">
            <span class="file-button">
              <svg xmlns="http://www.w3.org/2000/svg" class="icon" viewBox="0 0 24 24">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zm4 18H6V4h7v5h5v11z"/>
              </svg>
              {{ field.buttonText || 'Seleccionar archivo' }}
            </span>
            <span class="file-name" v-if="Array.isArray(formData[field.name])">
              {{ formData[field.name].length }} archivos seleccionados
            </span>
            <span class="file-name" v-else-if="formData[field.name]">
              {{ formData[field.name].name }}
            </span>
            <span v-else class="file-placeholder">
              {{ field.placeholder || 'No hay archivos seleccionados' }}
            </span>
          </label>
          <input
            type="file"
            :id="field.name"
            @change="handleFileUpload($event, field)"
            class="input-file"
            :accept="field.accept"
            :multiple="field.multiple"
          />
        </div>

        <!-- Error Message -->
        <p
          v-if="errors[field.name]"
          :id="`${field.name}-error`"
          class="error-message"
          role="alert"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="error-icon" viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
          </svg>
          {{ errors[field.name] }}
        </p>
      </div>
    </div>

    <div class="form-actions">
      <button
        type="submit"
        class="btn-submit"
        :disabled="hasErrors"
        :aria-disabled="hasErrors"
      >
        {{ submitLabel }}
      </button>
      <slot name="actions"></slot>
    </div>
  </form>
</template>

<script setup>
import { reactive, watch, computed } from 'vue'

const props = defineProps({
  config: { type: Array, required: true },
  modelValue: { type: Object, default: () => ({}) },
  submitLabel: { type: String, default: 'Enviar' },
  validateOnInput: { type: Boolean, default: true }
})

const emit = defineEmits(['update:modelValue', 'submit', 'file-upload'])

const formData = reactive({})
const errors = reactive({})

// Inicialización del formulario
const initializeForm = () => {
  props.config.forEach(field => {
    const initialValue = props.modelValue[field.name] ?? getDefaultValue(field)
    formData[field.name] = initialValue
    errors[field.name] = ''
  })
}

const getDefaultValue = (field) => {
  switch (field.type) {
    case 'checkbox-group': return []
    case 'switch': return false
    case 'file': return field.multiple ? [] : null
    case 'number': return field.min || 0
    default: return ''
  }
}

watch(() => props.config, initializeForm, { immediate: true })
watch(() => props.modelValue, (newVal) => {
  Object.assign(formData, newVal)
}, { deep: true })

// Sincronización con v-model
watch(
  formData,
  (newVal) => emit('update:modelValue', newVal),
  { deep: true }
)

// Validaciones
const validateField = (field) => {
  const value = formData[field.name]
  errors[field.name] = ''

  if (field.required && !isValidValue(value, field.type)) {
    errors[field.name] = field.errorMessages?.required || 'Este campo es obligatorio.'
    return false
  }

  const validators = {
    email: val => /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(val) ? null : 'Correo inválido',
    url: val => /^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$/.test(val) ? null : 'URL inválida',
    number: val => {
      const num = Number(val)
      if (isNaN(num)) return 'Número inválido'
      if (field.min !== undefined && num < field.min) return `Mínimo: ${field.min}`
      if (field.max !== undefined && num > field.max) return `Máximo: ${field.max}`
      return null
    },
    tel: val => /^[+]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$/.test(val) ? null : 'Teléfono inválido',
    file: (val, field) => {
      if (!val) return null
      const files = Array.isArray(val) ? val : [val]
      
      if (field.accept) {
        const allowedTypes = field.accept.split(',').map(t => t.trim())
        if (!files.every(file => allowedTypes.some(type => file.type.includes(type)))) {
          return `Formatos permitidos: ${allowedTypes.join(', ')}`
        }
      }
      
      if (field.maxSize && files.some(file => file.size > field.maxSize)) {
        return `Tamaño máximo: ${formatBytes(field.maxSize)}`
      }
      return null
    },
    'checkbox-group': (val, field) => {
      if (field.required && val.length === 0) return 'Selección requerida'
      if (field.minChoices && val.length < field.minChoices) return `Mínimo ${field.minChoices} opciones`
      if (field.maxChoices && val.length > field.maxChoices) return `Máximo ${field.maxChoices} opciones`
      return null
    },
    pattern: (val, field) => field.pattern && !new RegExp(field.pattern).test(val)
      ? field.errorMessages?.pattern || 'Formato inválido'
      : null
  }

  const validator = validators[field.type] || validators[field.validationType]
  if (validator) {
    const error = validator(value, field)
    if (error) errors[field.name] = error
  }

  return !errors[field.name]
}

const isValidValue = (value, type) => {
  if (type === 'checkbox-group') return value.length > 0
  if (type === 'file') return Array.isArray(value) ? value.length > 0 : !!value
  return !!value || value === 0
}

const hasErrors = computed(() => Object.values(errors).some(e => e))

const handleFileUpload = (event, field) => {
  const files = event.target.files
  if (!files.length) return

  formData[field.name] = field.multiple 
    ? Array.from(files)
    : files[0]

  emit('file-upload', { 
    name: field.name, 
    files: formData[field.name],
    isValid: validateField(field)
  })
}

const handleSubmit = () => {
  const validations = props.config.map(field => validateField(field))
  const isValid = validations.every(valid => valid)
  emit('submit', { data: formData, isValid })
}

const formatBytes = (bytes, decimals = 2) => {
  if (!bytes) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(decimals))} ${sizes[i]}`
}
</script>

<style scoped>
.form-container {
  max-width: 800px;
  margin: 2rem auto;
  padding: 2rem;
  background: #fff;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12);
}

.form-grid {
  display: grid;
  gap: 1.5rem;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
}

.form-group {
  margin-bottom: 1.5rem;
  position: relative;
}

.form-group.inline {
  display: flex;
  align-items: center;
  gap: 1rem;
}

/* Clases de columnas manuales */
.form-group.col-1 { grid-column: span 1; }
.form-group.col-2 { grid-column: span 2; }
.form-group.col-3 { grid-column: span 3; }
.form-group.col-4 { grid-column: span 4; }
.form-group.col-5 { grid-column: span 5; }
.form-group.col-6 { grid-column: span 6; }
.form-group.col-7 { grid-column: span 7; }
.form-group.col-8 { grid-column: span 8; }
.form-group.col-9 { grid-column: span 9; }
.form-group.col-10 { grid-column: span 10; }
.form-group.col-11 { grid-column: span 11; }
.form-group.col-12 { grid-column: span 12; }

 

.checkbox-group,
.radio-group {
  border: none;
  padding: 0;
  margin: 0;
  
  legend {
    font-weight: 600;
    margin-bottom: 0.5rem;
  }
  
  &.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 0.5rem;
  }
}

.checkbox-item,
.radio-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0.25rem 0;
  
  input[type="checkbox"],
  input[type="radio"] {
    width: 1.25rem;
    height: 1.25rem;
    accent-color: #2563eb;
  }
}

.switch-wrapper {
  display: flex;
  align-items: center;
  gap: 1rem;
  
  .switch {
    position: relative;
    display: inline-block;
    width: 3rem;
    height: 1.75rem;
    
    input {
      opacity: 0;
      width: 0;
      height: 0;
      
      &:checked + .slider {
        background-color: #2563eb;
      }
      
      &:checked + .slider:before {
        transform: translateX(1.25rem);
      }
    }
    
    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #cbd5e1;
      transition: all 0.2s ease;
      border-radius: 2rem;
      
      &:before {
        content: "";
        position: absolute;
        height: 1.25rem;
        width: 1.25rem;
        left: 0.25rem;
        bottom: 0.25rem;
        background-color: white;
        transition: all 0.2s ease;
        border-radius: 50%;
      }
    }
  }
}

.file-upload {
  .input-file {
    opacity: 0;
    position: absolute;
    width: 0.1px;
    height: 0.1px;
    overflow: hidden;
  }
  
  .file-label {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1.5rem;
    border: 2px dashed #e5e7eb;
    border-radius: 0.5rem;
    cursor: pointer;
    transition: all 0.2s ease;
    
    &:hover {
      border-color: #2563eb;
      background: #f8fafc;
    }
  }
  
  .icon {
    width: 1.5rem;
    height: 1.5rem;
    fill: #2563eb;
  }
  
  .file-name {
    color: #64748b;
    font-size: 0.875rem;
  }
}

.error-message {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #dc2626;
  font-size: 0.875rem;
  margin-top: 0.5rem;
  
  .error-icon {
    width: 1.2rem;
    height: 1.2rem;
    fill: currentColor;
  }
}

.form-actions {
  margin-top: 2rem;
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
}

.btn-submit {
  background: #2563eb;
  color: white;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  
  &:hover:not(:disabled) {
    background: #1d4ed8;
  }
  
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}
</style>