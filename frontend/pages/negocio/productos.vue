<script setup>
definePageMeta({ layout: 'aplicacion' });

import { ref, computed } from 'vue';
import CardItem from '@/components/ui/CardItem.vue';
import { useStockBar } from '@/composables/useStockBar';
const { getStockInfo } = useStockBar();

const products = ref([
    {
        id: 1,
        name: "Laptop HP ProBook",
        sku: "LAP-HP-001",
        img: "fas fa-laptop",
        price: 899.99,
        stock: 0,
        min: 10,
        category: "Tecnología"
    },
    {
        id: 2,
        name: "Smartphone Samsung S21",
        sku: "PHN-SS-002",
        img: "fas fa-mobile-alt",
        price: 749.99,
        stock: 8,
        min: 5,
        category: "Tecnología"
    },
    {
        id: 3,
        name: "Tablet iPad Air",
        sku: "TAB-IPAD-003",
        img: "fas fa-tablet-alt",
        price: 599.99,
        stock: 12,
        min: 8,
        category: "Tecnología"
    },
    {
        id: 4,
        name: "Monitor 24\" Full HD",
        sku: "MON-FHD-004",
        img: "fas fa-desktop",
        price: 199.99,
        stock: 5,
        min: 4,
        category: "Tecnología"
    },
    {
        id: 5,
        name: "Teclado Inalámbrico",
        sku: "KEY-WL-005",
        img: "fas fa-keyboard",
        price: 59.99,
        stock: 22,
        min: 10,
        category: "Accesorios"
    },
    {
        id: 6,
        name: "Mouse Ergonómico",
        sku: "MSE-ERG-006",
        img: "fas fa-mouse",
        price: 39.99,
        stock: 30,
        min: 12,
        category: "Accesorios"
    },
    {
        id: 7,
        name: "Impresora Multifuncional",
        sku: "PRT-MULTI-007",
        img: "fas fa-print",
        price: 129.99,
        stock: 7,
        min: 5,
        category: "Oficina"
    },
    {
        id: 8,
        name: "Disco Duro Externo 1TB",
        sku: "HDD-EXT1TB-008",
        img: "fas fa-hdd",
        price: 69.99,
        stock: 18,
        min: 10,
        category: "Almacenamiento"
    }
]);

const filteredProducts = computed(() => products.value);
</script>

<template>
    <div class="container">
        <div class="content">
            <CardItem v-for="product in filteredProducts" :key="product.id" :title="product.name"
                :subtitle="product.category" :details="[
                    { label: 'SKU', value: product.sku },
                    { label: 'Precio', value: 'S/ ' + product.price.toFixed(2) },
                    { label: 'Stock', value: product.stock }
                ]" :icon="product.img" :item="product" :getStatusInfo="getStockInfo" :actions="[
    { label: 'Editar', class: 'btn-verde', onClick: () => editar(product) },
    { label: 'Eliminar', class: 'btn-rojo', onClick: () => eliminar(product) }
]" />

        </div>
    </div>
</template>
