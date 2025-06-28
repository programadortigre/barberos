<template>
  <div class="usuarios">
    <h1>Gestión de Usuarios y Permisos</h1>

    <button @click="openCreateModal">Crear Usuario</button>
    <button @click="openCreatePermisoModal">Crear Permiso</button>

    <h2>Usuarios</h2>
    <table border="1" cellpadding="8" cellspacing="0">
      <thead>
        <tr>
          <th>Username</th>
          <th>Estado</th>
          <th>Rol</th>
          <th>Permisos del Rol</th>
          <th>Nombre Completo</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="usuario in usuarios" :key="usuario.id">
          <td>{{ usuario.username }}</td>
          <td>{{ usuario.estado }}</td>
          <td>{{ usuario.rol.nombre }}</td>
          <td>
            <ul>
              <li v-for="p in usuario.rol.permisos" :key="p.id">{{ p.nombre }}</li>
              <li v-if="usuario.rol.permisos.length === 0"><em>Sin permisos</em></li>
            </ul>
          </td>
          <td>{{ usuario.persona.nombres }} {{ usuario.persona.apellido_paterno }} {{ usuario.persona.apellido_materno }}</td>
          <td>
            <button @click="openEditModal(usuario)">Editar</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Modal Crear Usuario -->
    <div v-if="showCreateModal" class="modal-overlay" @click.self="closeCreateModal">
      <div class="modal">
        <h2>Crear Usuario</h2>
        <form @submit.prevent="createUser">
          <label>
            Username:
            <input v-model="form.username" required />
          </label>

          <label>
            Estado:
            <select v-model="form.estado">
              <option value="activo">Activo</option>
              <option value="inactivo">Inactivo</option>
            </select>
          </label>

          <label>
            Rol:
            <select v-model="form.rol_id" @change="onRolChange">
              <option v-for="rol in roles" :key="rol.id" :value="rol.id">{{ rol.nombre }}</option>
            </select>
          </label>

          <label>Permisos del Rol:</label>
          <div class="permisos-list">
            <label v-for="permiso in permisos" :key="permiso.id" style="display:block; margin-left: 15px;">
              <input
                type="checkbox"
                :value="permiso.id"
                v-model="form.rol_permisos_ids"
              />
              {{ permiso.nombre }}
            </label>
          </div>

          <label>
            Nombres:
            <input v-model="form.persona.nombres" required />
          </label>
          <label>
            Apellido Paterno:
            <input v-model="form.persona.apellido_paterno" required />
          </label>
          <label>
            Apellido Materno:
            <input v-model="form.persona.apellido_materno" />
          </label>

          <button type="submit">Guardar</button>
          <button type="button" @click="closeCreateModal">Cancelar</button>
        </form>
      </div>
    </div>

    <!-- Modal Editar Usuario -->
    <div v-if="showEditModal" class="modal-overlay" @click.self="closeEditModal">
      <div class="modal">
        <h2>Editar Usuario</h2>
        <form @submit.prevent="updateUser">
          <label>
            Username:
            <input v-model="form.username" required />
          </label>

          <label>
            Estado:
            <select v-model="form.estado">
              <option value="activo">Activo</option>
              <option value="inactivo">Inactivo</option>
            </select>
          </label>

          <label>
            Rol:
            <select v-model="form.rol_id" @change="onRolChange">
              <option v-for="rol in roles" :key="rol.id" :value="rol.id">{{ rol.nombre }}</option>
            </select>
          </label>

          <label>Permisos del Rol:</label>
          <div class="permisos-list">
            <label v-for="permiso in permisos" :key="permiso.id" style="display:block; margin-left: 15px;">
              <input
                type="checkbox"
                :value="permiso.id"
                v-model="form.rol_permisos_ids"
              />
              {{ permiso.nombre }}
            </label>
          </div>

          <label>
            Nombres:
            <input v-model="form.persona.nombres" required />
          </label>
          <label>
            Apellido Paterno:
            <input v-model="form.persona.apellido_paterno" required />
          </label>
          <label>
            Apellido Materno:
            <input v-model="form.persona.apellido_materno" />
          </label>

          <button type="submit">Actualizar</button>
          <button type="button" @click="closeEditModal">Cancelar</button>
        </form>
      </div>
    </div>

    <!-- Modal Crear Permiso -->
    <div v-if="showCreatePermisoModal" class="modal-overlay" @click.self="closeCreatePermisoModal">
      <div class="modal">
        <h2>Crear Permiso</h2>
        <form @submit.prevent="createPermiso">
          <label>
            Nombre del Permiso:
            <input v-model="newPermisoNombre" required />
          </label>
          <label>
            Descripción:
            <input v-model="newPermisoDescripcion" />
          </label>

          <button type="submit">Crear</button>
          <button type="button" @click="closeCreatePermisoModal">Cancelar</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
definePageMeta({ layout: 'admin' })

// Datos simulados para ejemplo
const permisos = ref([
  { id: 1, nombre: 'Crear usuario', descripcion: 'Permite crear usuarios' },
  { id: 2, nombre: 'Editar usuario', descripcion: 'Permite editar usuarios' },
  { id: 3, nombre: 'Eliminar usuario', descripcion: 'Permite eliminar usuarios' }
])

const roles = ref([
  {
    id: 7,
    nombre: "aaa",
    permisos: [permisos.value[0], permisos.value[1]] // tiene permisos 1 y 2
  },
  {
    id: 1,
    nombre: "Usuario",
    permisos: []
  },
  {
    id: 2,
    nombre: "Moderador",
    permisos: [permisos.value[2]]
  }
])

const usuarios = ref([
  {
    id: 7,
    username: "admin",
    estado: "activo",
    rol_id: 7,
    rol: roles.value.find(r => r.id === 7),
    persona: {
      nombres: "Admin",
      apellido_paterno: "Principal",
      apellido_materno: "Sistema"
    }
  }
])

const showCreateModal = ref(false)
const showEditModal = ref(false)
const showCreatePermisoModal = ref(false)

const form = reactive({
  id: null,
  username: "",
  estado: "activo",
  rol_id: null,
  rol_permisos_ids: [], // ids de permisos asignados al rol
  persona: {
    nombres: "",
    apellido_paterno: "",
    apellido_materno: ""
  }
})

const newPermisoNombre = ref("")
const newPermisoDescripcion = ref("")

function openCreateModal() {
  resetForm()
  showCreateModal.value = true
}

function closeCreateModal() {
  showCreateModal.value = false
}

function openEditModal(usuario) {
  form.id = usuario.id
  form.username = usuario.username
  form.estado = usuario.estado
  form.rol_id = usuario.rol_id
  form.persona.nombres = usuario.persona.nombres
  form.persona.apellido_paterno = usuario.persona.apellido_paterno
  form.persona.apellido_materno = usuario.persona.apellido_materno
  form.rol_permisos_ids = usuario.rol.permisos.map(p => p.id)
  showEditModal.value = true
}

function closeEditModal() {
  showEditModal.value = false
}

function resetForm() {
  form.id = null
  form.username = ""
  form.estado = "activo"
  form.rol_id = roles.value.length > 0 ? roles.value[0].id : null
  form.rol_permisos_ids = roles.value.length > 0 ? roles.value[0].permisos.map(p => p.id) : []
  form.persona.nombres = ""
  form.persona.apellido_paterno = ""
  form.persona.apellido_materno = ""
}

function createUser() {
  // Aquí llamarías a la API para crear usuario
  const rolSeleccionado = roles.value.find(r => r.id === form.rol_id)
  const permisosAsignados = permisos.value.filter(p => form.rol_permisos_ids.includes(p.id))

  const nuevoUsuario = {
    id: Date.now(), // Simular ID
    username: form.username,
    estado: form.estado,
    rol_id: form.rol_id,
    rol: {
      ...rolSeleccionado,
      permisos: permisosAsignados
    },
    persona: { ...form.persona }
  }
  usuarios.value.push(nuevoUsuario)
  closeCreateModal()
}

function updateUser() {
  const index = usuarios.value.findIndex(u => u.id === form.id)
  if (index !== -1) {
    const rolSeleccionado = roles.value.find(r => r.id === form.rol_id)
    const permisosAsignados = permisos.value.filter(p => form.rol_permisos_ids.includes(p.id))
    usuarios.value[index] = {
      id: form.id,
      username: form.username,
      estado: form.estado,
      rol_id: form.rol_id,
      rol: {
        ...rolSeleccionado,
        permisos: permisosAsignados
      },
      persona: { ...form.persona }
    }
  }
  closeEditModal()
}

function onRolChange() {
  // Cuando cambias el rol en el formulario, actualizamos los permisos asignados a los que tiene ese rol
  const rol = roles.value.find(r => r.id === form.rol_id)
  if (rol) {
    form.rol_permisos_ids = rol.permisos.map(p => p.id)
  } else {
    form.rol_permisos_ids = []
  }
}

function openCreatePermisoModal() {
  newPermisoNombre.value = ""
  newPermisoDescripcion.value = ""
  showCreatePermisoModal.value = true
}

function closeCreatePermisoModal() {
  showCreatePermisoModal.value = false
}

function createPermiso() {
  if (!newPermisoNombre.value.trim()) return

  const nuevoPermiso = {
    id: Date.now(),
    nombre: newPermisoNombre.value.trim(),
    descripcion: newPermisoDescripcion.value.trim()
  }
  permisos.value.push(nuevoPermiso)
  // Por simplicidad, agregamos el permiso nuevo a todos los roles con permisos vacíos
  // O podrías decidir no asignarlo automáticamente
  roles.value.forEach(rol => {
    if (!rol.permisos.find(p => p.id === nuevoPermiso.id)) {
      rol.permisos.push(nuevoPermiso)
    }
  })
  closeCreatePermisoModal()
}

resetForm()
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.3);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10;
}
.modal {
  background: white;
  padding: 20px;
  border-radius: 6px;
  width: 400px;
  max-width: 90%;
}
label {
  display: block;
  margin: 10px 0;
}
.permisos-list {
  max-height: 120px;
  overflow-y: auto;
  border: 1px solid #ccc;
  padding: 5px;
}
button {
  margin-right: 10px;
}
</style>
