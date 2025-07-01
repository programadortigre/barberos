<template>
    <li class="inventory-item animate-in" @click="$emit('add-to-cart', product)">
        <div class="inventory-img">
            <i :class="product.img"></i>
        </div>

        <div class="inventory-details">
            <!-- Nombre -->
            <div class="inventory-name">{{ product.name }}</div>

            <!-- Info -->
            <div class="inventory-info">
                <span>{{ product.sku }}</span>
                <span class="separator">|</span>
                <span>Categoría: {{ product.category }}</span>
                <span class="separator">|</span>
                <span>Precio: S/ {{ product.price.toFixed(2) }}</span>
            </div>

            <!-- Stock -->
            <div class="inventory-stock">
                <span>Stock: {{ product.stock }}</span>
            </div>

            <!-- Estado de stock -->
            <small class="stock-text" :class="stockInfo.clase">{{ stockInfo.texto }}</small>
            <div class="stock-bar">
                <div class="stock-level" :class="stockInfo.clase" :style="stockInfo.estilo"></div>
            </div>
        </div>
    </li>
</template>

<script setup>
import { computed } from 'vue'
import { useStockBar } from '@/composables/useStockBar'

const props = defineProps({
    product: {
        type: Object,
        required: true
    }
})

const emit = defineEmits(['add-to-cart'])

const { getStockInfo } = useStockBar()
const stockInfo = computed(() => getStockInfo(props.product))
</script>

<style scoped lang="scss">
.separator {
    margin: 0 10px;
    color: #aaa;
}

.inventory-item {
    display: flex;
    align-items: center;
    padding: 15px 0;
    border-bottom: 1px solid var(--border);

    &:last-child {
        border-bottom: none;
    }

    .inventory-img {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        background: var(--light-gray);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        overflow: hidden;

        i {
            font-size: 24px;
            color: var(--gray);
        }
    }

    .inventory-details {
        flex: 1;

        .inventory-name {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .inventory-info {
            display: flex;
            font-size: 14px;
            color: var(--gray);
            margin-bottom: 5px;
        }

        .inventory-stock {
            display: flex;
            align-items: center;
        }

        .stock-bar {
            height: 6px;
            background: var(--light-gray);
            border-radius: 3px;
            margin-top: 8px;
            overflow: hidden;
            position: relative;

            .stock-level {
                height: 100%;
                border-radius: 3px;
                position: absolute;
                left: 0;
                top: 0;
            }

            .stock-high {
                background: var(--success);
            }

            .stock-medium {
                background: var(--warning);
            }

            .stock-low {
                background: var(--danger);
            }
        }
    }
}
</style>
