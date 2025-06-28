 <template>
  <div class="bottom-nav-container">
    <!-- Flecha izquierda para desplazamiento -->
    <div 
      v-if="showScrollLeft" 
      class="scroll-arrow left" 
      @click="scrollNav(-1)"
      aria-label="Desplazar menú a la izquierda"
    >
      <i class="fas fa-chevron-left"></i>
    </div>
    
    <!-- Contenedor principal del menú -->
    <div class="scroll-wrapper" ref="scrollWrapper">
      <nav 
        class="bottom-nav"
        role="navigation"
        aria-label="Navegación principal"
        ref="navElement"
      >
        <!-- Ítems de navegación -->
        <template v-for="(item, index) in items" :key="index">
          <!-- Ítems sin submenú -->
          <router-link
            v-if="!item.submenu"
            :to="item.href"
            custom
            v-slot="{ isActive, navigate }"
          >
            <a
              class="nav-item"
              :class="{ active: isActive || activeItem === index }"
              :aria-current="isActive ? 'page' : null"
              role="menuitem"
              @click="handleItemClick(index, navigate, $event)"
            >
              <div class="icon-wrapper">
                <i :class="item.icon" aria-hidden="true"></i>
                <span v-if="item.notification" class="notification-badge" :aria-label="`${item.notification} notificaciones`">
                  {{ item.notification }}
                </span>
              </div>
              <span class="label">{{ item.label }}</span>
            </a>
          </router-link>
          
          <!-- Ítems con submenú -->
          <div
            v-else
            class="nav-item has-submenu"
            :class="{ active: activeItem === index }"
            tabindex="0"
            role="menuitem"
            :aria-haspopup="true"
            :aria-expanded="activeItem === index"
            @click="toggleSubmenu(index, $event)"
            @keydown.enter="toggleSubmenu(index, $event)"
            @keydown.space="toggleSubmenu(index, $event)"
          >
            <div class="icon-wrapper">
              <i :class="item.icon" aria-hidden="true"></i>
              <span v-if="item.notification" class="notification-badge" :aria-label="`${item.notification} notificaciones`">
                {{ item.notification }}
              </span>
            </div>
            <span class="label">{{ item.label }}</span>
            
            <!-- Submenú -->
            <div class="submenu" role="menu">
              <router-link
                v-for="(subItem, subIndex) in item.submenu"
                :key="subIndex"
                :to="subItem.href"
                custom
                v-slot="{ isActive, navigate }"
              >
                <a
                  class="submenu-item"
                  :class="{ active: isActive }"
                  role="menuitem"
                  @click="activateSubmenuItem(subItem, navigate, $event)"
                >
                  <i :class="subItem.icon" aria-hidden="true"></i>
                  <span>{{ subItem.label }}</span>
                </a>
              </router-link>
            </div>
          </div>
        </template>
        
        <!-- Indicador activo -->
        <div class="active-indicator" ref="indicator"></div>
      </nav>
    </div>
    
    <!-- Flecha derecha para desplazamiento -->
    <div 
      v-if="showScrollRight" 
      class="scroll-arrow right" 
      @click="scrollNav(1)"
      aria-label="Desplazar menú a la derecha"
    >
      <i class="fas fa-chevron-right"></i>
    </div>
  </div>
</template>
<script setup>
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '~/stores/auth'
const router = useRouter()
const route = useRoute()
const auth = useAuthStore()
import { ref, onMounted, onUnmounted, watch } from 'vue';

const props = defineProps({
  items: {
    type: Array,
    required: true,
default: () => [
  {
    icon: 'fas fa-home',
    label: 'Inicio',
    href: '/',
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

  },
  initialActive: {
    type: Number,
    default: 0
  }
});

const emit = defineEmits(['item-selected', 'submenu-selected']);

const navElement = ref(null);
const indicator = ref(null);
const activeItem = ref(props.initialActive);

// Actualizar posición del indicador
function updateIndicatorPosition(index) {
  if (!navElement.value || !indicator.value) return;
  
  const items = navElement.value.querySelectorAll('.nav-item');
  if (!items[index]) return;
  
  const icon = items[index].querySelector('.icon-wrapper');
  if (!icon) return;
  
  const iconRect = icon.getBoundingClientRect();
  const navRect = navElement.value.getBoundingClientRect();
  const centerX = iconRect.left - navRect.left + iconRect.width / 2;
  const offset = indicator.value.offsetWidth / 2;
  
  indicator.value.style.left = `${centerX - offset}px`;
}

// Manejar clic en ítem
function handleItemClick(index, navigate, event) {
  activateItem(index, event);
  navigate(event);
  emit('item-selected', props.items[index], index, event);
}

// Activar un ítem
function activateItem(index, event) {
  activeItem.value = index;
  updateIndicatorPosition(index);
}

// Activar un ítem de submenú
function activateSubmenuItem(subItem, navigate, event) {
  navigate(event);
  emit('submenu-selected', subItem);
  event.stopPropagation();
  activeItem.value = -1; // Cerrar el menú después de seleccionar
}

// Alternar submenú
function toggleSubmenu(index, event) {
  if (activeItem.value === index) {
    activeItem.value = -1;
  } else {
    activeItem.value = index;
    updateIndicatorPosition(index);
  }
  event.stopPropagation();
}

// Cerrar submenús al hacer clic fuera
function handleClickOutside(event) {
  if (navElement.value && !navElement.value.contains(event.target)) {
    activeItem.value = -1;
  }
}

// Cerrar con tecla Escape
function handleEscapeKey(event) {
  if (event.key === 'Escape') {
    activeItem.value = -1;
  }
}

// Actualizar indicador cuando cambia el ítem activo
watch(activeItem, (newIndex) => {
  updateIndicatorPosition(newIndex);
});

// Sincronizar con la ruta actual
watch(() => route.path, (newPath) => {
  // Buscar si la ruta actual coincide con algún item
  for (let i = 0; i < props.items.length; i++) {
    const item = props.items[i];
    
    // Verificar item principal
    if (item.href === newPath) {
      activeItem.value = i;
      return;
    }
    
    // Verificar subitems
    if (item.submenu) {
      for (const subItem of item.submenu) {
        if (subItem.href === newPath) {
          activeItem.value = i;
          return;
        }
      }
    }
  }
  
  // Si no coincide, desactivar
  activeItem.value = -1;
}, { immediate: true });

// Inicializar componente
onMounted(() => {
  updateIndicatorPosition(activeItem.value);
  
  // Event listeners
  document.addEventListener('click', handleClickOutside);
  document.addEventListener('keydown', handleEscapeKey);
  
  // Actualizar en resize
  window.addEventListener('resize', () => {
    updateIndicatorPosition(activeItem.value);
  });
});

// Limpiar listeners
onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
  document.removeEventListener('keydown', handleEscapeKey);
  window.removeEventListener('resize', () => {
    updateIndicatorPosition(activeItem.value);
  });
});
</script>
<style scoped lang="scss">
.bottom-nav-container {
  position: fixed;
  bottom: 25px;
  left: 0;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 0 30px;
  box-sizing: border-box;
 overflow: visible;
  
  .scroll-arrow {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: var(--bg-glass);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 1001;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    transition: var(--transition);
    color: var(--primary);
    
    &:hover {
      background: var(--primary);
      color: white;
      transform: translateY(-50%) scale(1.1);
    }
    
    &.left {
      left: 10px;
    }
    
    &.right {
      right: 10px;
    }
  }
}

.scroll-wrapper {
  width: 100%;
  max-width: 800px;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE and Edge */
  
  &::-webkit-scrollbar {
    display: none; /* Chrome, Safari, Opera */
  }
}

.bottom-nav {
  position: relative;
  height: var(--nav-height);
  background: var(--bg-glass);
  display: inline-flex; /* Cambiado a inline-flex para permitir desplazamiento */
  justify-content: space-around;
  border-radius: var(--radius-lg);
  box-shadow: 0 -4px 25px rgba(0, 0, 0, 0.1), 0 15px 40px rgba(67, 97, 238, 0.2);
  padding: 0 15px;
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  min-width: 100%; /* Asegura que ocupe todo el ancho del contenedor */
  box-sizing: border-box;

  &::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.5) 0%, rgba(255, 255, 255, 0.2) 100%);
    z-index: -1;
    opacity: 0.7;
  }
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  color: var(--text-light);
  font-size: 10px; /* Tamaño de fuente reducido */
  flex: 1;
  min-width: 70px; /* Ancho mínimo para mantener la legibilidad */
  max-width: 90px; /* Ancho máximo para evitar que se expandan demasiado */
  padding: 8px 0; /* Padding reducido */
  transition: var(--transition);
  position: relative;
  z-index: 10;
  transform: translateY(0);
  cursor: pointer;
  box-sizing: border-box;

  &:hover {
    transform: translateY(-5px);
  }

  &.has-submenu {
    &.active {
      background: rgba(67, 97, 238, 0.05);
      border-radius: var(--radius-sm);
      
      .icon-wrapper {
        transform: translateY(-12px) scale(1.15);
        color: white;
      }
      
      i {
        color: white;
        filter: drop-shadow(0 0 6px rgba(255, 255, 255, 0.6));
      }
      
      .label {
        color: var(--primary);
        font-weight: 700;
        text-shadow: 0 0 8px rgba(67, 97, 238, 0.2);
      }
    }
  }
  
  .icon-wrapper {
    width: 40px; /* Tamaño reducido */
    height: 40px; /* Tamaño reducido */
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: var(--transition);
    position: relative;
    z-index: 2;
    background: transparent;
  }
  
  i {
    font-size: 18px; /* Tamaño reducido */
    transition: var(--transition);
    position: relative;
    z-index: 2;
  }
  
  .label {
    margin-top: 4px; /* Reducido */
    font-weight: 500;
    transition: var(--transition);
    position: relative;
    z-index: 2;
    font-size: 10px; /* Tamaño reducido */
    letter-spacing: 0.2px;
    text-align: center;
    line-height: 1.2;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 100%;
  }
  
  &.active {
    .label {
      font-weight: 700;
      color: var(--primary);
      text-shadow: 0 0 8px rgba(67, 97, 238, 0.2);
    }
    
    .icon-wrapper {
      transform: translateY(-12px) scale(1.15);
      color: white;
      animation: bubble 0.7s ease-out;
    }
    
    i {
      color: white;
      filter: drop-shadow(0 0 6px rgba(255, 255, 255, 0.6));
    }
    
    .label {
      color: var(--primary);
      transform: translateY(3px);
      font-weight: 700;
    }
  }
  
  &:not(.active):hover .icon-wrapper::after {
    content: "";
    position: absolute;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    background: rgba(67, 97, 238, 0.15);
    animation: pulse 1.8s infinite;
    z-index: 1;
  }
}

/* Indicador activo */
.active-indicator {
  position: absolute;
  top: -12px; /* Ajustado */
  width: 65px; /* Tamaño reducido */
  height: 65px; /* Tamaño reducido */
  background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
  border-radius: 50%;
  transition: var(--transition);
  z-index: 1;
  transition: left 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  animation: float 4s ease-in-out infinite;
}

/* Submenús */
.submenu {
  position: absolute;
  bottom: calc(var(--nav-height) + 18px);
  left: 50%;
  transform: translateX(-50%) translateY(15px);
  background: var(--bg-glass);
  border-radius: var(--radius-md);
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
  width: 240px;
  opacity: 0;
  visibility: hidden;
  transition: var(--transition);
  z-index: 999;
  padding: 12px 0;
  transform-origin: bottom center;
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.65);
  overflow: hidden;

  &::before {
    content: "";
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    border-left: 12px solid transparent;
    border-right: 12px solid transparent;
    border-top: 12px solid var(--bg-glass);
    filter: drop-shadow(0 2px 2px rgba(0, 0, 0, 0.1));
  }

  &::after {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.96) 0%, rgba(255, 255, 255, 0.92) 100%);
    z-index: -1;
    border-radius: var(--radius-md);
  }

  .nav-item.has-submenu.active & {
    opacity: 1;
    visibility: visible;
    transform: translateX(-50%) translateY(0);
    animation: slideIn 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  }
}

.submenu-item {
  padding: 14px 25px;
  display: flex;
  align-items: center;
  gap: 15px;
  text-decoration: none;
  color: var(--text-light);
  transition: var(--transition);
  position: relative;
  font-weight: 500;
  z-index: 2;
  overflow: hidden;
  border-left: 3px solid transparent;

  &:hover {
    background: rgba(67, 97, 238, 0.05);
    color: var(--primary);
    border-left: 3px solid var(--primary);
    
    &::before {
      width: 100%;
    }
    
    i {
      transform: scale(1.05);
      color: white;
      background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
      box-shadow: 0 3px 10px rgba(67, 97, 238, 0.2);
    }
    
    span {
      color: var(--primary);
      transform: translateX(5px);
    }
  }
  
  &::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 0;
    height: 100%;
    background: linear-gradient(to right, rgba(67, 97, 238, 0.08), transparent);
    transition: width 0.3s ease;
    z-index: -1;
  }
  
  i {
    font-size: 18px;
    width: 34px;
    height: 34px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    color: var(--primary);
    background: rgba(67, 97, 238, 0.1);
    border-radius: 8px;
    transition: var(--transition);
    background: var(--text-light);
  }
  
  span {
    flex: 1;
    transition: var(--transition);
    font-weight: 500;
  }
  
  &:not(:last-child)::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 25px;
    right: 25px;
    height: 1px;
    background: rgba(0, 0, 0, 0.05);
    transition: var(--transition);
  }
  
  &:hover::after {
    opacity: 0;
  }
}

.nav-item.has-submenu.active .submenu-item {
  opacity: 0;
  transform: translateX(-10px);
  animation: fadeInItem 0.3s forwards;
  
  @for $i from 1 through 3 {
    &:nth-child(#{$i}) {
      animation-delay: 0.1s * $i;
    }
  }
}

.notification-badge {
  position: absolute;
  top: -5px;
  right: -5px;
  background: linear-gradient(135deg, var(--accent) 0%, var(--accent-light) 100%);
  color: white;
  font-size: 11px;
  font-weight: bold;
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 3;
  animation: pulseBadge 2s infinite;
  box-shadow: 0 3px 8px rgba(247, 37, 133, 0.3);
}

/* Animaciones */
@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-8px) rotate(3deg); }
}

@keyframes bubble {
  0% {
    transform: translateY(0) scale(1);
    box-shadow: 0 0 0 rgba(67, 97, 238, 0);
  }
  40% {
    transform: translateY(-20px) scale(1.3);
    box-shadow: 0 12px 30px rgba(67, 97, 238, 0.4);
  }
  100% {
    transform: translateY(-12px) scale(1.15);
    box-shadow: 0 8px 20px rgba(67, 97, 238, 0.35);
  }
}

@keyframes pulse {
  0% { transform: scale(0.9); opacity: 0.8; }
  100% { transform: scale(1.8); opacity: 0; }
}

@keyframes pulseBadge {
  0% { transform: scale(1); box-shadow: 0 3px 8px rgba(247, 37, 133, 0.3); }
  50% { transform: scale(1.15); box-shadow: 0 5px 15px rgba(247, 37, 133, 0.4); }
  100% { transform: scale(1); box-shadow: 0 3px 8px rgba(247, 37, 133, 0.3); }
}

@keyframes slideIn {
  0% { transform: translateX(-50%) translateY(15px) scale(0.95); opacity: 0; }
  100% { transform: translateX(-50%) translateY(0) scale(1); opacity: 1; }
}

@keyframes fadeInItem {
  to { opacity: 1; transform: translateX(0); }
}

/* Media queries */
@media (max-width: 768px) {
  .bottom-nav-container {
    padding: 0 40px; /* Más espacio para las flechas */
    
    .scroll-arrow {
      width: 25px;
      height: 25px;
      font-size: 12px;
    }
  }
  
  .bottom-nav {
    min-width: max-content; /* Permite desplazamiento horizontal */
  }
  
  .nav-item {
    min-width: 60px;
  }
}

@media (max-width: 480px) {
  .bottom-nav-container {
    padding: 0 35px;
    bottom: 15px;
    
    .scroll-arrow {
      width: 22px;
      height: 22px;
    }
  }
  
  .bottom-nav {
    border-radius: 20px 20px 0 0;
    padding: 0 10px;
  }
  
  .nav-item {
    min-width: 50px;
    padding: 6px 0;
  }
  
  .icon-wrapper {
    width: 36px;
    height: 36px;
  }
  
  i {
    font-size: 16px;
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

@media (max-width: 360px) {
  .bottom-nav-container {
    padding: 0 30px;
  }
  
  .nav-item .label {
    display: none;
  }

  .icon-wrapper {
    width: 40px;
    height: 40px;
  }

  .active-indicator {
    width: 50px;
    height: 50px;
  }

  .submenu {
    width: 200px;
  }
}
</style>