<template>
  <aside :class="['sidebar', { collapsed }]">
    <button @click="collapsed = !collapsed" class="toggle">
      ☰
    </button>
    <nav>
      <ul>
        <li v-for="item in menu" :key="item.name">
          <NuxtLink :to="item.to">
            {{ collapsed ? item.icon : item.name }}
          </NuxtLink>
        </li>
        <li>
<button @click="handleLogout" class="logout-btn">
  {{ collapsed ? '🚪' : 'Cerrar sesión' }}
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

function handleLogout() {
  auth.logout()
  router.push('/login') // o la ruta de tu página de inicio de sesión
}


const collapsed = ref(false)
const menu = [
  { name: 'Dashboard', to: '/dashboard', icon: '📊' },
  { name: 'Usuarios', to: '/usuarios', icon: '👤' },
  { name: 'Roles', to: '/roles', icon: '⚙️' },
  { name: 'personas', to: '/personas', icon: '👤' },
  { name: 'Permisos', to: '/permisos', icon: '⚙️' },
  { name: 'Roles Permisos', to: '/roles-permisos', icon: '⚙️' },
  { name: 'Logs usuarios', to: '/logs-usuarios', icon: '⚙️' },
  { name: 'tokens', to: '/tokens', icon: '⚙️' },
  { name: 'tipos perfil', to: '/tipos_perfil', icon: '⚙️' },
  { name: 'perfiles', to: '/perfiles', icon: '⚙️' },
  { name: 'configuraciones', to: '/configuraciones', icon: '⚙️' },
  

]
</script>

<style scoped lang="scss">
@import "@/assets/styles/_variables.scss";
.sidebar {
  padding: 1rem;
  .toggle {
    background: none;
    border: none;
    font-size: 1.5rem;
    margin-bottom: 1rem;
    cursor: pointer;
    color: var(--text-color);
  }
  ul {
    list-style: none;
    padding: 0;
    li {
      margin: 1rem 0;
      a {
        color: var(--text-color);
        text-decoration: none;
        display: block;
        &:hover {
          color: $color-accent;
        }
      }
    }
  }
}
.logout-btn {
  background: none;
  border: none;
  color: var(--text-color);
  font-size: 1rem;
  cursor: pointer;
  text-align: left;
  padding: 0;
  &:hover {
    color: $color-accent;
  }
}

</style>
