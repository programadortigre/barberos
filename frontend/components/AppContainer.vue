<template>
  <div class="admin-layout">
    <Sidebar />
    <div class="content">
      <Topbar />
      <main class="main">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import Sidebar from './Sidebar.vue'
import Topbar from './Topbar.vue'
</script>
