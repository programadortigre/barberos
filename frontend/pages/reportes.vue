<template>
    <div class="ventas-container">
        <!-- Header fijo -->
        <header class="header">
            <h1>💰 Reportes</h1>
            <input v-model="busqueda" type="search" placeholder="Buscar venta..." class="search-input"
                aria-label="Buscar ventas" />
            <button class="btn-nueva" @click="abrirFormularioNuevaVenta" aria-label="Nueva venta">
                ➕ Nueva venta
            </button>
        </header>

        <!-- Lista de ventas en estilo tiles -->
        <main class="tiles-list" role="list" aria-live="polite">
            <div v-for="venta in ventasFiltradas" :key="venta.id" class="tile" role="listitem" tabindex="0"
                @keydown.enter="verDetalle(venta)"
                aria-label="Venta de {{ venta.cliente }}, total S/ {{ venta.total.toFixed(2) }}, estado {{ venta.estado }}">
                <div class="tile-header">
                    <span class="tile-index">#{{ venta.id }}</span>
                    <span class="tile-fecha">{{ venta.fecha }}</span>
                </div>
                <div class="tile-body">
                    <div class="tile-cliente">👤 {{ venta.cliente }}</div>
                    <div class="tile-total">💵 S/ {{ venta.total.toFixed(2) }}</div>
                    <div class="tile-estado" :class="venta.estado.toLowerCase()">{{ venta.estado }}</div>
                </div>
                <div class="tile-actions">
                    <button @click.stop="verDetalle(venta)" aria-label="Ver detalles">👁️</button>
                    <button @click.stop="editarVenta(venta)" aria-label="Editar">✏️</button>
                    <button @click.stop="eliminarVenta(venta.id)" aria-label="Eliminar">🗑️</button>
                    <!-- Botón para mostrar vista expandida modal -->
                    <button @click.stop="openVentaDetail(venta)" aria-label="Expandir información">
                        🔽
                    </button>
                </div>
            </div>

            <p v-if="ventasFiltradas.length === 0" class="no-resultados">
                No se encontraron ventas.
            </p>
        </main>

        <!-- Panel modal para vista extendida (70% ancho) -->
        <transition name="fade">
            <div class="venta-modal" v-if="selectedVenta">
                <div class="venta-modal-content">
                    <button class="modal-close" @click="closeModal" aria-label="Cerrar detalles">✖️</button>
                    <h2>Detalles de venta #{{ selectedVenta.id }}</h2>
                    <p><strong>Cliente:</strong> {{ selectedVenta.cliente }}</p>
                    <p><strong>Fecha:</strong> {{ selectedVenta.fecha }}</p>
                    <p><strong>Total:</strong> S/ {{ selectedVenta.total.toFixed(2) }}</p>
                    <p><strong>Estado:</strong> {{ selectedVenta.estado }}</p>
                    <p>
                        Aquí puedes agregar información adicional de la venta, por ejemplo, productos, métodos
                        de pago, etc.
                    </p>
                </div>
            </div>
        </transition>
    </div>
</template>

<script setup lang="ts">
    import { ref, computed } from 'vue'
    definePageMeta({ layout: 'aplicacion' })

    const ventas = ref([
        { id: 1, fecha: '2025-06-01', cliente: 'Juan Pérez', total: 120.5, estado: 'Pagado' },
        { id: 2, fecha: '2025-06-02', cliente: 'Ana López', total: 80, estado: 'Pendiente' },
        { id: 3, fecha: '2025-06-03', cliente: 'Carlos Ruiz', total: 150, estado: 'Pagado' }
    ])

    const busqueda = ref('')

    const ventasFiltradas = computed(() => {
        if (!busqueda.value) return ventas.value
        return ventas.value.filter(v =>
            v.cliente.toLowerCase().includes(busqueda.value.toLowerCase()) ||
            v.estado.toLowerCase().includes(busqueda.value.toLowerCase()) ||
            v.fecha.includes(busqueda.value)
        )
    })

    // Venta seleccionada para vista detallada (modal)
    const selectedVenta = ref < any > (null)

    function openVentaDetail(venta: any) {
        selectedVenta.value = venta
    }

    function closeModal() {
        selectedVenta.value = null
    }

    function abrirFormularioNuevaVenta() {
        alert('Abrir formulario para nueva venta')
    }

    function verDetalle(venta: any) {
        alert(`Detalles:\nCliente: ${venta.cliente}\nFecha: ${venta.fecha}\nTotal: S/ ${venta.total}\nEstado: ${venta.estado}`)
    }

    function editarVenta(venta: any) {
        alert(`Editar venta ID ${venta.id}`)
    }

    function eliminarVenta(id: number) {
        if (confirm('¿Seguro que quieres eliminar esta venta?')) {
            ventas.value = ventas.value.filter(v => v.id !== id)
        }
    }
</script>

<style scoped lang="scss">
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    .ventas-container {
        height: 100vh;
        display: flex;
        flex-direction: column;
        background: #fafafa;
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
            Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        color: #222;
    }

    /* Header */
    .header {
        background: #fff;
        padding: 1.25rem 2rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        border-bottom: 1px solid #e3e6e8;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .header h1 {
        flex-grow: 1;
        font-weight: 700;
        font-size: 1.8rem;
        color: #111;
        user-select: none;
    }

    .search-input {
        flex: 1 1 300px;
        padding: 0.5rem 1rem;
        border: 1.5px solid #d1d5db;
        border-radius: 9999px;
        font-size: 1rem;
        transition: border-color 0.25s ease;
        background: #f9fafb;
        color: #444;
    }

    .search-input::placeholder {
        color: #a1a1aa;
    }

    .search-input:focus {
        border-color: #3b82f6;
        outline: none;
        background: #fff;
        box-shadow: 0 0 8px rgba(59, 130, 246, 0.3);
    }

    .btn-nueva {
        background: #3b82f6;
        color: white;
        font-weight: 600;
        padding: 0.55rem 1.5rem;
        border-radius: 9999px;
        font-size: 1rem;
        border: none;
        cursor: pointer;
        box-shadow: 0 4px 6px rgba(59, 130, 246, 0.4);
        transition: background-color 0.25s ease, box-shadow 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        user-select: none;
    }

    .btn-nueva:hover,
    .btn-nueva:focus {
        background: #2563eb;
        box-shadow: 0 6px 12px rgba(37, 99, 235, 0.5);
        outline: none;
    }

    .btn-nueva:active {
        background: #1e40af;
        box-shadow: none;
        transform: scale(0.95);
    }

    /* Lista tiles */
    .tiles-list {
        flex-grow: 1;
        overflow-y: auto;
        padding: 1.5rem 2rem;
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 1.25rem;
        scroll-padding-top: 80px;
    }

    /* Tile */
    .tile {
        background: white;
        border-radius: 12px;
        padding: 1.5rem 1.8rem;
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        cursor: pointer;
        transition: box-shadow 0.25s ease, transform 0.15s ease;
        user-select: none;
    }

    .tile:hover,
    .tile:focus-visible {
        box-shadow: 0 8px 24px rgba(59, 130, 246, 0.2);
        transform: translateY(-4px);
        outline: none;
    }

    /* Header tile */
    .tile-header {
        display: flex;
        justify-content: space-between;
        color: #3b82f6;
        font-weight: 700;
        font-size: 1.1rem;
        margin-bottom: 1rem;
    }

    .tile-index {
        opacity: 0.7;
    }

    .tile-fecha {
        font-weight: 500;
        color: #6b7280;
        font-size: 0.95rem;
    }

    /* Body tile */
    .tile-body {
        flex-grow: 1;
        font-size: 1rem;
        line-height: 1.5;
        color: #374151;
        margin-bottom: 1rem;
    }

    .tile-body>div {
        margin-bottom: 0.65rem;
        display: flex;
        align-items: center;
        gap: 0.4rem;
    }

    .tile-cliente {
        font-weight: 600;
    }

    .tile-total {
        font-weight: 700;
        color: #111827;
        font-size: 1.1rem;
    }

    .tile-estado {
        display: inline-block;
        padding: 0.3rem 0.85rem;
        border-radius: 9999px;
        font-weight: 700;
        text-transform: uppercase;
        font-size: 0.85rem;
        color: white;
        user-select: none;
        box-shadow: 0 0 8px rgba(0, 0, 0, 0.12);
    }

    .tile-estado.pagado {
        background: #22c55e;
        /* Verde brillante */
        box-shadow: 0 0 12px #22c55eaa;
    }

    .tile-estado.pendiente {
        background: #facc15;
        /* Amarillo dorado */
        box-shadow: 0 0 12px #facc15aa;
    }

    /* Acciones */
    .tile-actions {
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
    }

    .tile-actions button {
        background: transparent;
        border: none;
        font-size: 1.3rem;
        cursor: pointer;
        color: #6b7280;
        transition: color 0.25s ease, transform 0.15s ease;
        padding: 0.25rem;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .tile-actions button:hover,
    .tile-actions button:focus-visible {
        color: #3b82f6;
        outline: none;
        transform: scale(1.2);
    }

    .tile-actions button:active {
        transform: scale(1.1);
    }

    /* Mensaje no resultados */
    .no-resultados {
        grid-column: 1 / -1;
        text-align: center;
        font-weight: 600;
        font-size: 1.25rem;
        color: #9ca3af;
        margin-top: 3rem;
    }

    /* Modal de venta expandida */
    .venta-modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 200;
    }

    .venta-modal-content {
        background: white;
        width: 70%;
        max-width: 800px;
        padding: 2rem;
        border-radius: 12px;
        position: relative;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
    }

    .modal-close {
        position: absolute;
        top: 1rem;
        right: 1rem;
        background: transparent;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
    }

    /* Transición para el modal */
    .fade-enter-active,
    .fade-leave-active {
        transition: opacity 0.3s ease;
    }

    .fade-enter-from,
    .fade-leave-to {
        opacity: 0;
    }

    /* Responsive móvil */
    @media (max-width: 480px) {
        .tiles-list {
            grid-template-columns: 1fr !important;
            padding: 1rem 1rem;
        }

        .header {
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1 1 100%;
            margin-bottom: 0.75rem;
        }

        .btn-nueva {
            flex: 1 1 100%;
        }

        .venta-modal-content {
            width: 90%;
        }
    }
</style>