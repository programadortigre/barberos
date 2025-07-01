 <template>
  <aside :class="['sidebar', { collapsed }]">
    <button @click="collapsed = !collapsed" class="toggle">☰</button>

    <nav>
      <ul>
        <li v-for="item in menu" :key="item.name">
          <!-- Item sin submenú -->
          <div v-if="!item.children">
            <NuxtLink :to="item.to" class="menu-link">
              <span class="icon">{{ item.icon }}</span>
              <span v-if="!collapsed">{{ item.name }}</span>
            </NuxtLink>
          </div>

          <!-- Item con submenú -->
          <div v-else>
            <div @click="toggleSubmenu(item.name)" class="menu-link has-children">
              <span class="icon">{{ item.icon }}</span>
              <span v-if="!collapsed">{{ item.name }}</span>
              <span v-if="!collapsed" class="arrow">{{ openSubmenus[item.name] ? '▾' : '▸' }}</span>
            </div>

            <ul v-if="openSubmenus[item.name] && !collapsed" class="submenu">
              <li v-for="sub in item.children" :key="sub.name">
                <NuxtLink :to="sub.to" class="submenu-link">
                  {{ sub.name }}
                </NuxtLink>
              </li>
            </ul>
          </div>
        </li>

        <!-- Cerrar sesión -->
        <li>
          <button @click="handleLogout" class="logout-btn">
            <span class="icon">🚪</span>
            <span v-if="!collapsed">Cerrar sesión</span>
          </button>
        </li>
      </ul>
    </nav>
  </aside>
</template>


<script setup>
import { useRouter } from 'vue-router'
import { useAuthStore } from '~/stores/auth'
const router = useRouter()
const auth = useAuthStore()

const collapsed = ref(false)
const openSubmenus = ref({})

function toggleSubmenu(name) {
  openSubmenus.value[name] = !openSubmenus.value[name]
}

function handleLogout() {
  auth.logout()
  router.push('/login')
}
const menu = [
  { name: 'Dashboard', to: '/dashboard', icon: '📊' },
  {
    name: 'Crear negocios', to: '/crear-negocio', icon: '🏢' ,
  },
  {
    name: 'Gestión de Usuarios',
    icon: '👥',
    children: [
      { name: 'Usuarios', to: '/usuarios' },
      { name: 'crear Usuarios', to: '/usuarios/crear' },
      { name: 'Roles', to: '/roles' },
      { name: 'Permisos', to: '/permisos' },
      { name: 'Roles-Permisos', to: '/roles-permisos' },
      { name: 'Tokens', to: '/tokens', icon: '🔐' },
      { name: 'Logs de Usuario', to: '/logs-usuarios', icon: '📝' },
    ],
  },
  {
    name: 'Personas y Perfiles',
    icon: '👤',
    children: [
      { name: 'Personas', to: '/personas' },
      { name: 'Perfiles', to: '/perfiles' },
      { name: 'Tipos de Perfil', to: '/tipos_perfil' },
    ],
  },
  { name: 'tienda', to: '/tienda', icon: '🛍️' },
  { name: 'Pedidos', to: '/pedidos', icon: '📦' },
  { name: 'Facturas', to: '/facturas', icon: '🧾' },
  { name: 'Cuentas por Cobrar', to: '/cuentas-cobrar', icon: '💳' },
  { name: 'Cuentas por Pagar', to: '/cuentas-pagar', icon: '💸' },
  { name: 'Productos', to: '/productos', icon: '📦' },
  /*{ name: 'Ventas', to: '/ventas', icon: '💰' },
  { name: 'Compras', to: '/compras', icon: '🛒' },
  { name: 'Inventario', to: '/inventario', icon: '📦' },
  { name: 'Reportes', to: '/reportes', icon: '📈' },
  { name: 'Clientes', to: '/clientes', icon: '👥' },
  { name: 'Proveedores', to: '/proveedores', icon: '🏢' },*/
  { name: 'Cotizaciones', to: '/quote', icon: '📝' },
  { name: 'Configuraciones', to: '/configuraciones', icon: '⚙️' },
]

</script>
<style scoped lang="scss">
@import "@/assets/styles/_variables.scss";

.sidebar {
  width: 250px;
  transition: width 0.3s ease;
  background-color: var(--sidebar-bg-color);
  color: var(--sidebar-text-color);
  padding: 1rem;
  &.collapsed {
    width: 40px;
  }

  .toggle {
    background: none;
    border: none;
    font-size: 1.5rem;
    color: inherit;
    cursor: pointer;
    margin-bottom: 1rem;
  }

  ul {
    list-style: none;
    padding: 0;
    margin: 0;

    li {
      margin-bottom: 0.5rem;

      .menu-link {
        display: flex;
        align-items: center;
        padding: 0.5rem;
        color: inherit;
        text-decoration: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background 0.2s;

        &:hover {
          background-color: var(--sidebar-hover-bg);
        }

        .icon {
          width: 24px;
          text-align: center;
          margin-right: 0.5rem;
        }

        .arrow {
          margin-left: auto;
          font-size: 0.8rem;
        }

        &.has-children {
          justify-content: space-between;
        }
      }

      .submenu {
        padding-left: 1.5rem;

        .submenu-link {
          display: block;
          padding: 0.3rem 0.5rem;
          font-size: 0.9rem;
          color: #ccc;
          text-decoration: none;
          border-radius: 4px;

          &:hover {
            background-color: #50545c;
          }
        }
      }
    }
  }

  .logout-btn {
    background: none;
    border: none;
    font-size: 1rem;
    color: inherit;
    display: flex;
    align-items: center;
    cursor: pointer;
    padding: 0.5rem;
    margin-top: 1rem;
    border-radius: 4px;

    &:hover {
      background-color: #3a3f47;
    }

    .icon {
      width: 24px;
      text-align: center;
      margin-right: 0.5rem;
    }
  }
}
</style>
