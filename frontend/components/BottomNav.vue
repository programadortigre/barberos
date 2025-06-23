  <template>
    <div class="nav-container">
      <!-- Contenedor externo para submenús (fuera del flujo) -->
      <div id="submenu-container"></div>

      <!-- Barra de navegación con desplazamiento horizontal -->
      <div class="bottom-nav-container">
        <div 
          v-if="showScrollLeft" 
          class="scroll-arrow left" 
          @click="scrollNav(-1)"
          aria-label="Desplazar menú a la izquierda"
        >
          <i class="fas fa-chevron-left"></i>
        </div>
        
        <div class="scroll-wrapper" ref="scrollWrapper">
          <nav 
            class="bottom-nav"
            ref="navElement"
            role="navigation"
            aria-label="Navegación principal"
          >
            <div
              v-for="(item, index) in items"
              :key="index"
              class="nav-item"
              :class="{ 
                active: activeItemIndex === index, 
                'has-notification': item.notification
              }"
              @click="handleClick(item, index, $event)"
            >
              <div class="icon-wrapper">
                <i :class="item.icon" aria-hidden="true"></i>
                <span 
                  v-if="item.notification" 
                  class="notification-badge" 
                  :aria-label="`${item.notification} notificaciones`"
                >
                  {{ item.notification }}
                </span>
              </div>
              <span class="label">{{ item.label }}</span>
            </div>
            
            <!-- Indicador activo -->
            <div class="active-indicator" ref="indicator" :style="indicatorStyle"></div>
          </nav>
        </div>
        
        <div 
          v-if="showScrollRight" 
          class="scroll-arrow right" 
          @click="scrollNav(1)"
          aria-label="Desplazar menú a la derecha"
        >
          <i class="fas fa-chevron-right"></i>
        </div>
      </div>
    </div>
  </template>

  <script setup>
  import { ref, onMounted, onUnmounted, watch, nextTick, computed } from 'vue'
  import { useRoute, useRouter } from 'vue-router'

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
      href: '/ventas',
      notification: null
    },
    {
      icon: 'fas fa-cash-register',
      label: 'Operaciones',
      notification: 3,
      submenu: [
        {
          icon: 'fas fa-plus-circle',
          label: 'Nueva Operación',
          href: '/nueva-operacion'
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
      ]
    },
    {
      icon: 'fas fa-shopping-cart',
      label: 'Ventas',
      notification: 2,
      submenu: [
        {
          icon: 'fas fa-cash-register',
          label: 'Punto de Venta',
          href: '/pos'
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
      ]
    },
    {
      icon: 'fas fa-boxes',
      label: 'Productos',
      submenu: [
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
      ]
    },
    {
      icon: 'fas fa-users',
      label: 'Clientes',
      notification: 5,
      submenu: [
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
      ]
    },
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
    },
    {
      icon: 'fas fa-chart-bar',
      label: 'Reportes',
      href: '/reportes'
    }
  ]
    }
  })

  const emit = defineEmits(['item-selected', 'submenu-selected'])

  // Referencias del DOM
  const navElement = ref(null)
  const indicator = ref(null)
  const scrollWrapper = ref(null)

  // Estado del componente
  const activeItemIndex = ref(-1)
  const showScrollLeft = ref(false)
  const showScrollRight = ref(false)
  const indicatorPosition = ref(0)

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
    const container = document.getElementById('submenu-container')
    const alreadyOpen = activeItemIndex.value === index
    
    // Cerrar todos los submenús primero
    closeSubmenus()
    
    if (item.submenu && !alreadyOpen) {
      activeItemIndex.value = index
      
      const rect = event.currentTarget.getBoundingClientRect()
      
      const submenu = document.createElement('div')
      submenu.className = 'submenu'
      submenu.style.left = `${rect.left + rect.width / 2}px`
      submenu.style.bottom = `${window.innerHeight - rect.top + 70}px`
      
      submenu.innerHTML = `
        <div class="submenu-content">
          ${item.submenu.map(sub => `
            <a 
              href="${sub.href}" 
              class="submenu-item" 
              @click.prevent="handleSubmenuClick(${JSON.stringify(sub).replace(/"/g, '&quot;')}, event)"
              aria-label="${sub.label}"
            >
              <i class="${sub.icon}" aria-hidden="true"></i>
              <span>${sub.label}</span>
            </a>
          `).join('')}
        </div>
        <div class="submenu-arrow"></div>
      `
      
      container.appendChild(submenu)
      
      // Agregar manejadores de eventos para los enlaces del submenú
      submenu.querySelectorAll('a').forEach(a => {
        a.addEventListener('click', (e) => {
          e.preventDefault()
          const subItem = item.submenu.find(s => s.href === a.getAttribute('href'))
          handleSubmenuClick(subItem, e)
        })
      })
    } else if (item.href) {
      router.push(item.href)
      activeItemIndex.value = index
      emit('item-selected', item, index, event)
    }
  }

  // Cerrar todos los submenús
  function closeSubmenus() {
    const container = document.getElementById('submenu-container')
    container.innerHTML = ''
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

  // Actualizar posición del indicador
  function updateIndicatorPosition() {
    if (!navElement.value || activeItemIndex.value === -1) return
    
    const items = navElement.value.querySelectorAll('.nav-item')
    if (!items[activeItemIndex.value]) return
    
    const icon = items[activeItemIndex.value].querySelector('.icon-wrapper')
    if (!icon) return
    
    const iconRect = icon.getBoundingClientRect()
    const navRect = navElement.value.getBoundingClientRect()
    const centerX = iconRect.left - navRect.left + iconRect.width / 2
    
    indicatorPosition.value = centerX - 32.5 // 65px (ancho del indicador) / 2
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
    if (!event.target.closest('.nav-item') && !event.target.closest('.submenu')) {
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

  <style scoped lang="scss">
  $primary: #6ae8ff;
  $background: rgba(30, 30, 40, 0.95);
  $submenu-bg: rgba(35, 35, 50, 0.98);

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

    @media (max-width: 768px) {
      padding: 0 30px;
    }

    @media (max-width: 480px) {
      padding: 0 35px;
      bottom: 15px;
    }
  }

  .scroll-arrow {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: rgba(30, 30, 40, 0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 1001;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease;
    color: $primary;

    &.left { left: 5px; }
    &.right { right: 5px; }

    &:hover {
      background: $primary;
      color: white;
      transform: translateY(-50%) scale(1.1);
    }

    @media (max-width: 768px) {
      width: 25px;
      height: 25px;
      font-size: 12px;
    }

    @media (max-width: 480px) {
      width: 22px;
      height: 22px;
    }
  }

  .scroll-wrapper {
    width: 100%;
    overflow-x: auto;
    scrollbar-width: none;
    -ms-overflow-style: none;

    &::-webkit-scrollbar {
      display: none;
    }
  }

  .bottom-nav {
    position: relative;
    height: 70px;
    background: $background;
    display: inline-flex;
    justify-content: space-around;
    border-radius: 18px 18px 0 0;
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
    transition: all 0.3s ease;
    position: relative;
    z-index: 10;
    cursor: pointer;

    &:hover {
      transform: translateY(-5px);
    }

    &.active {
      .label {
        font-weight: 600;
        color: $primary;
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

    @media (max-width: 768px) {
      min-width: 60px;
    }

    @media (max-width: 480px) {
      min-width: 50px;
      padding: 6px 0;
    }
  }

  .icon-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 36px;
    height: 36px;
    margin-bottom: 4px;
    transition: all 0.3s ease;
    position: relative;

    @media (max-width: 480px) {
      width: 32px;
      height: 32px;
    }
  }

  .nav-item i {
    font-size: 20px;
    transition: all 0.3s ease;
    position: relative;
    z-index: 2;

    @media (max-width: 480px) {
      font-size: 18px;
    }
  }

  .label {
    font-size: 11px;
    font-weight: 500;
    transition: all 0.2s ease;
    position: relative;
    z-index: 2;

    @media (max-width: 480px) {
      font-size: 9px;
    }
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

  #submenu-container {
    position: fixed;
    width: 100%;
    height: 0;
    z-index: 1001;
    pointer-events: none;
    bottom: 70px;
  }

  .submenu {
    position: absolute;
    transform: translateX(-50%);
    background: $submenu-bg;
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
    border-top-color: $submenu-bg;
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
    color: rgba(255, 255, 255, 0.85);
    text-decoration: none;
    white-space: nowrap;
    transition: all 0.2s ease;

    i {
      font-size: 15px;
      width: 24px;
      color: $primary;
      margin-right: 12px;
      transition: transform 0.2s ease;
    }

    &:hover {
      background: rgba(106, 232, 255, 0.12);
      padding-left: 22px;

      i {
        transform: scale(1.15);
      }
    }
  }

  .active-indicator {
    position: absolute;
    top: -12px;
    width: 65px;
    height: 65px;
    background: linear-gradient(135deg, $primary 0%, #4361ee 100%);
    border-radius: 50%;
    z-index: 1;
    transition: left 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    animation: float 4s ease-in-out infinite;
    box-shadow: 0 5px 15px rgba(106, 232, 255, 0.4);

    @media (max-width: 480px) {
      width: 55px;
      height: 55px;
      top: -10px;
    }
  }

  /* Animaciones */
  @keyframes float {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50% { transform: translateY(-8px) rotate(3deg); }
  }

  @keyframes bubble {
    0% { transform: translateY(0) scale(1); }
    40% { transform: translateY(-20px) scale(1.3); }
    100% { transform: translateY(-12px) scale(1.15); }
  }

  @keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.15); }
    100% { transform: scale(1); }
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

  </style>