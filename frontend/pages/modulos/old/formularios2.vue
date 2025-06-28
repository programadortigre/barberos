<script setup>
const config = useRuntimeConfig()
const apiBase = config.public.apiBaseUrl

const form = reactive({
  tipo_documento: '',
  dni: '',
  nombres: '',
  apellido_paterno: '',
  apellido_materno: '',
  fecha_nacimiento: '',
  genero: '',
  direccion_cifrada: '',
  telefono_cifrado: '',
  correo_cifrado: '',
  username: '',
  password: '',
  rol_id: null,
  tipo_perfil_id: null
})

const roles = ref([])
const tiposPerfil = ref([])

onMounted(async () => {
  try {
    roles.value = await $fetch(`${apiBase}/roles`)
    tiposPerfil.value = await $fetch(`${apiBase}/tipos_perfil`)
  } catch (err) {
    console.error('Error cargando datos iniciales:', err)
  }
})

const submit = async () => {
  try {
    console.log('Enviando datos persona:', {
      tipo_documento: form.tipo_documento,
      dni: form.dni,
      nombres: form.nombres,
      apellido_paterno: form.apellido_paterno,
      apellido_materno: form.apellido_materno,
      fecha_nacimiento: form.fecha_nacimiento,
      genero: form.genero,
      direccion_cifrada: form.direccion_cifrada,
      telefono_cifrado: form.telefono_cifrado,
      correo_cifrado: form.correo_cifrado
    })

    // 1. Crear persona
    const persona = await $fetch(`${apiBase}/personas`, {
      method: 'POST',
      body: {
        tipo_documento: form.tipo_documento,
        dni: form.dni,
        nombres: form.nombres,
        apellido_paterno: form.apellido_paterno,
        apellido_materno: form.apellido_materno,
        fecha_nacimiento: form.fecha_nacimiento,
        genero: form.genero,
        direccion_cifrada: form.direccion_cifrada,
        telefono_cifrado: form.telefono_cifrado,
        correo_cifrado: form.correo_cifrado
      }
    })
    console.log('Persona creada:', persona)

    const personaId = persona.id

    console.log('Enviando datos usuario:', {
      username: form.username,
      password: form.password,
      estado: 'activo',
      persona_id: personaId,
      rol_id: form.rol_id
    })

    // 2. Crear usuario
    const usuario = await $fetch(`${apiBase}/usuarios`, {
      method: 'POST',
      body: {
        username: form.username,
        password: form.password,
        estado: 'activo',
        persona_id: personaId,
        rol_id: form.rol_id
      }
    })
    console.log('Usuario creado:', usuario)

    const usuarioId = usuario.id

    console.log('Enviando datos perfil:', {
      persona_id: personaId,
      tipo_perfil_id: form.tipo_perfil_id,
      datos_personalizados_json: '{}'
    })

    // 3. Crear perfil
    const perfil = await $fetch(`${apiBase}/perfiles`, {
      method: 'POST',
      body: {
        persona_id: personaId,
        tipo_perfil_id: form.tipo_perfil_id,
        datos_personalizados_json: '{}'
      }
    })
    console.log('Perfil creado:', perfil)

    alert('¡Usuario creado con éxito! 🎉')
  } catch (err) {
    // Mostrar error detallado del backend si existe
    if (err?.data) {
      console.error('Error detalle backend:', err.data)
      alert(`Error creando usuario: ${JSON.stringify(err.data)}`)
    } else {
      console.error('Error creando usuario:', err)
      alert('Error al crear usuario 😢')
    }
  }
}
</script>

<template>
  <form @submit.prevent="submit" class="p-4 bg-white rounded shadow space-y-4">
    <h2 class="text-xl font-bold">Crear usuario completo</h2>

    <!-- Datos persona -->
    <input v-model="form.tipo_documento" placeholder="Tipo Documento" class="input" />
    <input v-model="form.dni" placeholder="DNI" class="input" />
    <input v-model="form.nombres" placeholder="Nombres" class="input" />
    <input v-model="form.apellido_paterno" placeholder="Apellido Paterno" class="input" />
    <input v-model="form.apellido_materno" placeholder="Apellido Materno" class="input" />
    <input v-model="form.fecha_nacimiento" type="date" class="input" />
    <input v-model="form.genero" placeholder="Género" class="input" />
    <input v-model="form.direccion_cifrada" placeholder="Dirección" class="input" />
    <input v-model="form.telefono_cifrado" placeholder="Teléfono" class="input" />
    <input v-model="form.correo_cifrado" placeholder="Correo" class="input" />

    <!-- Datos usuario -->
    <input v-model="form.username" placeholder="Username" class="input" />
    <input v-model="form.password" placeholder="Contraseña" type="password" class="input" />

    <!-- Rol y tipo perfil -->
    <select v-model="form.rol_id" class="input">
      <option disabled value="">Selecciona un rol</option>
      <option v-for="rol in roles" :key="rol.id" :value="rol.id">{{ rol.nombre }}</option>
    </select>

    <select v-model="form.tipo_perfil_id" class="input">
      <option disabled value="">Selecciona un tipo de perfil</option>
      <option v-for="tipo in tiposPerfil" :key="tipo.id" :value="tipo.id">{{ tipo.nombre }}</option>
    </select>

    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Crear usuario</button>
  </form>
</template>

<style scoped>
.input {
  display: block;
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 8px;
}
</style>
