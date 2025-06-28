<script setup lang="ts">
definePageMeta({ layout: 'admin' })
</script>
<template>
  <section class="dashboard">
    <header class="dashboard-header">
      <h1>👋 Bienvenido a tu oficina digital</h1>
      <p>Controla tu negocio desde un solo lugar — incluso sin internet.</p>
    </header>

    <!-- 📦 Operaciones Diarias -->
    <section>
      <h2 class="section-title">📦 Operaciones Diarias</h2>
      <div class="dashboard-grid">
        <NuxtLink to="/ventas" class="dashboard-card">
          <h3>🧾 Ventas</h3>
          <p>Registra ventas rápidas, crea boletas simples o manuales.</p>
        </NuxtLink>
        <NuxtLink to="/productos" class="dashboard-card">
          <h3>📦 Productos</h3>
          <p>Agrega productos, fotos, precios y control de stock.</p>
        </NuxtLink>
        <NuxtLink to="/clientes" class="dashboard-card">
          <h3>👤 Clientes</h3>
          <p>Historial de compras, contactos, seguimiento y deudas.</p>
        </NuxtLink>
        <NuxtLink to="/colaboradores" class="dashboard-card">
          <h3>👥 Colaboradores</h3>
          <p>Turnos, préstamos o sueldos de ayudantes y familiares.</p>
        </NuxtLink>
      </div>
    </section>

    <!-- 💰 Finanzas y Ahorros -->
    <section>
      <h2 class="section-title">💰 Finanzas y Ahorros</h2>
      <div class="dashboard-grid">
        <NuxtLink to="/finanzas" class="dashboard-card">
          <h3>📒 Ingresos y Egresos</h3>
          <p>Registra gastos diarios, ingresos, préstamos o pérdidas.</p>
        </NuxtLink>
        <NuxtLink to="/caja" class="dashboard-card">
          <h3>💵 Caja diaria</h3>
          <p>Abre, registra movimientos y cierra caja cada día o turno.</p>
        </NuxtLink>
        <NuxtLink to="/ahorros" class="dashboard-card">
          <h3>🎯 Objetivos de ahorro</h3>
          <p>Ahorra para un celular, nuevo horno o mejoras de negocio.</p>
        </NuxtLink>
        <NuxtLink to="/reportes" class="dashboard-card">
          <h3>📈 Reportes</h3>
          <p>Visualiza gráficos mensuales, ingresos netos, alertas y más.</p>
        </NuxtLink>
      </div>
    </section>

    <!-- 📅 Organización -->
    <section>
      <h2 class="section-title">📅 Organización</h2>
      <div class="dashboard-grid">
        <NuxtLink to="/calendario" class="dashboard-card">
          <h3>📅 Calendario</h3>
          <p>Agrega recordatorios, entregas, reuniones o citas.</p>
        </NuxtLink>
        <NuxtLink to="/notas" class="dashboard-card">
          <h3>📝 Notas</h3>
          <p>Guarda ideas, tareas pendientes y notas personales.</p>
        </NuxtLink>
        <NuxtLink to="/fotos" class="dashboard-card">
          <h3>📷 Galería</h3>
          <p>Sube fotos de productos, clientes o mejoras.</p>
        </NuxtLink>
        <NuxtLink to="/compras" class="dashboard-card">
          <h3>🛒 Lista de compras</h3>
          <p>Organiza pedidos o compras a tus proveedores.</p>
        </NuxtLink>
      </div>
    </section>

    <!-- ⚙️ Herramientas -->
    <section>
      <h2 class="section-title">⚙️ Herramientas</h2>
      <div class="dashboard-grid">
        <NuxtLink to="/sincronizacion" class="dashboard-card">
          <h3>🔄 Sincronización</h3>
          <p>Conexión automática cuando haya internet disponible.</p>
        </NuxtLink>
        <NuxtLink to="/woocommerce" class="dashboard-card">
          <h3>🌐 Tienda Online (Woo)</h3>
          <p>Envía tus productos a tu tienda en WordPress automáticamente.</p>
        </NuxtLink>
        <NuxtLink to="/configuracion" class="dashboard-card">
          <h3>⚙️ Configuración</h3>
          <p>Idioma, moneda, exportar datos, respaldo, seguridad.</p>
        </NuxtLink>
      </div>
    </section>
  </section>
</template>

<style scoped lang="scss">
.dashboard {
  padding: 2rem;

  .dashboard-header {
    margin-bottom: 2rem;
    h1 {
      font-size: 2.2rem;
      margin-bottom: 0.5rem;
    }
    p {
      color: #666;
    }
  }

  .section-title {
    font-size: 1.3rem;
    margin-top: 2.5rem;
    margin-bottom: 1rem;
    font-weight: 600;
    color: #333;
  }

  .dashboard-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1.25rem;
  }

  .dashboard-card {
    background: var(--card-bg, #fff);
    padding: 1.25rem;
    border-radius: 0.75rem;
    text-decoration: none;
    color: inherit;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
    transition: transform 0.15s ease;

    h3 {
      font-size: 1.05rem;
      margin-bottom: 0.5rem;
    }

    p {
      font-size: 0.85rem;
      color: #555;
    }

    &:hover {
      transform: translateY(-3px);
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    @media (prefers-color-scheme: dark) {
      background-color: #1a1a1a;
      color: #eee;
      p {
        color: #aaa;
      }
    }
  }
}
</style>
