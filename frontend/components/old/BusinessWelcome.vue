<template>
  <section class="welcome-container">
    <div class="card">
      <img v-if="logo" :src="logo" alt="Logo del negocio" class="logo" />
      <img v-if="business.logo" :src="business.logo" alt="Logo del negocio" class="logo" />

      <h1 class="title">🎉 ¡Negocio creado con éxito!</h1>
      <p class="subtitle">Bienvenido, <strong>{{ business.name }}</strong></p>
      <p class="rubro">🧩 Rubro: {{ business.category }}</p>

      <ul class="actions">
        <li><button @click="goToModules">🔧 Revisar módulos</button></li>
        <li><button @click="goToTeam">👥 Agregar empleados</button></li>
        <li><button @click="goToProducts">🛍️ Cargar productos</button></li>
        <li><button @click="goToFinance">📈 Empezar a registrar ingresos</button></li>
        <li><button @click="goToAgenda">📅 Agendar una cita o recordatorio</button></li>
      </ul>

      <button class="primary" @click="goToDashboard">
        🚀 Ir al panel principal
      </button>
    </div>
  </section>
</template>

<script setup>
import { useBusiness } from '@/composables/useBusiness'
const { business } = useBusiness()
</script>

<style scoped>
.welcome-container {
  display: grid;
  place-items: center;
  padding: 2rem;
}

.card {
  background: white;
  color: #1f2937;
  border-radius: 1.5rem;
  padding: 2rem;
  max-width: 500px;
  width: 100%;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.07);
  text-align: center;
}

.logo {
  width: 80px;
  height: 80px;
  object-fit: contain;
  margin-bottom: 1rem;
}

.title {
  font-size: 1.8rem;
  margin-bottom: 0.5rem;
}

.subtitle {
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
}

.rubro {
  font-size: 1rem;
  margin-bottom: 1rem;
  color: #4b5563;
}

.desc {
  font-weight: 600;
  margin: 1.5rem 0 1rem;
}

.actions {
  list-style: none;
  padding: 0;
  margin: 0 0 2rem;
  display: grid;
  gap: 0.5rem;
}

.actions button {
  width: 100%;
  background: #f3f4f6;
  color: #111827;
  border: 1px solid #e5e7eb;
  padding: 0.75rem;
  border-radius: 10px;
  transition: background 0.2s;
}

.actions button:hover {
  background: #e5e7eb;
}

.primary {
  background: #2563eb;
  color: white;
  font-weight: bold;
  border: none;
  padding: 1rem;
  width: 100%;
  border-radius: 10px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}

.primary:hover {
  background: #1d4ed8;
}
</style>
