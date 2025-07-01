<template>
  <form @submit.prevent="crear">
    <label>Nombre: <input v-model="nombre" required /></label>
    <label>Descripción: <input v-model="descripcion" required /></label>
    <button type="submit">Crear</button>
  </form>
</template>

<script setup lang="ts">
const nombre = ref('');
const descripcion = ref('');
const router = useRouter();
const { crearRol } = useRoles();

const crear = async () => {
  const { error } = await crearRol({ nombre: nombre.value, descripcion: descripcion.value });
  if (!error.value) {
    router.push('/roles');
  } else {
    alert('Error al crear rol');
  }
};
</script>
