<!-- CrudTable.vue -->
<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import CrudForm from './CrudForm.vue'
import CrudTableToolbar from './CrudTableToolbar.vue'
import { useCrud } from '@/composables/useCrud'

const relacionesData = ref<Record<string, any[]>>({})

const props = defineProps<{
  config: {
    endpoint: string
    columnas: { key: string; label: string }[]
    camposFormulario: any[]
    relaciones?: {
      key: string
      recurso: string
      label: string | ((item: any) => string)
    }[]
  }
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
} = useCrud(props.config.endpoint)

const mostrarModal = ref(false)
const search = ref('')

// Cargar datos y relaciones al iniciar
onMounted(async () => {
  await cargar()

  for (const rel of props.config.relaciones || []) {
    const { items: relItems, fetchAll } = useCrud(rel.recurso)
    await fetchAll()
    relacionesData.value[rel.key] = relItems.value
  }
})

function getLabel(campoKey: string, valor: any) {
  const rel = props.config.relaciones?.find(r => r.key === campoKey)
  if (!rel) return valor

  const lista = relacionesData.value[campoKey]
  const encontrado = lista?.find(item => item.id === valor)

  if (!encontrado) return valor
  return typeof rel.label === 'function' ? rel.label(encontrado) : encontrado[rel.label]
}

const itemsFiltrados = computed(() => {
  return items.value.filter(item =>
    JSON.stringify(item).toLowerCase().includes(search.value.toLowerCase())
  )
})

const abrirModalParaCrear = () => {
  limpiar()
  mostrarModal.value = true
}

const abrirModalParaEditar = (item: any) => {
  editar(item)
  mostrarModal.value = true
}

const onGuardar = async () => {
  const exito = await guardar()
  if (exito) {
    mostrarModal.value = false
    limpiar()
  }
}
</script>

<template>
  <section class="crud">
    <CrudTableToolbar
      :search="search"
      @update:search="search = $event"
      @nuevo="abrirModalParaCrear"
    />

    <p v-if="mensaje" class="mensaje">{{ mensaje }}</p>
    <p v-if="error" class="error">{{ error }}</p>

    <!-- Desktop Table -->
    <div class="tabla-wrapper" v-if="!loading">
      <table class="tabla desktop">
        <thead>
          <tr>
            <th v-for="col in config.columnas" :key="col.key">{{ col.label }}</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in itemsFiltrados" :key="item.id">
            <td v-for="col in config.columnas" :key="col.key">
              {{ getLabel(col.key, item[col.key]) ?? '-' }}
            </td>
            <td class="acciones">
              <button @click="abrirModalParaEditar(item)">Editar</button>
              <button @click="eliminar(item.id)">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Mobile Card List -->
      <div class="tabla mobile">
        <article
          v-for="item in itemsFiltrados"
          :key="item.id"
          class="card"
          role="region"
          :aria-label="'Registro ID ' + item.id"
        >
          <div
            v-for="col in config.columnas"
            :key="col.key"
            class="campo"
          >
            <strong class="label">{{ col.label }}:</strong>
            <span class="valor">{{ getLabel(col.key, item[col.key]) ?? '-' }}</span>
          </div>
          <div class="acciones">
            <button @click="abrirModalParaEditar(item)">Editar</button>
            <button @click="eliminar(item.id)">Eliminar</button>
          </div>
        </article>
      </div>

      <p v-if="itemsFiltrados.length === 0" class="sin-datos">
        No hay registros
      </p>
    </div>

    <div v-else class="cargando">Cargando...</div>

    <CrudForm
      v-if="mostrarModal"
      :form="form"
      :campos="config.camposFormulario"
      :relaciones="config.relaciones?.map(rel => ({
        ...rel,
        items: relacionesData[rel.key] || []
      }))"
      @guardar="onGuardar"
      @cancelar="mostrarModal = false"
      :loading="loading"
    />
  </section>
</template>

<style scoped lang="scss">
@import "@/assets/styles/_variables.scss";
.crud {
  max-width: 100%;
  margin: 2rem auto;
  padding: 2rem;
  background-color: var(--color-bg);
  border-radius: 1rem;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease-in-out;
  font-family: 'Inter', 'Roboto', sans-serif;
}

// Mensajes de estado
.mensaje,
.error {
  margin-bottom: 1rem;
  padding: 1rem 1.25rem;
  border-radius: 0.5rem;
  font-weight: 500;
  font-size: 0.95rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.mensaje {
  background: #e0f7ec;
  color: #2e7d32;
  border-left: 4px solid #2e7d32;
}

.error {
  background: #ffebee;
  color: var(--color-danger-dark);
  border-left: 4px solid var(--color-danger-dark);
}

// Tabla de escritorio
.tabla {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0 0.75rem;

  thead th {
    background-color: var(--color-bg-alt);
    color: var(--color-text-light);
    font-size: 0.9rem;
    font-weight: 600;
    padding: 0.85rem 1.25rem;
    text-align: left;
    letter-spacing: 0.02em;

    &:last-child {
      border-radius: 0 0.5rem 0.5rem 0;
    }
  }

  tbody tr {
    border-radius: 0.5rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.025);
    transition: transform 0.2s ease, box-shadow 0.2s ease;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
      background-color: var(--color-bg-alt);
    }
  }

  tbody td {
    background-color: var(--color-bg);
    padding: 0.85rem 1.25rem;
    font-size: 1rem;
    color: var(--color-text);
    border-bottom: 1px solid var(--color-gray);
    transition: background-color 0.2s ease;

    &:last-child {
      display: flex;
      gap: 0.5rem;
      justify-content: flex-start;
    }
  }

  button {
    background-color: var(--color-primary);
    color: #fff;
    border: none;
    padding: 0.45rem 0.9rem;
    border-radius: 0.375rem;
    font-size: 0.85rem;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s ease, box-shadow 0.2s ease;

    &:hover {
      background-color: var(--color-primary-dark);
      box-shadow: 0 2px 10px rgba(25, 118, 210, 0.2);
    }

    &:nth-child(2) {
      background-color: var(--color-danger);

      &:hover {
        background-color: var(--color-danger-dark);
        box-shadow: 0 2px 10px rgba(229, 57, 53, 0.2);
      }
    }
  }
}

// Responsive (mobile)
@media (max-width: 768px) {
  .tabla {
    font-size: 0.85rem;

    thead {
      display: none;
    }

    tbody tr {
      display: block;
      margin-bottom: 1rem;
      border-radius: 0.5rem;
      box-shadow: 0 3px 12px rgba(0, 0, 0, 0.03);
    }

    tbody td {
      display: block;
      width: 100%;
      padding: 0.75rem;
      text-align: right;
      position: relative;

      &::before {
        content: attr(data-label);
        position: absolute;
        left: 1rem;
        top: 0.75rem;
        font-weight: bold;
        text-align: left;
        color: var(--color-text);
      }
    }
  }

  .tabla-wrapper {
    .desktop {
      display: none;
    }

    .mobile {
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }

    .card {
      background: #fff;
      border: 1px solid #eee;
      border-radius: 0.75rem;
      padding: 1rem;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.03);
    }

    .campo {
      margin-bottom: 0.5rem;
    }

    .label {
      font-weight: 600;
      color: #555;
      font-size: 0.9rem;
      display: block;
    }

    .valor {
      color: #333;
      font-size: 1rem;
      display: block;
    }

    .acciones {
      display: flex;
      gap: 0.5rem;
      margin-top: 1rem;
    }
  }
}

// Default display for desktop
.tabla-wrapper {
  .desktop {
    display: table;
  }

  .mobile {
    display: none;
  }
}
</style>
