<script setup>
definePageMeta({ layout: 'aplicacion' })

import { useAuthStore } from '~/stores/auth'
import { computed, onMounted } from 'vue'

const auth = useAuthStore()

// Asegúrate de cargar el usuario si no está aún
onMounted(async () => {
  if (!auth.user) {
    await auth.init()
  }
})

const user = computed(() => auth.user)
</script>
<template>

  <div class="container">
    <div class="content">
      <!-- Bienvenida Mejorada -->
      <div class="welcome-card">
        <h1 class="welcome-title">¡Bienvenido de nuevo!</h1>
        <p class="welcome-subtitle">Aquí tienes un resumen actualizado de tu negocio</p>

        <div class="welcome-stats">
          <div class="stat-card">
            <div class="value">$1,250</div>
            <div class="label">Ventas hoy</div>
          </div>
          <div class="stat-card">
            <div class="value">5</div>
            <div class="label">Citas</div>
          </div>
          <div class="stat-card">
            <div class="value">$8,450</div>
            <div class="label">Ingresos mes</div>
          </div>
          <div class="stat-card">
            <div class="value">3</div>
            <div class="label">Alertas</div>
          </div>
        </div>
      </div>

      <!-- Accesos Rápidos Mejorados -->
      <h2 class="section-title">
        <i class="fas fa-bolt"></i> Accesos Rápidos
      </h2>
      <div class="quick-access">
        <div class="quick-item">
          <i class="fas fa-cash-register"></i>
          <p>Nueva Venta</p>
        </div>
        <div class="quick-item">
          <i class="fas fa-user-plus"></i>
          <p>Agregar Cliente</p>
        </div>
        <div class="quick-item">
          <i class="fas fa-calendar-plus"></i>
          <p>Nueva Cita</p>
        </div>
        <div class="quick-item">
          <i class="fas fa-box-open"></i>
          <p>Agregar Producto</p>
        </div>
        <div class="quick-item">
          <i class="fas fa-receipt"></i>
          <p>Registrar Gasto</p>
        </div>
        <div class="quick-item">
          <i class="fas fa-chart-pie"></i>
          <p>Ver Reportes</p>
        </div>
      </div>

      <!-- Todos los Módulos Mejorados -->
      <h2 class="section-title">
        <i class="fas fa-th-large"></i> Todos los Módulos
      </h2>
      <div class="modules-grid">
        <!-- Ventas -->
        <div class="module-card">
          <div class="icon blue">
            <i class="fas fa-shopping-cart"></i>
          </div>
          <h3>Ventas</h3>
          <p>Registra y gestiona tus ventas</p>
        </div>

        <!-- Compras -->
        <div class="module-card">
          <div class="icon purple">
            <i class="fas fa-file-invoice-dollar"></i>
          </div>
          <h3>Compras</h3>
          <p>Controla tus compras</p>
        </div>

        <!-- Pedidos -->
        <div class="module-card">
          <div class="icon green">
            <i class="fas fa-clipboard-list"></i>
          </div>
          <h3>Pedidos</h3>
          <p>Seguimiento de pedidos</p>
        </div>

        <!-- Catálogo / Menú -->
        <div class="module-card">
          <div class="icon orange">
            <i class="fas fa-book"></i>
          </div>
          <h3>Catálogo</h3>
          <p>Gestiona tus productos</p>
        </div>

        <!-- Reservas de Habitaciones -->
        <div class="module-card">
          <div class="icon red">
            <i class="fas fa-bed"></i>
          </div>
          <h3>Reservas</h3>
          <p>Administra habitaciones</p>
        </div>

        <!-- Servicios Ofrecidos -->
        <div class="module-card">
          <div class="icon teal">
            <i class="fas fa-tools"></i>
          </div>
          <h3>Servicios</h3>
          <p>Gestiona servicios</p>
        </div>
      </div>

      <!-- Actividad Reciente Mejorada -->
      <h2 class="section-title">
        <i class="fas fa-history"></i> Actividad Reciente
      </h2>
      <div class="recent-activity">
        <ul class="activity-list">
          <li class="activity-item activity-sales">
            <div class="activity-icon">
              <i class="fas fa-shopping-cart"></i>
            </div>
            <div class="activity-content">
              <div class="activity-title">Nueva venta registrada <i class="fas fa-check-circle"></i></div>
              <div class="activity-description">Venta #00128 por $125.00 a María Rodríguez</div>
              <div class="activity-time"><i class="fas fa-clock"></i> Hace 15 minutos</div>
            </div>
          </li>

          <li class="activity-item activity-appointment">
            <div class="activity-icon">
              <i class="fas fa-calendar-day"></i>
            </div>
            <div class="activity-content">
              <div class="activity-title">Cita confirmada <i class="fas fa-check-circle"></i></div>
              <div class="activity-description">Carlos Sánchez confirmó cita para mañana a las 10:00 AM
              </div>
              <div class="activity-time"><i class="fas fa-clock"></i> Hace 1 hora</div>
            </div>
          </li>

          <li class="activity-item activity-payment">
            <div class="activity-icon">
              <i class="fas fa-credit-card"></i>
            </div>
            <div class="activity-content">
              <div class="activity-title">Pago recibido <i class="fas fa-check-circle"></i></div>
              <div class="activity-description">Pedro Gómez pagó $350.00 por la venta #00125</div>
              <div class="activity-time"><i class="fas fa-clock"></i> Hace 3 horas</div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </div>

</template>
<style>
/* TARJETA DE BIENVENIDA MEJORADA */
.welcome-card {
  background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
  border-radius: var(--radius-lg);
  box-shadow: var(--elevation);
  padding: 24px;
  position: relative;
  overflow: hidden;
  color: white;
  margin-top: 8px;
  z-index: 1;
}

.welcome-card::before {
  content: "";
  position: absolute;
  top: 0;
  right: 0;
  width: 120px;
  height: 120px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  transform: translate(40%, -40%);
}

.welcome-card::after {
  content: "";
  position: absolute;
  bottom: -20px;
  right: -20px;
  width: 80px;
  height: 80px;
  background: rgba(255, 255, 255, 0.07);
  border-radius: 50%;
}

.welcome-title {
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 8px;
  position: relative;
  z-index: 2;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}

.welcome-subtitle {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.85);
  margin-bottom: 24px;
  position: relative;
  z-index: 2;
  max-width: 80%;
}

.welcome-stats {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
  position: relative;
  z-index: 2;
}

.stat-card {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
  border-radius: var(--radius-sm);
  padding: 16px;
  text-align: center;
  transition: var(--transition);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.stat-card:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: translateY(-3px);
}

.stat-card .value {
  font-size: 20px;
  font-weight: 700;
  margin-bottom: 4px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.stat-card .label {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.9);
}

/* ACCESOS RÁPIDOS MEJORADOS - NUEVO DISEÑO */
.section-title {
  font-size: 18px;
  font-weight: 700;
  margin: 8px 0 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--light-gray);
  display: flex;
  align-items: center;
  color: var(--dark);
}

.section-title i {
  margin-right: 10px;
  color: var(--primary);
  background: var(--primary-light);
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
}

.quick-access {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 8px;
}

.quick-item {
  background: var(--lighter);
  border-radius: var(--radius);
  box-shadow: var(--card-shadow);
  padding: 20px 12px;
  text-align: center;
  transition: var(--transition);
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  border: 1px solid rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;
}

.quick-item::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 4px;
  background: var(--primary);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.3s ease;
}

.quick-item:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 20px rgba(0, 0, 0, 0.1);
  border-color: var(--primary-light);
}

.quick-item:hover::before {
  transform: scaleX(1);
}

.quick-item i {
  font-size: 24px;
  color: white;
  margin-bottom: 16px;
  width: var(--icon-size);
  height: var(--icon-size);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
  box-shadow: 0 6px 12px rgba(67, 97, 238, 0.25);
  transition: var(--transition);
  z-index: 1;
}

.quick-item:hover i {
  transform: scale(1.1);
  box-shadow: 0 8px 16px rgba(67, 97, 238, 0.35);
}

.quick-item p {
  font-size: 13px;
  font-weight: 600;
  color: var(--dark);
  z-index: 1;
}

/* MÓDULOS MEJORADOS - DISEÑO PREMIUM */
.modules-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 8px;
}

.module-card {
  background: var(--lighter);
  border-radius: var(--radius);
  box-shadow: var(--card-shadow);
  padding: 20px 12px 16px;
  transition: var(--transition);
  cursor: pointer;
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.module-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
  border-color: var(--primary-light);
}

.module-card::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 4px;
  background: var(--primary);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.4s ease;
}

.module-card:hover::after {
  transform: scaleX(1);
}

.module-card .icon {
  width: var(--icon-size);
  height: var(--icon-size);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
  font-size: 22px;
  color: white;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
  transition: var(--transition);
  position: relative;
  z-index: 1;
}

.module-card:hover .icon {
  transform: scale(1.1);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.module-card .icon.blue {
  background: linear-gradient(135deg, var(--primary) 0%, #5e72e4 100%);
}

.module-card .icon.purple {
  background: linear-gradient(135deg, var(--secondary) 0%, #9c27b0 100%);
}

.module-card .icon.green {
  background: linear-gradient(135deg, var(--success) 0%, #2dce89 100%);
}

.module-card .icon.orange {
  background: linear-gradient(135deg, var(--warning) 0%, #fb6340 100%);
}

.module-card .icon.red {
  background: linear-gradient(135deg, var(--danger) 0%, #f5365c 100%);
}

.module-card .icon.teal {
  background: linear-gradient(135deg, #00b4d8 0%, #0077b6 100%);
}

.module-card h3 {
  font-size: 14px;
  font-weight: 700;
  margin-bottom: 6px;
  color: var(--dark);
  position: relative;
  z-index: 1;
}

.module-card p {
  font-size: 12px;
  color: var(--gray);
  line-height: 1.4;
  position: relative;
  z-index: 1;
}

/* ACTIVIDAD RECIENTE MEJORADA */
.recent-activity {
  background: var(--lighter);
  border-radius: var(--radius);
  box-shadow: var(--card-shadow);
  padding: 20px;
  margin-bottom: 16px;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.activity-list {
  list-style: none;
}

.activity-item {
  display: flex;
  padding: 16px 0;
  border-bottom: 1px solid var(--border);
  transition: var(--transition);
  position: relative;
}

.activity-item:last-child {
  border-bottom: none;
}

.activity-item:hover {
  background: rgba(0, 0, 0, 0.02);
  border-radius: var(--radius-sm);
  padding: 16px 12px;
  margin: 0 -12px;
}

.activity-icon {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  font-size: 18px;
  color: white;
  flex-shrink: 0;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.activity-sales .activity-icon {
  background: linear-gradient(135deg, var(--primary) 0%, #5e72e4 100%);
}

.activity-appointment .activity-icon {
  background: linear-gradient(135deg, var(--secondary) 0%, #9c27b0 100%);
}

.activity-inventory .activity-icon {
  background: linear-gradient(135deg, var(--warning) 0%, #fb6340 100%);
}

.activity-payment .activity-icon {
  background: linear-gradient(135deg, var(--success) 0%, #2dce89 100%);
}

.activity-content {
  flex: 1;
}

.activity-title {
  font-weight: 700;
  margin-bottom: 6px;
  font-size: 15px;
  color: var(--dark);
  display: flex;
  align-items: center;
}

.activity-title i {
  margin-left: 8px;
  font-size: 12px;
  color: var(--success);
}

.activity-description {
  font-size: 13px;
  color: var(--gray);
  line-height: 1.5;
}

.activity-time {
  font-size: 12px;
  color: var(--gray);
  font-weight: 500;
  margin-top: 8px;
  display: flex;
  align-items: center;
}

.activity-time i {
  margin-right: 6px;
  font-size: 12px;
}


/* RESPONSIVE MEJORADO */
@media (min-width: 400px) {
  .container {
    max-width: 400px;
    margin: 0 auto;
  }
}

@media (min-width: 768px) {
  :root {
    --header-height: 70px;
    --nav-height: 80px;
    --icon-size: 56px;
  }

  .container {
    max-width: 480px;
  }

  .quick-access {
    grid-template-columns: repeat(3, 1fr);
  }

  .modules-grid {
    grid-template-columns: repeat(3, 1fr);
  }

  .welcome-stats {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* ANIMACIONES Y EFECTOS */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.welcome-card,
.section-title,
.quick-access,
.modules-grid,
.recent-activity {
  animation: fadeIn 0.5s ease-out forwards;
}

.quick-access {
  animation-delay: 0.1s;
}

.modules-grid {
  animation-delay: 0.2s;
}

.recent-activity {
  animation-delay: 0.3s;
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }

  50% {
    transform: scale(1.05);
  }

  100% {
    transform: scale(1);
  }
}

.pulse {
  animation: pulse 2s infinite;
}

/* ESTADOS ACTIVOS Y EFECTOS */
.quick-item:active,
.module-card:active,
.activity-item:active {
  transform: scale(0.97);
  transition: transform 0.1s ease;
}

/* SCROLL PERSONALIZADO */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.05);
}

::-webkit-scrollbar-thumb {
  background: var(--primary);
  border-radius: 10px;
}

/* MEJORA DE RENDIMIENTO */
.will-change {
  will-change: transform, opacity;
}
</style>