<template>
  <div class="cart-card">
    <img :src="item.image" :alt="item.name" />
    <div class="info">
      <strong>{{ item.name }}</strong>
      <p>${{ (item.price * item.quantity).toFixed(2) }}</p>

      <div class="controls">
        <button @click="cart.decrement(item.id)">−</button>
        <span>{{ item.quantity }}</span>
        <button @click="cart.increment(item.id)">+</button>
        <button class="remove" @click="cart.remove(item.id)">❌</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useCartStore } from '@/stores/cart'
const cart = useCartStore()
defineProps<{ item: any }>()
</script>

<style scoped lang="scss"> 
      .cart-card {
        display: flex;
        align-items: center;
        gap: 1rem;
        background: var(--color-bg);
        padding: 1rem;
        border-radius: 10px;
        box-shadow: 0 0 6px #ccc;

        img {
          width: 60px;
          height: 60px;
          border-radius: 8px;
          object-fit: cover;
        }

        .info {
          flex: 1;

          p {
            margin: 0.4rem 0;
          }

          .controls {
            display: flex;
            gap: 0.5rem;
            align-items: center;

            button {
              padding: 0.3rem 0.7rem;
              border: 1px solid #ccc;
              background: var(--pr);
              border-radius: 4px;
              cursor: pointer;
              font-weight: bold;

              &.remove {
                background: #ffe5e5;
                border-color: red;
                color: red;
              }
            }
          }
        }
      }
</style>
