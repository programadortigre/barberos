<script setup>
definePageMeta({ layout: 'aplicacion' });
import { ref } from 'vue';
import CardItem from '@/components/ui/CardItem.vue';

const clients = ref([
    {
        id: 1,
        name: "María Cortés",
        email: "maria.c@ejemplo.com",
        phone: "555-1234",
        notes: "Cliente frecuente - Prefiere pago con tarjeta"
    },
    {
        id: 2,
        name: "Carlos Rodríguez",
        email: "carlos.r@ejemplo.com",
        phone: "555-5678",
        notes: "Prefiere factura"
    }
]);
</script>

<template>
    <div class="container">
        <div class="content">
            <div class="summary-cards">
                <div class="summary-card total">
                    <div class="label">Ventas hoy</div>
                    <div class="value">$1,250</div>
                    <div class="label">5 ventas</div>
                </div>
                <div class="summary-card completed">
                    <div class="label">Completadas</div>
                    <div class="value">$8,450</div>
                    <div class="label">32 ventas</div>
                </div>
                <div class="summary-card pending">
                    <div class="label">Pendientes</div>
                    <div class="value">$890</div>
                    <div class="label">3 ventas</div>
                </div>
            </div>

            <h2>Clientes</h2>
            <p>Lista de clientes registrados</p>

            <ul class="clientes">
                <CardItem v-for="client in clients" :key="client.id" :icon="'fas fa-user-circle'" :title="client.name"
                    :subtitle="client.email" :details="[
                        { label: 'Teléfono', value: client.phone },
                        { label: 'Notas', value: client.notes }
                    ]" :item="client" />
            </ul>
        </div>
    </div>
</template>

<style scoped lang="scss">
.summary-cards {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
    padding: 20px 15px;

    .summary-card {
        background: white;
        border-radius: 16px;
        box-shadow: var(--card-shadow);
        padding: 20px;
        text-align: center;
        transition: transform 0.3s ease;

        .value {
            font-size: 24px;
            font-weight: 700;
            margin: 10px 0 5px;
        }

        .label {
            font-size: 14px;
            color: var(--gray);
        }
    }

    .total .value {
        color: var(--primary);
    }

    .completed .value {
        color: var(--success);
    }

    .pending .value {
        color: var(--warning);
    }

    .summary-card:hover {
        transform: translateY(-5px);
    }
}

@media (min-width: 480px) {
    .summary-cards {
        grid-template-columns: repeat(3, 1fr);
    }
}
</style>
