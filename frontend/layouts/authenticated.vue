<script setup lang="ts">
const auth = useAuthStore()

onMounted(async () => {
  await auth.init()

  if (!auth.token) {
    return navigateTo('/login')
  }
})
</script>

<template>
  <div class="layout-authenticated">
    <header>
      <h1>Bienvenido, {{ auth.user?.persona?.nombres }}</h1>
      <p>Rol: {{ auth.user?.rol?.nombre }}</p>
      <button @click="auth.logout(); navigateTo('/login')">Cerrar sesión</button>
    </header>

    <main>
      <slot />
    </main>
  </div>
</template>

<style scoped lang="scss">
.layout-authenticated {
  header {
    background: #111;
    color: white;
    padding: 1rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  main {
    padding: 2rem;
  }

  button {
    background: crimson;
    color: white;
    border: none;
    padding: 0.5rem 1rem;
    cursor: pointer;
    border-radius: 4px;

    &:hover {
      background: darkred;
    }
  }
}
</style>
