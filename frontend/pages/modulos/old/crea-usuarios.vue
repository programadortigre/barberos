<template>
  <div>
    <h2>Crear Usuario</h2>
    <FormularioUniversal
      :config="formConfig"
      :modelValue="userData"
      submitLabel="Crear Usuario"
      @update:modelValue="val => userData = val"
      @submit="handleSubmit"
    />
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import FormularioUniversal from '~/components/FormularioUniversal.vue'

const roles = [
  { value: 'admin', label: 'Administrador' },
  { value: 'editor', label: 'Editor' },
  { value: 'user', label: 'Usuario' }
]

const userData = reactive({})

const formConfig = [
  {
    name: 'fullName',
    label: 'Nombre Completo',
    type: 'text',
    required: true,
    placeholder: 'Ingresa nombre completo',
    errorMessage: 'El nombre es obligatorio y debe tener al menos 3 caracteres',
    pattern: '^.{3,}$'
  },
  {
    name: 'email',
    label: 'Correo Electrónico',
    type: 'email',
    required: true,
    placeholder: 'usuario@ejemplo.com'
  },
  {
    name: 'phone',
    label: 'Teléfono',
    type: 'tel',
    placeholder: '+51 999 999 999',
    pattern: '^\\+?\\d{7,15}$',
    errorMessage: 'Número de teléfono inválido'
  },
  {
    name: 'username',
    label: 'Nombre de Usuario',
    type: 'text',
    required: true,
    placeholder: 'Nombre de usuario',
    pattern: '^[a-zA-Z0-9_-]{3,15}$',
    errorMessage: 'Solo letras, números, guion y guion bajo, 3-15 caracteres'
  },
  {
    name: 'password',
    label: 'Contraseña',
    type: 'password',
    required: true,
    placeholder: 'Ingresa contraseña',
    pattern: '^.{6,}$',
    errorMessage: 'La contraseña debe tener al menos 6 caracteres'
  },
  {
    name: 'passwordConfirm',
    label: 'Confirmar Contraseña',
    type: 'password',
    required: true,
    placeholder: 'Repite la contraseña'
  },
  {
    name: 'role',
    label: 'Rol',
    type: 'select',
    options: roles,
    required: true,
    placeholder: '-- Seleccione un rol --'
  },
  {
    name: 'active',
    label: 'Usuario Activo',
    type: 'switch',
    required: false
  },
  {
    name: 'bio',
    label: 'Biografía corta',
    type: 'textarea',
    placeholder: 'Cuéntanos algo sobre el usuario',
    required: false,
    rows: 4
  }
]

const handleSubmit = (data) => {
  // Validación extra: confirmar que password y passwordConfirm coincidan
  if (data.password !== data.passwordConfirm) {
    alert('Las contraseñas no coinciden.')
    return
  }
  
  // Aquí mandarías a backend por API, ejemplo:
  console.log('Datos para enviar:', data)
  alert('Usuario creado correctamente!')
}
</script>
