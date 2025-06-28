<script setup>
import { ref, onMounted, computed } from 'vue'
import FormularioUniversal from '~/components/FormularioUniversal.vue'

const config = useRuntimeConfig()
const apiBase = config.public.apiBaseUrl

const formData = ref({})
const roles = ref([])
const tiposPerfil = ref([])

onMounted(async () => {
  try {
    roles.value = await $fetch(`${apiBase}/roles`)
    tiposPerfil.value = await $fetch(`${apiBase}/tipos_perfil`)
  } catch (err) {
    console.error('Error cargando roles y tipos de perfil:', err)
  }
})

const campos = computed(() => [
  { name: 'tipo_documento', label: 'Tipo de documento', type: 'text', required: true },
  { name: 'dni', label: 'DNI', type: 'text', required: true },
  { name: 'nombres', label: 'Nombres', type: 'text', required: true },
  { name: 'apellido_paterno', label: 'Apellido paterno', type: 'text', required: true },
  { name: 'apellido_materno', label: 'Apellido materno', type: 'text', required: true },
  { name: 'fecha_nacimiento', label: 'Fecha de nacimiento', type: 'date', required: true },
  {
    name: 'genero',
    label: 'Género',
    type: 'radio',
    options: [
      { value: 'M', label: 'Masculino' },
      { value: 'F', label: 'Femenino' },
      { value: 'O', label: 'Otro' }
    ],
    required: true
  },
  { name: 'direccion_cifrada', label: 'Dirección', type: 'text' },
  { name: 'telefono_cifrado', label: 'Teléfono', type: 'text' },
  { name: 'correo_cifrado', label: 'Correo electrónico', type: 'email' },
  { name: 'username', label: 'Usuario', type: 'text', required: true },
  { name: 'password', label: 'Contraseña', type: 'password', required: true },
  {
    name: 'rol_id',
    label: 'Rol',
    type: 'select',
    required: true,
    options: roles.value.map(rol => ({ value: rol.id, label: rol.nombre }))
  },
  {
    name: 'tipo_perfil_id',
    label: 'Tipo de perfil',
    type: 'select',
    required: true,
    options: tiposPerfil.value.map(tp => ({ value: tp.id, label: tp.nombre }))
  }
])

const enviarFormulario = async (data) => {
  try {
    const persona = await $fetch(`${apiBase}/personas`, {
      method: 'POST',
      body: {
        tipo_documento: data.tipo_documento,
        dni: data.dni,
        nombres: data.nombres,
        apellido_paterno: data.apellido_paterno,
        apellido_materno: data.apellido_materno,
        fecha_nacimiento: data.fecha_nacimiento,
        genero: data.genero,
        direccion_cifrada: data.direccion_cifrada,
        telefono_cifrado: data.telefono_cifrado,
        correo_cifrado: data.correo_cifrado
      }
    })

    const personaId = persona.id

    await $fetch(`${apiBase}/usuarios`, {
      method: 'POST',
      body: {
        username: data.username,
        password: data.password,
        estado: 'activo',
        persona_id: personaId,
        rol_id: data.rol_id
      }
    })

    await $fetch(`${apiBase}/perfiles`, {
      method: 'POST',
      body: {
        persona_id: personaId,
        tipo_perfil_id: data.tipo_perfil_id,
        datos_personalizados_json: '{}'
      }
    })

    alert('¡Usuario creado con éxito! 🎉')
    formData.value = {}
  } catch (err) {
    console.error('Error creando usuario completo:', err)
    alert('Ocurrió un error creando el usuario.')
  }
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
