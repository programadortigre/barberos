<script setup>
const config = useRuntimeConfig()
const nombre = ref('')
const descripcion = ref('')
const mensaje = ref('')

const crearRol = async () => {
  const { data, error } = await useFetch(`${config.public.apiBaseUrl}/roles`, {
    method: 'POST',
    body: {
      nombre: nombre.value,
      descripcion: descripcion.value
    }
  })
  mensaje.value = error.value ? 'Error al crear rol' : 'Rol creado correctamente'
}
</script>

<template>
  <form @submit.prevent="crearRol">
    <input v-model="nombre" placeholder="Nombre" />
    <input v-model="descripcion" placeholder="Descripción" />
    <button type="submit">Crear Rol</button>
    <p>{{ mensaje }}</p>
  </form>
</template>
