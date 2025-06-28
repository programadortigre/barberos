<template>
  <form @submit.prevent="handleSubmit" class="form-container" novalidate>
    <div class="form-fields">
    <div
      v-for="(field, index) in config"
      :key="index"
      class="form-group"
      :class="{ error: errors[field.name] }"
      :style="{ gridColumn: field.gridColumn || 'auto' }"
    >
      <!-- Input básico (text, email, number, etc) -->
      <div
        v-if="['text','email','number','date','password','tel','url','datetime-local'].includes(field.type)"
        class="input-wrapper"
      >
        <input
          :type="field.type"
          :id="field.name"
          v-model="formData[field.name]"
          :placeholder="field.placeholder || ' '"
          @blur="validateField(field)"
          @input="validateField(field)"
          :class="{ invalid: errors[field.name] }"
          :autocomplete="field.autocomplete || 'off'"
          :pattern="field.pattern"
          :min="field.min"
          :max="field.max"
          :step="field.step"
          :aria-describedby="field.name + '-error'"
          :aria-invalid="errors[field.name] ? 'true' : 'false'"
        />
        <label :for="field.name">{{ field.label }}</label>
        <span v-if="field.suffix" class="input-suffix">{{ field.suffix }}</span>
        <slot :name="`action-${field.name}`"></slot>
      </div>

      <!-- Textarea -->
      <div v-else-if="field.type === 'textarea'" class="input-wrapper">
        <textarea
          :id="field.name"
          v-model="formData[field.name]"
          @blur="validateField(field)"
          @input="validateField(field)"
          :placeholder="field.placeholder || ' '"
          :class="{ invalid: errors[field.name] }"
          :rows="field.rows || 4"
          :aria-describedby="field.name + '-error'"
          :aria-invalid="errors[field.name] ? 'true' : 'false'"
        ></textarea>
        <label :for="field.name">{{ field.label }}</label>
        <slot :name="`action-${field.name}`"></slot>
      </div>

      <!-- Select -->
      <div v-else-if="field.type === 'select'" class="input-wrapper">
        <select
          :id="field.name"
          v-model="formData[field.name]"
          @change="validateField(field)"
          :class="{ invalid: errors[field.name] }"
          :aria-describedby="field.name + '-error'"
          :aria-invalid="errors[field.name] ? 'true' : 'false'"
        >
          <option disabled value="">{{ field.placeholder || '-- Seleccionar --' }}</option>
          <option v-for="option in field.options" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>
        <label :for="field.name" class="select-label">{{ field.label }}</label>
        <slot :name="`action-${field.name}`"></slot>
      </div>

      <!-- Checkbox group -->
      <fieldset
        v-else-if="field.type === 'checkbox-json'"
        class="checkbox-list"
        :aria-describedby="field.name + '-error'"
        :aria-invalid="errors[field.name] ? 'true' : 'false'"
      >
        <legend class="checkbox-label">{{ field.label }}</legend>
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

      <!-- Radio buttons -->
      <fieldset
        v-else-if="field.type === 'radio'"
        class="radio-list"
        :aria-describedby="field.name + '-error'"
        :aria-invalid="errors[field.name] ? 'true' : 'false'"
      >
        <legend class="radio-label">{{ field.label }}</legend>
        <div v-for="option in field.options" :key="option.value" class="radio-item">
          <input
            type="radio"
            :id="`${field.name}_${option.value}`"
            :value="option.value"
            v-model="formData[field.name]"
            @change="validateField(field)"
            :name="field.name"
          />
          <label :for="`${field.name}_${option.value}`">{{ option.label }}</label>
        </div>
      </fieldset>

      <!-- Switch / toggle -->
      <div v-else-if="field.type === 'switch'" class="switch-wrapper">
        <label :for="field.name" class="switch-label">{{ field.label }}</label>
        <input
          type="checkbox"
          role="switch"
          :id="field.name"
          v-model="formData[field.name]"
          @change="validateField(field)"
          :aria-checked="formData[field.name] ? 'true' : 'false'"
        />
      </div>

      <!-- File upload drag & drop -->
      <div
        v-else-if="field.type === 'file'"
        class="file-upload-wrapper"
        @dragover.prevent="dragActive = true"
        @dragleave.prevent="dragActive = false"
        @drop.prevent="handleDrop($event, field.name)"
      >
        <label
          class="file-label"
          :for="field.name"
          :class="{ 'drag-active': dragActive }"
          tabindex="0"
          @keydown.enter.prevent="$refs[field.name]?.click()"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="upload-icon"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="2"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M12 12v8m0 0l-4-4m4 4l4-4M12 4v8" />
          </svg>
          {{ dragActive ? 'Suelta para subir archivo' : (field.label || 'Subir archivo') }}
          <span class="file-hint" v-if="field.hint">{{ field.hint }}</span>
          <input
            ref="field.name"
            type="file"
            :id="field.name"
            class="input-file"
            @change="handleFileUpload($event, field)"
            :accept="field.accept"
            :multiple="field.multiple"
            :aria-describedby="field.name + '-error'"
            :aria-invalid="errors[field.name] ? 'true' : 'false'"
            hidden
          />
        </label>

        <ul class="file-list" v-if="formData[field.name] && formData[field.name].length">
          <li v-for="(file, idx) in formData[field.name]" :key="file.name + idx" class="file-item">
            {{ file.name }} ({{ formatFileSize(file.size) }})
            <button type="button" @click="removeFile(field.name, idx)" aria-label="Eliminar archivo">
              <svg xmlns="http://www.w3.org/2000/svg" class="remove-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </li>
        </ul>
      </div>

      <!-- Error message -->
      <p v-if="errors[field.name]" :id="field.name + '-error'" class="error-message" role="alert">
        {{ errors[field.name] }}
      </p>
    </div>
</div>
    <div class="acciones">
        <button
            type="button"
            class="btn-cancel"
            @click="onCancel"
        >
            Cancelar
        </button>

        <button
            type="submit"
            class="btn-submit"
            :disabled="hasErrors"
            :aria-disabled="hasErrors"
        >
            {{ submitLabel }}
        </button>
    </div>

    
  </form>
</template>

<script setup>
import { reactive, watch, computed, ref } from 'vue'

const props = defineProps({
  config: { type: Array, required: true },
  modelValue: { type: Object, default: () => ({}) },
  submitLabel: { type: String, default: 'Enviar' }
})

const emit = defineEmits(['update:modelValue', 'submit'])

const formData = reactive({})
const errors = reactive({})
const dragActive = ref(false)

/* ------------------ Inicialización del formulario ------------------ */
const initFieldValue = (field) => {
  const modelVal = props.modelValue[field.name]

  if (modelVal !== undefined) {
    if (field.type === 'checkbox-json') return Array.isArray(modelVal) ? [...modelVal] : []
    if (field.type === 'file') return modelVal || []
    return modelVal
  }

  if (field.type === 'checkbox-json' || field.type === 'file') return []
  if (field.type === 'switch') return false
  return ''
}

watch(
  () => props.config,
  (newConfig) => {
    newConfig.forEach((field) => {
      formData[field.name] = initFieldValue(field)
      errors[field.name] = ''
    })
  },
  { immediate: true }
)

/* ------------------ Emisión reactiva de cambios ------------------ */
watch(
  formData,
  (newData) => emit('update:modelValue', { ...newData }),
  { deep: true }
)

/* ------------------ Validación ------------------ */
function validateField(field) {
  const val = formData[field.name]
  errors[field.name] = ''

  if (field.required) {
    const isEmpty = (
      (field.type === 'checkbox-json' || field.type === 'file') && (!val || val.length === 0)
    ) || (
      !['checkbox-json', 'file'].includes(field.type) && (val === '' || val === null || val === undefined)
    )

    if (isEmpty) {
      errors[field.name] = 'Este campo es obligatorio.'
      return false
    }
  }

  if (val === '' || val === null || val === undefined) return true

  if (field.type === 'email') {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(val)) {
      errors[field.name] = 'Por favor ingresa un correo válido.'
      return false
    }
  }

  if (field.type === 'number') {
    const num = Number(val)
    if (isNaN(num)) {
      errors[field.name] = 'Por favor ingresa un número válido.'
      return false
    }
    if (field.min !== undefined && num < field.min) {
      errors[field.name] = `El valor mínimo es ${field.min}.`
      return false
    }
    if (field.max !== undefined && num > field.max) {
      errors[field.name] = `El valor máximo es ${field.max}.`
      return false
    }
  }

  if (field.pattern && !(new RegExp(field.pattern).test(val))) {
    errors[field.name] = field.patternMessage || 'Formato inválido.'
    return false
  }

  if (typeof field.customValidate === 'function') {
    const customError = field.customValidate(val, formData)
    if (customError) {
      errors[field.name] = customError
      return false
    }
  }

  return true
}

const hasErrors = computed(() =>
  Object.values(errors).some((msg) => msg !== '')
)

/* ------------------ Archivos ------------------ */
function handleFileUpload(event, field) {
  dragActive.value = false
  const files = Array.from(event.target.files)

  formData[field.name] = field.multiple ? [...formData[field.name], ...files] : (files[0] ? [files[0]] : [])
  validateField(field)
}

function handleDrop(event, fieldName) {
  dragActive.value = false
  const field = props.config.find(f => f.name === fieldName)
  if (!field) return

  const files = Array.from(event.dataTransfer.files)
  formData[field.name] = field.multiple ? [...formData[field.name], ...files] : (files[0] ? [files[0]] : [])
  validateField(field)
}

function removeFile(fieldName, index) {
  formData[fieldName].splice(index, 1)
  const field = props.config.find(f => f.name === fieldName)
  if (field) validateField(field)
}

function formatFileSize(bytes) {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1048576) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / 1048576).toFixed(1)} MB`
}

/* ------------------ Envío ------------------ */
function validateAll() {
  return props.config.every(validateField)
}

function handleSubmit() {
  if (validateAll()) {
    emit('submit', { ...formData })
  } else {
    const firstError = props.config.find(f => errors[f.name])
    if (firstError) {
      const el = document.getElementById(firstError.name)
      if (el) el.focus()
    }
  }
}
</script>

<style scoped>
.form-container {
  margin: 2rem auto;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.form-fields{
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1rem;
  max-width: 800px;
  margin: auto;
}
.acciones {
  display: flex;
  justify-content: space-between;
  margin-top: 1.5rem;
    max-width: 800px;
  margin: auto;
  gap: 1rem;

}
.btn-cancel {
  background: #ccc;
  color: #333;
  border: none;
  border-radius: 6px;
  padding: 0.7rem 1.6rem;
  font-weight: 700;
  cursor: pointer;
  transition: background-color 0.3s ease;

  &:hover {
    background: #999;
  }

  &:active {
    background: #777;
  }
}

.form-group {
  position: relative;
  display: flex;
  flex-direction: column;
}

.input-wrapper {
  position: relative;
  margin-top: 1.5rem;
}

input[type="text"],
input[type="email"],
input[type="number"],
input[type="date"],
input[type="password"],
input[type="tel"],
input[type="url"],
input[type="datetime-local"],
textarea,
select {
  width: 100%;
  padding: 0.7rem 0.8rem;
  font-size: 1rem;
  border: 1.5px solid #aaa;
  border-radius: 5px;
  background-color: white;
  transition: border-color 0.3s;
}

input:focus,
textarea:focus,
select:focus {
  outline: none;
  border-color: #0077cc;
  box-shadow: 0 0 5px rgba(0, 119, 204, 0.5);
}

input.invalid,
textarea.invalid,
select.invalid {
  border-color: #e63946;
}

label {
  position: absolute;
  top: 0.5rem;
  left: 0.8rem;
  font-size: 0.9rem;
  color: #555;
  pointer-events: none;
  transition: 0.2s ease all;
  background-color: white;
  padding: 0 0.3rem;
}

input:not(:placeholder-shown) + label,
textarea:not(:placeholder-shown) + label,
select:not([value=""]) + label,
input:focus + label,
textarea:focus + label,
select:focus + label {
  top: -0.6rem;
  left: 0.6rem;
  font-size: 0.75rem;
  color: #0077cc;
  font-weight: 600;
}

.input-suffix {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  color: #666;
  font-size: 0.85rem;
  user-select: none;
}

select {
  appearance: none;
  background-image: url("data:image/svg+xml;charset=US-ASCII,%3csvg width='16' height='16' fill='none' stroke='%23777' stroke-width='2' stroke-linejoin='round' stroke-linecap='round' viewBox='0 0 24 24' xmlns='http://www.w3.org/2000/svg'%3e%3cpath d='M6 9l6 6 6-6'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 0.7rem center;
  background-size: 1rem;
  padding-right: 2rem;
}

.select-label {
  position: absolute;
  top: -0.6rem;
  left: 0.8rem;
  font-size: 0.75rem;
  color: #555;
  pointer-events: none;
  font-weight: 600;
}

.checkbox-list,
.radio-list {
  border: none;
  padding: 0;
  margin: 1rem 0;
}

.checkbox-label,
.radio-label {
  font-weight: 600;
  margin-bottom: 0.3rem;
}

.checkbox-item,
.radio-item {
  display: flex;
  align-items: center;
  margin-bottom: 0.3rem;
}

.checkbox-item input,
.radio-item input {
  margin-right: 0.5rem;
}

.switch-wrapper {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 1.2rem;
}

.switch-label {
  font-weight: 600;
  user-select: none;
}

.file-upload-wrapper {
  border: 2px dashed #ccc;
  border-radius: 8px;
  padding: 1rem;
  text-align: center;
  cursor: pointer;
  user-select: none;
  position: relative;
  transition: border-color 0.3s;
}

.file-upload-wrapper.drag-active {
  border-color: #0077cc;
  background-color: #f0f8ff;
}

.file-label {
  cursor: pointer;
  display: inline-block;
  font-weight: 600;
  color: #0077cc;
  user-select: none;
}

.upload-icon {
  width: 2rem;
  height: 2rem;
  margin-right: 0.5rem;
  vertical-align: middle;
  stroke: #0077cc;
}

.file-list {
  margin-top: 0.8rem;
  list-style: none;
  padding-left: 0;
  max-height: 150px;
  overflow-y: auto;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.file-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.9rem;
  padding: 0.3rem 0.5rem;
  border-bottom: 1px solid #eee;
}

.file-item:last-child {
  border-bottom: none;
}

.file-remove-btn {
  background: transparent;
  border: none;
  color: #e63946;
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  padding: 0;
  user-select: none;
}

.error-message {
  color: #e63946;
  font-size: 0.85rem;
  margin-top: 0.2rem;
  min-height: 1.2em;
}

.submit-button {
  margin-top: 1.5rem;
  padding: 0.75rem 1.5rem;
  font-weight: 700;
  background-color: #0077cc;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-button:disabled {
  background-color: #bbb;
  cursor: not-allowed;
}
</style>
