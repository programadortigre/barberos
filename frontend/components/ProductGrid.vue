<template>
  <div class="product-grid">
    <div class="product-card" v-for="product in products" :key="product.id">
      <img :src="product.image" :alt="product.name" />
      <h3>{{ product.name }}</h3>
      <p class="description">{{ product.description }}</p>
      <p class="price">${{ product.price.toFixed(2) }}</p>
      <button @click="addToCart(product)">Agregar al carrito</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Product } from '@/types/product'
import { useCartStore } from '@/stores/cart'

const cart = useCartStore()

const products: Product[] = [
  {
    id: 1,
    name: 'Gorra clásica',
    description: 'Para sol y estilo',
    price: 19.99,
    image: 'https://picsum.photos/300/200?random=1'
  },
  {
    id: 2,
    name: 'Zapatos deportivos',
    description: 'Comodidad y rendimiento',
    price: 89.99,
    image: 'https://picsum.photos/300/200?random=2'
  },
  {
    id: 3,
    name: 'Zapatos deportivos2',
    description: 'Comodidad y rendimiento',
    price: 89.99,
    image: 'https://picsum.photos/300/200?random=2'
  },
  {
    id: 4,
    name: 'Zapatos deportivos2',
    description: 'Comodidad y rendimiento',
    price: 89.99,
    image: 'https://picsum.photos/300/200?random=2'
  }
]

function addToCart(product: Product) {
  cart.add(product)
}
</script>

<style scoped lang="scss">
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 1.5rem;
  padding: 2rem;
}

.product-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  text-align: center;

  img {
    width: 100%;
    height: auto;
  }

  h3, .description, .price {
    margin: 1rem;
  }

  button {
    background: #e63946;
    color: white;
    border: none;
    padding: 0.5rem 1rem;
    margin-bottom: 1rem;
    cursor: pointer;

    &:hover {
      background: darken(#e63946, 10%);
    }
  }
}
</style>
