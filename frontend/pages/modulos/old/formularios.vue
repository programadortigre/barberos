<script setup>
import FormularioUniversal from '~/components/FormularioUniversal.vue'
import { ref } from 'vue'

const formData = ref({})

const campos = [
  {
    name: 'nombre',
    label: 'Nombre completo',
    type: 'text',
    required: true,
    placeholder: 'Ingresa tu nombre',
  },
  {
    name: 'email',
    label: 'Correo electrónico',
    type: 'email',
    required: true,
    placeholder: 'ejemplo@correo.com'
  },
  {
    name: 'descripcion',
    label: 'Descripción',
    type: 'textarea',
    required: false,
    rows: 5
  },
  {
    name: 'genero',
    label: 'Género',
    type: 'radio',
    required: true,
    options: [
      { value: 'm', label: 'Masculino' },
      { value: 'f', label: 'Femenino' },
      { value: 'o', label: 'Otro' }
    ]
  },
  {
    name: 'hobbies',
    label: 'Hobbies',
    type: 'checkbox-json',
    options: [
      { value: 'leer', label: 'Leer' },
      { value: 'deporte', label: 'Deporte' },
      { value: 'cine', label: 'Cine' }
    ]
  },
  {
    name: 'avatar',
    label: 'Foto de perfil',
    type: 'file',
    accept: 'image/*',
    multiple: false,
    required: true,
    hint: 'Formatos: jpg, png. Max 2MB'
  },
  {
    name: 'newsletter',
    label: 'Suscribirme al newsletter',
    type: 'switch'
  }
]


const enviarFormulario = (data) => {
  console.log('Datos enviados:', data)
}
</script>

<template>
  <FormularioUniversal
    v-model="formData"
    :config="campos"
    submit-label="Guardar Usuario"
    @submit="enviarFormulario"
  />
</template>
