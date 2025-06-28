<script setup lang="ts">
definePageMeta({ layout: 'admin' })

import { ref, onMounted } from 'vue'
import { useCrud } from '@/composables/useCrudv2'
import { toBase64 } from '@/utils/base64'

type Persona = {
  id: number
  tipo_documento: string
  dni: string
  nombres: string
  apellido_paterno: string
  apellido_materno?: string
  fecha_nacimiento: string
  genero: string
  direccion_cifrada?: string
  telefono_cifrado?: string
  correo_cifrado?: string
}

const {
  items: personas,
  create,
  fetchAll,
  remove,
  update,
  loading,
  error
} = useCrud<Persona>('personas')

const form = ref<Partial<Persona>>({
  tipo_documento: '',
  dni: '',
  nombres: '',
  apellido_paterno: '',
  apellido_materno: '',
  fecha_nacimiento: '',
  genero: 'O',
  direccion_cifrada: '',
  telefono_cifrado: '',
  correo_cifrado: ''
})

const editingId = ref<number | null>(null)

onMounted(fetchAll)

function cleanForm() {
  form.value = {
    tipo_documento: '',
    dni: '',
    nombres: '',
    apellido_paterno: '',
    apellido_materno: '',
    fecha_nacimiento: '',
    genero: 'O',
    direccion_cifrada: '',
    telefono_cifrado: '',
    correo_cifrado: ''
  }
  editingId.value = null
}

async function save() {
  const payload = {
    ...form.value,
    direccion_cifrada: toBase64(form.value.direccion_cifrada || ''),
    telefono_cifrado: toBase64(form.value.telefono_cifrado || ''),
    correo_cifrado: toBase64(form.value.correo_cifrado || '')
  }

  if (editingId.value) {
    await update(editingId.value, payload)
  } else {
    await create(payload)
  }

  cleanForm()
}

function edit(persona: Persona) {
  editingId.value = persona.id
  form.value = { ...persona }
}
</script>

<template>
  <div class="p-4 max-w-3xl mx-auto space-y-6">
    <form @submit.prevent="save" class="grid grid-cols-2 gap-4">
      <input v-model="form.tipo_documento" placeholder="Tipo documento" required />
      <input v-model="form.dni" placeholder="DNI" required />
      <input v-model="form.nombres" placeholder="Nombres" required />
      <input v-model="form.apellido_paterno" placeholder="Apellido Paterno" required />
      <input v-model="form.apellido_materno" placeholder="Apellido Materno" />
      <input v-model="form.fecha_nacimiento" type="date" required />
      <select v-model="form.genero">
        <option value="O">Otro</option>
        <option value="M">Masculino</option>
        <option value="F">Femenino</option>
      </select>
      <input v-model="form.direccion_cifrada" placeholder="Dirección (texto plano)" />
      <input v-model="form.telefono_cifrado" placeholder="Teléfono (texto plano)" />
      <input v-model="form.correo_cifrado" placeholder="Correo (texto plano)" />
      <button type="submit" class="col-span-2 bg-green-600 text-white py-2 rounded">
        {{ editingId ? 'Actualizar' : 'Crear' }}
      </button>
    </form>

    <div v-if="error" class="text-red-600">{{ error }}</div>

    <table class="w-full mt-4 border text-sm">
      <thead>
        <tr class="bg-gray-100">
          <th>DNI</th>
          <th>Nombre</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="persona in personas" :key="persona.id">
          <td>{{ persona.dni }}</td>
          <td>{{ persona.nombres }} {{ persona.apellido_paterno }}</td>
          <td>
            <button @click="edit(persona)" class="text-blue-600 mr-2">Editar</button>
            <button @click="remove(persona.id)" class="text-red-600">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
