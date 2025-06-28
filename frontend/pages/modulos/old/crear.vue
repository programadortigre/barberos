<template>
  <div class="max-w-2xl mx-auto p-6 bg-white rounded-xl shadow-md">
    <h2 class="text-2xl font-semibold mb-4">Crear Usuario</h2>

    <form @submit.prevent="handleSubmit">
      <!-- Datos personales -->
      <div class="grid grid-cols-2 gap-4 mb-4">
        <input v-model="form.dni" type="text" placeholder="DNI" class="input" />
        <input v-model="form.nombres" type="text" placeholder="Nombres" class="input" />
        <input v-model="form.apellido_paterno" type="text" placeholder="Apellido Paterno" class="input" />
        <input v-model="form.apellido_materno" type="text" placeholder="Apellido Materno" class="input" />
        <input v-model="form.fecha_nacimiento" type="date" class="input" />
        <select v-model="form.genero" class="input">
          <option value="M">Masculino</option>
          <option value="F">Femenino</option>
        </select>
      </div>

      <!-- Datos de usuario -->
      <div class="grid grid-cols-2 gap-4 mb-4">
        <input v-model="form.username" type="text" placeholder="Nombre de usuario" class="input" />
        <input v-model="form.password" type="password" placeholder="Contraseña" class="input" />
      </div>

      <!-- Selección de rol -->
      <div class="mb-4">
        <label class="block font-medium mb-1">Rol:</label>
        <select v-model="form.rol_id" class="input">
          <option disabled value="">Selecciona un rol</option>
          <option v-for="rol in roles" :key="rol.id" :value="rol.id">
            {{ rol.nombre }}
          </option>
        </select>
      </div>

      <!-- Permisos del rol seleccionado -->
      <div v-if="rolSeleccionado" class="mb-4">
        <label class="block font-medium mb-1">Permisos del rol:</label>
        <ul class="list-disc ml-5 text-sm">
          <li v-for="permiso in rolSeleccionado.permisos" :key="permiso.id">
            {{ permiso.nombre }} ({{ permiso.clave }})
          </li>
        </ul>
      </div>

      <!-- Botón -->
      <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
        Crear Usuario
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useFetch, useRuntimeConfig } from '#app'

const config = useRuntimeConfig()

const form = ref({
  dni: '',
  nombres: '',
  apellido_paterno: '',
  apellido_materno: '',
  fecha_nacimiento: '',
  genero: 'M',
  username: '',
  password: '',
  rol_id: ''
})

const roles = ref([])

const fetchRoles = async () => {
  const { data, error } = await useFetch(`${config.public.apiBaseUrl}/roles`)
  if (error.value) {
    console.error('❌ Error al obtener roles:', error.value)
  } else {
    roles.value = data.value || []
    console.log('✅ Roles cargados:', roles.value)
  }
}

const rolSeleccionado = computed(() =>
  roles.value.find((rol) => rol.id === Number(form.value.rol_id))
)

const handleSubmit = async () => {
  const payload = {
    persona: {
      dni: form.value.dni,
      nombres: form.value.nombres,
      apellido_paterno: form.value.apellido_paterno,
      apellido_materno: form.value.apellido_materno,
      fecha_nacimiento: form.value.fecha_nacimiento,
      genero: form.value.genero
    },
    usuario: {
      username: form.value.username,
      password: form.value.password,
      rol_id: Number(form.value.rol_id)
    }
  }

  const { error } = await useFetch(`${config.public.apiBaseUrl}/usuarios`, {
    method: 'POST',
    body: payload
  })

  if (error.value) {
    alert('❌ Error al crear usuario')
    console.error(error.value)
  } else {
    alert('✅ Usuario creado con éxito')
    form.value = {
      dni: '',
      nombres: '',
      apellido_paterno: '',
      apellido_materno: '',
      fecha_nacimiento: '',
      genero: 'M',
      username: '',
      password: '',
      rol_id: ''
    }
  }
}

onMounted(fetchRoles)
</script>

<style scoped>
.input {
  @apply w-full p-2 border border-gray-300 rounded;
}
</style>
