<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'

interface Negocio {
  nombre: string
  tipo: string
  modulos: string[]
}

// Tipos de negocio con iconos SVG inline
const tiposNegocio = [
  { label: 'Barbería / Peluquería', value: 'barberia', icon: '✂️' },
  { label: 'Tienda de ropa', value: 'ropa', icon: '👕' },
  { label: 'Bodega / Minimarket', value: 'bodega', icon: '🏪' },
  { label: 'Restaurante / Menú', value: 'restaurant', icon: '🍽️' },
  { label: 'Ferretería', value: 'ferreteria', icon: '🔧' },
  { label: 'Venta de repuestos', value: 'repuestos', icon: '🚗' },
  { label: 'Hotel / Hospedaje', value: 'hotel', icon: '🏨' },
  { label: 'Otro', value: 'otro', icon: '❓' }
]

const modulosDisponibles = [
  { name: 'Ventas', icon: '💰' },
  { name: 'Productos', icon: '📦' },
  { name: 'Stock', icon: '📊' },
  { name: 'Compras', icon: '🛒' },
  { name: 'Finanzas', icon: '📈' },
  { name: 'Clientes', icon: '👥' },
  { name: 'Proveedores', icon: '🚚' },
  { name: 'Agenda', icon: '📅' },
  { name: 'Reportes', icon: '📄' },
  { name: 'Galería', icon: '🖼️' },
  { name: 'Pedidos', icon: '📋' },
  { name: 'Menú', icon: '📖' },
  { name: 'Caja diaria', icon: '🏦' },
  { name: 'Habitaciones', icon: '🛏️' },
  { name: 'Servicios', icon: '🔧' }
]

const modulosPorTipo: Record<string, string[]> = {
  barberia: ['Servicios', 'Agenda', 'Clientes', 'Finanzas', 'Caja diaria', 'Galería'],
  ropa: ['Productos', 'Ventas', 'Stock', 'Clientes', 'Finanzas'],
  bodega: ['Ventas', 'Productos', 'Stock', 'Clientes', 'Finanzas'],
  restaurant: ['Menú', 'Pedidos', 'Clientes', 'Finanzas', 'Compras', 'Reportes'],
  ferreteria: ['Productos', 'Stock', 'Ventas', 'Proveedores', 'Finanzas'],
  repuestos: ['Productos', 'Ventas', 'Proveedores', 'Clientes', 'Finanzas'],
  hotel: ['Habitaciones', 'Reservas', 'Clientes', 'Finanzas', 'Reportes'],
  otro: []
}

const router = useRouter()

const negocio = ref<Negocio>({
  nombre: '',
  tipo: '',
  modulos: []
})

const seleccionManual = ref(false)

const modulosPreseleccionados = computed(() => {
  if (!negocio.value.tipo) return []
  return modulosPorTipo[negocio.value.tipo] || []
})

watch(
  () => negocio.value.tipo,
  (nuevoTipo) => {
    if (!seleccionManual.value) {
      negocio.value.modulos = modulosPorTipo[nuevoTipo] || []
    }
  }
)

function crearNegocio() {
  if (!negocio.value.nombre.trim()) {
    alert('Por favor ingresa el nombre del negocio')
    return
  }
  if (!negocio.value.tipo) {
    alert('Selecciona un tipo de negocio')
    return
  }
  if (negocio.value.modulos.length === 0) {
    alert('Selecciona al menos un módulo')
    return
  }

  console.log('Negocio creado:', JSON.stringify(negocio.value, null, 2))
  alert(`Negocio "${negocio.value.nombre}" creado con éxito.`)
  router.push('/')
}
</script>

<template>
  <section class="max-w-4xl mx-auto p-6">
    <h1 class="text-4xl font-extrabold mb-8 text-center">Crear negocio</h1>

    <label for="nombre" class="block mb-2 font-semibold text-lg">Nombre del negocio</label>
    <input
      id="nombre"
      type="text"
      v-model="negocio.nombre"
      placeholder="Ejemplo: Mi Bodega San Juan"
      class="w-full p-3 border border-gray-300 rounded shadow-sm mb-6 focus:outline-none focus:ring-2 focus:ring-blue-500"
    />

    <label class="block mb-4 font-semibold text-lg">Tipo de negocio</label>
    <div class="grid grid-cols-4 gap-4 mb-6">
      <button
        v-for="t in tiposNegocio"
        :key="t.value"
        type="button"
        @click="negocio.tipo = t.value"
        :class="[
          'flex flex-col items-center p-4 rounded cursor-pointer border transition',
          negocio.tipo === t.value
            ? 'bg-blue-600 text-white border-blue-600 shadow-lg'
            : 'bg-white text-gray-700 border-gray-300 hover:bg-blue-50 hover:border-blue-400'
        ]"
      >
        <span class="text-4xl mb-2">{{ t.icon }}</span>
        <span class="text-center text-sm font-medium">{{ t.label }}</span>
      </button>
    </div>

    <div class="mb-6">
      <label class="inline-flex items-center cursor-pointer text-lg font-semibold">
        <input
          type="checkbox"
          v-model="seleccionManual"
          class="mr-2 w-5 h-5"
        />
        Seleccionar módulos manualmente
      </label>
    </div>

    <div v-if="seleccionManual" class="mb-8 max-h-72 overflow-auto border rounded p-4 grid grid-cols-3 gap-3">
      <label
        v-for="mod in modulosDisponibles"
        :key="mod.name"
        class="flex items-center cursor-pointer select-none p-2 rounded border hover:bg-blue-50 transition"
      >
        <input
          type="checkbox"
          :value="mod.name"
          v-model="negocio.modulos"
          class="mr-3 w-5 h-5"
        />
        <span class="text-2xl mr-2">{{ mod.icon }}</span> {{ mod.name }}
      </label>
    </div>

    <div v-else class="mb-8">
      <label class="block font-semibold mb-2 text-lg">Módulos asignados automáticamente</label>
      <ul class="list-disc list-inside text-gray-700 space-y-1">
        <li
          v-for="mod in modulosPreseleccionados"
          :key="mod"
          class="flex items-center space-x-2"
        >
          <span class="text-xl">
            {{
              modulosDisponibles.find(m => m.name === mod)?.icon || '❔'
            }}
          </span>
          <span>{{ mod }}</span>
        </li>
      </ul>
    </div>

    <button
      @click="crearNegocio"
      class="w-full py-3 bg-blue-600 text-white text-lg font-bold rounded hover:bg-blue-700 transition"
    >
      Crear negocio
    </button>
  </section>
</template>

<style scoped>
/* Puedes personalizar más si quieres */
</style>
