<template>
  <div class="nav-container">
    <!-- Submenú reactivo -->
    <div v-if="activeSubmenu" class="submenu-wrapper" :style="{
      left: `${submenuPosition.x}px`,
      top: `${submenuPosition.y}px`
    }" ref="submenuRef">
      <div class="submenu">
        <div class="submenu-content">
          <a v-for="(subItem, idx) in activeSubmenu" :key="idx" href="#" class="submenu-item"
            @click.prevent="handleSubmenuClick(subItem, $event)">
            <i :class="subItem.icon"></i>
            <span>{{ subItem.label }}</span>
          </a>
        </div>
        <div class="submenu-arrow"></div>
      </div>
    </div>

    <!-- Barra de navegación principal -->
    <div class="bottom-nav-container">
      <div v-if="showScrollLeft" class="scroll-arrow left" @click="scrollNav(-1)"
        aria-label="Desplazar menú a la izquierda">
        <i class="fas fa-chevron-left"></i>
      </div>

      <div class="scroll-wrapper" ref="scrollWrapper">
        <nav class="bottom-nav" ref="navElement" role="navigation" aria-label="Navegación principal">
          <div v-for="(item, index) in items" :key="index" class="nav-item" :class="{
            active: activeItemIndex === index,
            'has-notification': item.notification
          }" @click="handleClick(item, index, $event)">
            <div class="icon-wrapper">
              <i :class="item.icon" aria-hidden="true"></i>
              <span v-if="item.notification" class="notification-badge"
                :aria-label="`${item.notification} notificaciones`">
                {{ item.notification }}
              </span>
            </div>
            <span class="label">{{ item.label }}</span>
          </div>

          <!-- Indicador activo -->
          <div class="active-indicator" ref="indicator" :style="indicatorStyle"></div>
        </nav>
      </div>

      <div v-if="showScrollRight" class="scroll-arrow right" @click="scrollNav(1)"
        aria-label="Desplazar menú a la derecha">
        <i class="fas fa-chevron-right"></i>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, nextTick, computed } from 'vue'

// Configuración de Nuxt 3
const route = useRoute()
const router = useRouter()

// Definir props con valores por defecto
const props = defineProps({
  items: {
    type: Array,
    required: true,
    default: () => [
      {
        icon: 'fas fa-home',
        label: 'Inicio',
        href: '/negocio',
        notification: null
      },
      {
        icon: 'fas fa-cash-register',
        label: 'Operaciones',
        href: '/negocio/operaciones',

        notification: 3,
        /*submenu: [
          {
            icon: 'fas fa-plus-circle',
            label: 'Nueva Operación',
            href: '/negocio/operaciones'
          },
          {
            icon: 'fas fa-history',
            label: 'Historial',
            href: '/historial-operaciones'
          },
          {
            icon: 'fas fa-chart-line',
            label: 'Estadísticas',
            href: '/estadisticas-operaciones'
          }
        ]*/
      },
      {
        icon: 'fas fa-shopping-cart',
        label: 'Ventas',
        notification: 2,
        href: '/negocio/ventas',

        /*submenu: [
          {
            icon: 'fas fa-cash-register',
            label: 'Punto de Venta',
            href: '/negocio/ventas'
          },
          {
            icon: 'fas fa-list',
            label: 'Historial de Ventas',
            href: '/ventas/historial'
          },
          {
            icon: 'fas fa-undo',
            label: 'Devoluciones',
            href: '/ventas/devoluciones'
          }
        ]*/
      },
      {
        icon: 'fas fa-boxes',
        label: 'Productos',
        notification: 0,
        href: '/negocio/productos',
        /*submenu: [
          {
            icon: 'fas fa-box',
            label: 'Inventario',
            href: '/productos/inventario'
          },
          {
            icon: 'fas fa-tags',
            label: 'Categorías',
            href: '/productos/categorias'
          },
          {
            icon: 'fas fa-plus-circle',
            label: 'Nuevo Producto',
            href: '/productos/nuevo'
          }
        ]*/
      },
      {
        icon: 'fas fa-users',
        label: 'Clientes',
        notification: 5,
        href: '/negocio/clientes',
        /*submenu: [
          {
            icon: 'fas fa-plus-circle',
            label: 'Nuevo Cliente',
            href: '/clientes/nuevo'
          },
          {
            icon: 'fas fa-address-book',
            label: 'Directorio',
            href: '/clientes/directorio'
          },
          {
            icon: 'fas fa-chart-line',
            label: 'Estadísticas',
            href: '/clientes/estadisticas'
          }
        ]*/
      },/*
      {
        icon: 'fas fa-user-tie',
        label: 'Empleados',
        submenu: [
          {
            icon: 'fas fa-user-plus',
            label: 'Nuevo Empleado',
            href: '/empleados/nuevo'
          },
          {
            icon: 'fas fa-users-cog',
            label: 'Gestión de Empleados',
            href: '/empleados/gestion'
          },
          {
            icon: 'fas fa-calendar-check',
            label: 'Asistencias',
            href: '/empleados/asistencias'
          }
        ]
      },
      {
        icon: 'fas fa-file-invoice-dollar',
        label: 'Finanzas',
        submenu: [
          {
            icon: 'fas fa-wallet',
            label: 'Cuentas por Cobrar',
            href: '/finanzas/cuentas-cobrar'
          },
          {
            icon: 'fas fa-file-invoice',
            label: 'Cuentas por Pagar',
            href: '/finanzas/cuentas-pagar'
          },
          {
            icon: 'fas fa-chart-pie',
            label: 'Resumen Financiero',
            href: '/finanzas/resumen'
          }
        ]
      },
      {
        icon: 'fas fa-tools',
        label: 'Herramientas',
        submenu: [
          {
            icon: 'fas fa-database',
            label: 'Respaldo de Datos',
            href: '/herramientas/respaldo'
          },
          {
            icon: 'fas fa-upload',
            label: 'Importar Datos',
            href: '/herramientas/importar'
          },
          {
            icon: 'fas fa-sync-alt',
            label: 'Sincronización',
            href: '/herramientas/sincronizar'
          }
        ]
      },
      {
        icon: 'fas fa-cogs',
        label: 'Configuración',
        submenu: [
          {
            icon: 'fas fa-user-cog',
            label: 'Perfil',
            href: '/configuracion/perfil'
          },
          {
            icon: 'fas fa-shield-alt',
            label: 'Seguridad',
            href: '/configuracion/seguridad'
          },
          {
            icon: 'fas fa-bell',
            label: 'Notificaciones',
            href: '/configuracion/notificaciones'
          },
          {
            icon: 'fas fa-sliders-h',
            label: 'Preferencias',
            href: '/configuracion/preferencias'
          }
        ]
      },
      {
        icon: 'fas fa-question-circle',
        label: 'Ayuda',
        submenu: [
          {
            icon: 'fas fa-book',
            label: 'Documentación',
            href: '/ayuda/documentacion'
          },
          {
            icon: 'fas fa-headset',
            label: 'Soporte Técnico',
            href: '/ayuda/soporte'
          },
          {
            icon: 'fas fa-comment-dots',
            label: 'Feedback',
            href: '/ayuda/feedback'
          }
        ]
      },*/
      {
        icon: 'fas fa-chart-bar',
        label: 'Reportes',
        href: '/negocio/reportes'
      }
    ]
  }
})

const emit = defineEmits(['item-selected', 'submenu-selected'])

// Referencias del DOM
const navElement = ref(null)
const indicator = ref(null)
const scrollWrapper = ref(null)
const submenuRef = ref(null)

// Estado del componente
const activeItemIndex = ref(-1)
const showScrollLeft = ref(false)
const showScrollRight = ref(false)
const indicatorPosition = ref(0)
const activeSubmenu = ref(null)
const submenuPosition = ref({ x: 0, y: 0 })

// Estilo computado para el indicador
const indicatorStyle = computed(() => {
  return {
    left: `${indicatorPosition.value}px`
  }
})

// Sincronizar el indicador con la ruta actual
watch(() => route.path, (newPath) => {
  // Buscar el ítem que coincide con la ruta actual
  for (let i = 0; i < props.items.length; i++) {
    const item = props.items[i]

    // Verificar ítem principal
    if (item.href === newPath) {
      activeItemIndex.value = i
      return
    }

    // Verificar subítems
    if (item.submenu) {
      for (const subItem of item.submenu) {
        if (subItem.href === newPath) {
          activeItemIndex.value = i
          return
        }
      }
    }
  }

  activeItemIndex.value = -1
}, { immediate: true })

// Actualizar posición del indicador cuando cambia el ítem activo
watch(activeItemIndex, (newIndex) => {
  nextTick(() => {
    updateIndicatorPosition()
  })
})

// Manejar clic en un ítem
function handleClick(item, index, event) {
  const alreadyOpen = activeItemIndex.value === index && activeSubmenu.value

  // Cerrar todos los submenús primero
  closeSubmenus()

  if (item.submenu && !alreadyOpen) {
    activeItemIndex.value = index
    activeSubmenu.value = item.submenu

    const rect = event.currentTarget.getBoundingClientRect()
    submenuPosition.value = {
      x: rect.left + rect.width / 2,
      y: rect.top
    }
  } else if (item.href) {
    router.push(item.href)
    activeItemIndex.value = index
    emit('item-selected', item, index, event)
  }
}

// Cerrar todos los submenús
function closeSubmenus() {
  activeSubmenu.value = null
}

// Manejar clic en ítem de submenú
function handleSubmenuClick(subItem, event) {
  router.push(subItem.href)
  emit('submenu-selected', subItem, event)
  closeSubmenus()
}

// Desplazar navegación
function scrollNav(direction) {
  if (scrollWrapper.value) {
    const scrollAmount = 200
    scrollWrapper.value.scrollBy({
      left: direction * scrollAmount,
      behavior: 'smooth'
    })
  }
}

// CORRECCIÓN: Nuevo cálculo para centrar el indicador
function updateIndicatorPosition() {
  if (!navElement.value || activeItemIndex.value === -1) return

  const items = navElement.value.querySelectorAll('.nav-item')
  if (!items[activeItemIndex.value]) return

  const activeItem = items[activeItemIndex.value]
  const itemRect = activeItem.getBoundingClientRect()
  const navRect = navElement.value.getBoundingClientRect()

  // Calcular la posición centrada del indicador
  const centerX = itemRect.left - navRect.left + itemRect.width / 2
  indicatorPosition.value = centerX - 35 // 70px (ancho del indicador) / 2
}

// Verificar visibilidad de flechas de desplazamiento
function checkScrollArrows() {
  if (scrollWrapper.value) {
    showScrollLeft.value = scrollWrapper.value.scrollLeft > 0
    showScrollRight.value =
      scrollWrapper.value.scrollLeft + scrollWrapper.value.clientWidth <
      scrollWrapper.value.scrollWidth - 10
  }
}

// Cerrar submenús al hacer clic fuera
function handleClickOutside(event) {
  if (!event.target.closest('.nav-item') &&
    !event.target.closest('.submenu-wrapper') &&
    !event.target.closest('.submenu')) {
    closeSubmenus()
  }
}

// Inicializar componente
onMounted(() => {
  window.addEventListener('resize', updateIndicatorPosition)
  window.addEventListener('click', handleClickOutside)
  window.addEventListener('scroll', checkScrollArrows)

  if (scrollWrapper.value) {
    scrollWrapper.value.addEventListener('scroll', checkScrollArrows)
  }

  nextTick(() => {
    updateIndicatorPosition()
    checkScrollArrows()
  })
})

// Limpiar recursos
onUnmounted(() => {
  window.removeEventListener('resize', updateIndicatorPosition)
  window.removeEventListener('click', handleClickOutside)
  window.removeEventListener('scroll', checkScrollArrows)

  if (scrollWrapper.value) {
    scrollWrapper.value.removeEventListener('scroll', checkScrollArrows)
  }

  closeSubmenus()
})
</script>

<style scoped>
:root {
  --primary: #6ae8ff;
  --secondary: #4361ee;
  --bg-color: rgba(30, 30, 40, 0.95);
  --submenu-bg: rgba(35, 35, 50, 0.98);
  --text-color: rgba(255, 255, 255, 0.85);
  --transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.nav-container {
  position: relative;
  z-index: 1000;
}

.bottom-nav-container {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 0 40px;
  box-sizing: border-box;
  overflow: visible;
}

.scroll-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: var(--bg-color);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 1001;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  transition: var(--transition);
  color: var(--primary);

  &.left {
    left: 5px;
  }

  &.right {
    right: 5px;
  }

  &:hover {
    background: var(--primary);
    color: white;
    transform: translateY(-50%) scale(1.1);
  }
}

.scroll-wrapper {
  width: 100%;
  overflow-x: auto;
  scrollbar-width: none;
  -ms-overflow-style: none;
  padding: 25px 0 0;

  &::-webkit-scrollbar {
    display: none;
  }
}

.bottom-nav {
  position: relative;
  height: 70px;
  background: var(--bg-color);
  display: inline-flex;
  justify-content: space-around;
  border-radius: 18px;
  box-shadow: 0 -4px 25px rgba(0, 0, 0, 0.2), 0 15px 40px rgba(67, 97, 238, 0.2);
  padding: 0 15px;
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  min-width: 100%;
  box-sizing: border-box;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  color: rgba(255, 255, 255, 0.7);
  font-size: 12px;
  flex: 1;
  min-width: 70px;
  max-width: 90px;
  padding: 8px 0;
  transition: var(--transition);
  position: relative;
  z-index: 10;
  cursor: pointer;

  &:hover {
    transform: translateY(-5px);
  }

  &.active {
    .label {
      font-weight: 600;
      color: var(--primary);
      text-shadow: 0 0 8px rgba(106, 232, 255, 0.5);
    }

    .icon-wrapper {
      transform: translateY(-12px) scale(1.15);
      animation: bubble 0.7s ease-out;
    }

    i {
      color: white;
      filter: drop-shadow(0 0 6px rgba(255, 255, 255, 0.6));
    }
  }
}

.icon-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 36px;
  height: 36px;
  margin-bottom: 4px;
  transition: var(--transition);
  position: relative;
  color: var(--text-color);
}

.nav-item i {
  font-size: 20px;
  transition: var(--transition);
  position: relative;
  z-index: 2;
}

.label {
  font-size: 11px;
  font-weight: 500;
  transition: var(--transition);
  position: relative;
  z-index: 2;
  color: var(--text-color);
}

.notification-badge {
  position: absolute;
  top: -5px;
  right: -5px;
  background: #ff4757;
  color: white;
  font-size: 10px;
  font-weight: bold;
  min-width: 18px;
  height: 18px;
  line-height: 18px;
  border-radius: 50%;
  animation: pulse 1.5s infinite;
  box-shadow: 0 3px 8px rgba(247, 37, 133, 0.3);
  z-index: 3;
}

.submenu-wrapper {
  position: fixed;
  z-index: 1001;
  transform: translate(1%, -104%);
  margin-top: -20px;
}

.submenu {
  position: relative;
  background: var(--submenu-bg);
  backdrop-filter: blur(15px);
  border-radius: 14px;
  padding: 8px 0;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4);
  min-width: 200px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  z-index: 1001;
  pointer-events: all;
  animation: fadeInUp 0.25s ease-out forwards;
}

.submenu-arrow {
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  border: solid transparent;
  border-width: 0 10px 10px 10px;
  border-top-color: var(--submenu-bg);
  filter: drop-shadow(0 2px 2px rgba(0, 0, 0, 0.2));
}

.submenu-content {
  display: flex;
  flex-direction: column;
}

.submenu-item {
  display: flex;
  align-items: center;
  padding: 10px 20px;
  font-size: 13px;
  color: var(--text-color);
  text-decoration: none;
  white-space: nowrap;
  transition: var(--transition);

  i {
    font-size: 15px;
    width: 24px;
    color: var(--primary);
    margin-right: 12px;
    transition: var(--transition);
  }

  &:hover {
    background: rgba(106, 232, 255, 0.12);
    padding-left: 22px;

    i {
      transform: scale(1.15);
    }
  }
}

/* CORRECCIÓN: Indicador activo centrado */
.active-indicator {
  position: absolute;
  top: -12px;
  width: 70px;
  height: 70px;
  background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
  border-radius: 50%;
  z-index: 1;
  transition: var(--transition);
  box-shadow: 0 5px 20px rgba(67, 97, 238, 0.4);
  animation: float 4s ease-in-out infinite;
}

/* Animaciones */
@keyframes float {

  0%,
  100% {
    transform: translateY(0) rotate(0deg);
  }

  50% {
    transform: translateY(-8px) rotate(3deg);
  }
}

@keyframes bubble {
  0% {
    transform: translateY(0) scale(1);
  }

  40% {
    transform: translateY(-20px) scale(1.3);
  }

  100% {
    transform: translateY(-12px) scale(1.15);
  }
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }

  50% {
    transform: scale(1.15);
  }

  100% {
    transform: scale(1);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translate(-50%, 8px);
  }

  to {
    opacity: 1;
    transform: translate(-50%, 0);
  }
}

/* Media queries para responsividad */
@media (max-width: 768px) {
  .bottom-nav-container {
    padding: 0 30px;
  }

  .scroll-arrow {
    width: 25px;
    height: 25px;
    font-size: 12px;
  }

  .nav-item {
    min-width: 60px;
  }
}

@media (max-width: 480px) {
  .bottom-nav-container {
    padding: 0 20px;
    bottom: 15px;
  }

  .scroll-arrow {
    width: 22px;
    height: 22px;
  }

  .nav-item {
    min-width: 50px;
    padding: 6px 0;
  }

  .icon-wrapper {
    width: 32px;
    height: 32px;
  }

  .nav-item i {
    font-size: 18px;
  }

  .label {
    font-size: 9px;
  }

  .active-indicator {
    width: 55px;
    height: 55px;
    top: -10px;
  }
}
</style>