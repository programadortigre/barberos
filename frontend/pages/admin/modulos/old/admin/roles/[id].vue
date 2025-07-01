<template>
  <div v-if="rol">
    <h2>Editar Rol</h2>
    <form @submit.prevent="actualizar">
      <label>
        Nombre:
        <input v-model="rol.nombre" required />
      </label>
      <label>
        Descripción:
        <input v-model="rol.descripcion" required />
      </label>

      <fieldset>
        <legend>Permisos</legend>
        <div v-for="permiso in permisos" :key="permiso.id">
          <input
            type="checkbox"
            :value="permiso.id"
            v-model="permisosSeleccionados"
            :id="'permiso-' + permiso.id"
          />
          <label :for="'permiso-' + permiso.id">{{ permiso.nombre }}</label>
        </div>
      </fieldset>

      <button type="submit">Actualizar</button>
      <button type="button" @click="eliminar">Eliminar</button>
    </form>
  </div>
  <div v-else>
    <p>Cargando rol...</p>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();

const id = Number(route.params.id);

const rol = ref<{ nombre: string; descripcion: string; permisos: any[] } | null>(null);
const permisos = ref<Array<{ id: number; nombre: string; clave: string; descripcion: string }>>([]);
const permisosSeleccionados = ref<number[]>([]);

const cargarRol = async () => {
  try {
    const res = await $fetch(`/roles/${id}`);
    rol.value = {
      nombre: res.nombre,
      descripcion: res.descripcion,
      permisos: Array.isArray(res.permisos) ? res.permisos : []
    };
    permisosSeleccionados.value = rol.value.permisos.map(p => p.id);
  } catch (error) {
    alert('Error cargando el rol');
  }
};

const cargarPermisos = async () => {
  try {
    permisos.value = await $fetch('http://localhost:8000/permisos');
  } catch (error) {
    alert('Error cargando permisos');
  }
};

onMounted(async () => {
  await Promise.all([cargarPermisos(), cargarRol()]);
});

const actualizar = async () => {
  if (!rol.value) return;

  try {
    const permisosPayload = permisos.value.filter(p => permisosSeleccionados.value.includes(p.id));

    const payload = {
      nombre: rol.value.nombre,
      descripcion: rol.value.descripcion,
      permisos: permisosPayload
    };

    await $fetch(`/roles/${id}`, {
      method: 'PUT',
      body: payload
    });

    router.push('/roles');
  } catch (error) {
    alert('Error al actualizar el rol: ' + error);
  }
};

const eliminar = async () => {
  if (confirm('¿Seguro que deseas eliminar este rol?')) {
    try {
      await $fetch(`/roles/${id}`, {
        method: 'DELETE'
      });
      router.push('/roles');
    } catch (error) {
      alert('Error al eliminar el rol: ' + error);
    }
  }
};
</script>
