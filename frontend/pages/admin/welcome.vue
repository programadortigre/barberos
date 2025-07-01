<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

interface Modulo {
  name: string
  icon: string
  descripcion: string
}

interface Negocio {
  nombre: string
  tipo: string
  modulos: string[]
  logo: string | null
}

// Lista completa para obtener icono y descripción
const modulosDisponibles = [
  { name: 'Ventas', icon: '💰', descripcion: 'Registra y consulta todas tus ventas.' },
  { name: 'Productos', icon: '📦', descripcion: 'Administra tus productos o servicios.' },
  { name: 'Stock', icon: '📊', descripcion: 'Control de inventario y existencias.' },
  { name: 'Compras', icon: '🛒', descripcion: 'Registra compras y abastecimiento.' },
  { name: 'Finanzas', icon: '📈', descripcion: 'Consulta ingresos, egresos y balances.' },
  { name: 'Clientes', icon: '👥', descripcion: 'Gestión de clientes y contactos.' },
  { name: 'Proveedores', icon: '🚚', descripcion: 'Gestiona tus proveedores de productos.' },
  { name: 'Agenda', icon: '📅', descripcion: 'Citas, reservas y recordatorios.' },
  { name: 'Reportes', icon: '📄', descripcion: 'Informes visuales de tu negocio.' },
  { name: 'Galería', icon: '🖼️', descripcion: 'Fotos y contenido visual de tu negocio.' },
  { name: 'Pedidos', icon: '📋', descripcion: 'Seguimiento de pedidos de clientes.' },
  { name: 'Menú', icon: '📖', descripcion: 'Define tu carta o menú del día.' },
  { name: 'Caja diaria', icon: '🏦', descripcion: 'Control de ingresos y egresos diarios.' },
  { name: 'Habitaciones', icon: '🛏️', descripcion: 'Gestiona reservas y disponibilidad.' },
  { name: 'Servicios', icon: '🔧', descripcion: 'Define los servicios que ofreces.' },
  { name: 'Reservas', icon: '📅', descripcion: 'Controla reservas y citas.' }
]

const router = useRouter()
const negocio = ref<Negocio | null>(null)
const modulos = ref<Modulo[]>([])

onMounted(() => {
  const negocioJson = localStorage.getItem('negocio')
  if (negocioJson) {
    negocio.value = JSON.parse(negocioJson)
    // Obtener info detallada de los módulos guardados (icono + descripción)
    modulos.value = negocio.value.modulos.map(modName => {
      return modulosDisponibles.find(m => m.name === modName) || { name: modName, icon: '❔', descripcion: '' }
    })
  } else {
    // Si no hay negocio guardado, puedes redirigir o mostrar mensaje
    router.push('/')
  }
})

function onModuloClick(modulo: Modulo) {
  alert(`Módulo: ${modulo.name}\nDescripción: ${modulo.descripcion}`)
}
</script>

<template>
  <section class="welcome-container" v-if="negocio">
    <div class="header">
      <div class="logo" v-if="negocio.logo">
        <img :src="negocio.logo" :alt="`Logo de ${negocio.nombre}`" />
      </div>
      <div class="info">
        <h1>{{ negocio.nombre }}</h1>
        <p class="tipo">Tipo: <strong>{{ negocio.tipo }}</strong></p>
      </div>
    </div>

    <h2>Módulos activos</h2>
    <div class="modulos-list">
      <div v-for="modulo in modulos" :key="modulo.name" class="modulo-item" @click="onModuloClick(modulo)" role="button"
        tabindex="0" @keyup.enter="onModuloClick(modulo)">
        <span class="icon">{{ modulo.icon }}</span>
        <div class="modulo-text">
          <strong>{{ modulo.name }}</strong>
          <p>{{ modulo.descripcion }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.welcome-container {
  max-width: 720px;
  margin: 2rem auto;
  padding: 0 1rem;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: #222;
}

.header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 2rem;
}

.logo img {
  max-width: 120px;
  border-radius: 10px;
  box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
}

.info h1 {
  font-size: 2rem;
  margin-bottom: 0.2rem;
  color: #1e40af;
}

.tipo {
  font-weight: 600;
  font-size: 1rem;
  color: #475569;
}

.modulos-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 1rem;
}

.modulo-item {
  background: #f1f5f9;
  border-radius: 12px;
  padding: 1rem;
  cursor: pointer;
  box-shadow: 0 2px 8px rgb(0 0 0 / 0.05);
  display: flex;
  align-items: flex-start;
  gap: 0.8rem;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

.modulo-item:hover,
.modulo-item:focus {
  background-color: #e0e7ff;
  box-shadow: 0 4px 15px rgb(59 130 246 / 0.3);
  outline: none;
}

.icon {
  font-size: 2.4rem;
  user-select: none;
}

.modulo-text strong {
  font-size: 1.1rem;
  color: #334155;
  display: block;
}

.modulo-text p {
  font-size: 0.9rem;
  color: #64748b;
  margin-top: 0.2rem;
}
</style>
