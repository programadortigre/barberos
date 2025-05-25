<script setup>
definePageMeta({ layout: 'admin' })

const columnas = [
  { key: 'dni', label: 'DNI' },
  { key: 'nombres', label: 'Nombres' },
  { key: 'apellido_paterno', label: 'Apellido Paterno' },
]

const camposFormulario = [
  { key: 'tipo_documento', label: 'Tipo de Documento', type: 'text' },
  { key: 'dni', label: 'DNI', type: 'text' },
  { key: 'nombres', label: 'Nombres', type: 'text' },
  { key: 'apellido_paterno', label: 'Apellido Paterno', type: 'text' },
  { key: 'apellido_materno', label: 'Apellido Materno', type: 'text' },
  { key: 'fecha_nacimiento', label: 'Fecha de Nacimiento', type: 'date' },
  {
    key: 'genero',
    label: 'Género',
    type: 'select',
    options: [
      { label: 'Otro', value: 'O' },
      { label: 'Masculino', value: 'M' },
      { label: 'Femenino', value: 'F' }
    ]
  },
  { key: 'direccion_cifrada', label: 'Dirección (Texto plano)', type: 'text' },
  { key: 'telefono_cifrado', label: 'Teléfono (Texto plano)', type: 'text' },
  { key: 'correo_cifrado', label: 'Correo (Texto plano)', type: 'email' }
]


</script>

<template>
  <CrudTable
    endpoint="personas"
    :columnas="columnas"
    :camposFormulario="camposFormulario"
    :encodeFields="['direccion_cifrada', 'telefono_cifrado', 'correo_cifrado']"
  />
</template>
