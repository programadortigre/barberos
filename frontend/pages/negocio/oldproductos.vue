<script setup>
definePageMeta({ layout: 'aplicacion' })

import { ref, reactive, computed, onMounted } from 'vue';

import ProductCard from '@/components/negocio/ProductCard.vue'
const filteredProducts = computed(() => products.value);

// Datos de productos
let info = null;
const products = ref([
    {
        id: 1,
        name: "Laptop HP ProBook",
        sku: "LAP-HP-001",
        img: "fas fa-laptop",
        price: 899.99,
        stock: 10,
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

</script>
<template>

    <div class="container">
        <div class="content">
            <!-- Bienvenida Mejorada -->
            <div class="card">
                <div class="search-bar">
                    <input type="text" class="search-input" placeholder="Buscar productos...">
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>

                <div class="filter-bar">
                    <div class="filter-btn active">Todos</div>
                    <div class="filter-btn">Bajo stock</div>
                    <div class="filter-btn">Agotados</div>
                    <div class="filter-btn">Próximos a vencer</div>
                    <div class="filter-btn">Sin movimiento</div>
                </div>

                <ul class="inventory-list">
                    <li v-for="product in filteredProducts" :key="product.id">
                        <ProductCard :product="product" @click="addToCart(product)" />
                    </li>



                </ul>

                <button class="btn btn-outline">
                    <i class="fas fa-sync-alt"></i> Cargar más productos
                </button>
            </div>
            <!-- Bienvenida Mejorada -->

        </div>
    </div>

</template>
