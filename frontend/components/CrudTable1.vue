<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useCrud } from '@/composables/useCrud'

const props = defineProps<{
  endpoint: string
  columnas: { key: string; label: string }[]
  camposFormulario: {
    key: string
    label: string
    type?: string
    options?: { label: string; value: any }[]
    relatedKey?: string
  }[]
  relatedData?: Record<string, any[]>
  relaciones?: {
    key: string
    recurso: string
    label: string | ((item: any) => string)
  }[]
}>()

const {
  items,
  form,
  mensaje,
  error,
  loading,
  guardar,
  eliminar,
  editar,
  limpiar,
  cargar
} = useCrud(props.endpoint)

const mostrarModal = ref(false)
const relacionesData = ref<Record<string, any[]>>({})

// Método para obtener el valor a mostrar en las celdas
const getDisplayValue = (item: any, key: string) => {
  try {
    const relacion = props.relaciones?.find(r => r.key === key)
    
    if (relacion) {
      const datosRelacionados = relacionesData.value[key]
      const valorId = item[key]
      
      if (!datosRelacionados || valorId == null) return '-'
      
      const itemRelacionado = datosRelacionados.find(d => d.id === valorId)
      if (!itemRelacionado) return '-'
      
      return typeof relacion.label === 'function'
        ? relacion.label(itemRelacionado)
        : itemRelacionado[relacion.label]
    }
    
    return item[key] ?? '-'
  } catch (e) {
    console.error('Error al obtener valor:', e)
    return '-'
  }
}

// Acciones modales
const abrirModalParaCrear = () => {
  limpiar()
  mostrarModal.value = true
  error.value = null
}

const abrirModalParaEditar = (item: Record<string, any>) => {
  editar(item)
  mostrarModal.value = true
  error.value = null
}

const onGuardar = async () => {
  const exito = await guardar()
  if (exito) {
    mostrarModal.value = false
    limpiar()
    await cargar()
  }
}

// Carga inicial
onMounted(async () => {
  await cargar()

  // Cargar datos relacionados
  if (props.relaciones?.length) {
    for (const relacion of props.relaciones) {
      const { items: relatedItems, fetchAll } = useCrud<any>(relacion.recurso)
      await fetchAll()
      
      // Almacenar datos de relación
      relacionesData.value[relacion.key] = relatedItems.value
      
      // Actualizar opciones del campo correspondiente
      const campoFormulario = props.camposFormulario.find(f => f.key === relacion.key)
      if (campoFormulario) {
        campoFormulario.options = relatedItems.value.map(item => ({
          label: typeof relacion.label === 'function' 
            ? relacion.label(item) 
            : item[relacion.label],
          value: item.id
        }))
      }
    }
  }
})
</script>

<template>
  <section class="crud">
    <header class="crud__header">
      <h2>Gestión</h2>
      <button class="boton boton--nuevo" @click="abrirModalParaCrear">+ Nuevo</button>
    </header>

    <p v-if="mensaje" class="crud__mensaje">{{ mensaje }}</p>
    <p v-if="error" class="crud__error">⚠️ {{ error }}</p>

    <div class="tabla">
      <table v-if="!loading">
        <thead>
          <tr>
            <th v-for="col in columnas" :key="col.key">{{ col.label }}</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items" :key="item.id">
            <td v-for="col in columnas" :key="col.key">
              <slot :name="`item.${col.key}`" :item="item">
                {{ getDisplayValue(item, col.key) }}
              </slot>
            </td>
            <td class="acciones">
              <button class="boton boton--editar" @click="abrirModalParaEditar(item)">Editar</button>
              <button
                class="boton boton--eliminar"
                @click="eliminar(item.id)"
                :disabled="loading"
              >
                Eliminar
              </button>
            </td>
          </tr>
          <tr v-if="items.length === 0">
            <td :colspan="columnas.length + 1" class="tabla__vacia">No hay registros</td>
          </tr>
        </tbody>
      </table>
      <div v-else class="tabla__cargando">Cargando...</div>
    </div>

    <div v-if="mostrarModal" class="modal">
      <div class="modal__contenido">
        <h3>{{ form.id ? 'Editar Registro' : 'Nuevo Registro' }}</h3>
        <form @submit.prevent="onGuardar">
          <div
            v-for="campo in camposFormulario"
            :key="campo.key"
            class="formulario__grupo"
          >
            <label :for="campo.key">{{ campo.label }}</label>

            <select
              v-if="campo.type === 'select'"
              :id="campo.key"
              v-model="form[campo.key]"
              required
            >
              <option
                v-for="opt in campo.options"
                :key="opt.value"
                :value="opt.value"
              >
                {{ opt.label }}
              </option>
            </select>

            <input
              v-else
              :type="campo.type || 'text'"
              :id="campo.key"
              v-model="form[campo.key]"
              :placeholder="campo.label"
              required
            />
          </div>

          <div class="formulario__acciones">
            <button
              type="button"
              class="boton boton--cancelar"
              @click="mostrarModal = false"
              :disabled="loading"
            >
              Cancelar
            </button>
            <button type="submit" class="boton boton--guardar" :disabled="loading">
              {{ loading ? 'Guardando...' : (form.id ? 'Actualizar' : 'Guardar') }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </section>
</template>

<style scoped lang="scss">
@use '@/assets/styles/crud.scss' as *;

.crud__error {
  color: red;
  margin-bottom: 0.5rem;
}

.tabla__cargando {
  text-align: center;
  padding: 1rem;
  font-weight: bold;
}
</style>