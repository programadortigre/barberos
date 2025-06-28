<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useCrud } from '@/composables/useCrudv2'
definePageMeta({ layout: 'admin' })

const showPassword = ref(false)
const password = ref('')

type Usuario = {
  id: number
  username: string
  estado: string
  persona_id: number
  rol_id: number
  password?: string
}

const {
  items: usuarios,
  create,
  fetchAll,
  update,
  remove,
  loading,
  error
} = useCrud<Usuario>('usuarios')

const { items: personas, fetchAll: fetchPersonas } = useCrud<any>('personas')
const { items: roles, fetchAll: fetchRoles } = useCrud<any>('roles')

const form = ref<Partial<Usuario>>({
  username: '',
  estado: 'activo',
  password: '',
  persona_id: 1,
  rol_id: 1
})

const editingId = ref<number | null>(null)

onMounted(() => {
  fetchAll()
  fetchPersonas()
  fetchRoles()
})

function cleanForm() {
  form.value = {
    username: '',
    estado: 'activo',
    password: '',
    persona_id: 1,
    rol_id: 1
  }
  editingId.value = null
}

async function save() {
  const payload = { ...form.value }

if (editingId.value) {
  if (!payload.password) {
    delete payload.password // Solo si está vacía, no la envíes
  }
  await update(editingId.value, payload)
}


  cleanForm()
}

function edit(usuario: Usuario) {
  editingId.value = usuario.id
  form.value = {
    ...usuario,
    password: ''  // siempre vacío
    //password: 'a'
  }
}
</script>

<template>
  <div class="p-4 max-w-3xl mx-auto space-y-6">
    <h2 class="text-xl font-bold">Gestión de Usuarios</h2>

    <form @submit.prevent="save" class="grid grid-cols-2 gap-4">
      <input v-model="form.username" placeholder="Usuario" required />
    <select v-model="form.estado">
      <option value="activo">Activo</option>
      <option value="suspendido">Suspendido</option> <!-- ❌ Este valor no existe en tu Enum -->
      <option value="eliminado">Eliminado</option> <!-- ❌ Este valor no existe en tu Enum -->
    </select>

      <input
        v-model="form.password"
        :type="showPassword ? 'text' : 'password'"
        placeholder="Dejar vacío para mantener la contraseña"
      />

      <select v-model.number="form.persona_id" required>
        <option disabled value="">Selecciona persona</option>
        <option
          v-for="p in personas"
          :key="p.id"
          :value="p.id"
        >
          {{ p.nombres }} {{ p.apellido_paterno }}
        </option>
      </select>

      <select v-model.number="form.rol_id" required>
        <option disabled value="">Selecciona rol</option>
        <option
          v-for="r in roles"
          :key="r.id"
          :value="r.id"
        >
          {{ r.nombre }}
        </option>
      </select>

      <button type="submit" class="col-span-2 bg-blue-600 text-white py-2 rounded">
        {{ editingId ? 'Actualizar' : 'Crear' }}
      </button>
    </form>

    <div v-if="error" class="text-red-600">{{ error }}</div>

    <table class="w-full mt-4 border text-sm">
      <thead>
        <tr class="bg-gray-100">
          <th>Usuario</th>
          <th>Estado</th>
          <th>Persona</th>
          <th>Rol</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="usuario in usuarios" :key="usuario.id">
          <td>{{ usuario.username }}</td>
          <td>{{ usuario.estado }}</td>
          <td>{{ usuario.persona_id }}</td>
          <td>{{ usuario.rol_id }}</td>
          <td>
            <button @click="edit(usuario)" class="text-blue-600 mr-2">Editar</button>
            <button @click="remove(usuario.id)" class="text-red-600">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
