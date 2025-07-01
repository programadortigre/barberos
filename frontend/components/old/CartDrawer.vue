<template>
  <div class="cart">
    <h2>🛒 Carrito ({{ cart.count }})</h2>

    <ul>
      <li v-for="item in cart.items" :key="item.id">
        <img :src="item.image" :alt="item.name" class="thumb" />
        <div class="info">
          <span class="name">{{ item.name }}</span>
          <span class="price">${{ (item.price * item.quantity).toFixed(2) }}</span>

          <div class="quantity-controls">
            <button @click="cart.decrement(item.id)">-</button>
            <span>{{ item.quantity }}</span>
            <button @click="cart.increment(item.id)">+</button>
          </div>
        </div>
        <button @click="cart.remove(item.id)">❌</button>
      </li>
    </ul>

    <p v-if="cart.total > 0">
      <strong>Total:</strong> ${{ cart.total.toFixed(2) }}
    </p>

    <NuxtLink to="/checkout" v-if="cart.items.length > 0">
      <button class="checkout-btn">Finalizar compra</button>
    </NuxtLink>

    <p v-else>Tu carrito está vacío.</p>
  </div>
</template>

<script setup lang="ts">
import { useCartStore } from '@/stores/cart'
const cart = useCartStore()
</script>

<style scoped lang="scss">
.cart {
  background: #f9f9f9;
  padding: 1.5rem;
  border-radius: 10px;
  box-shadow: 0 0 10px #ccc;
  max-width: 500px;
  margin: 2rem auto;

  ul {
    list-style: none;
    padding: 0;

    li {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 1rem;

      .thumb {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid #ddd;
      }

      .info {
        flex: 1;

        .name {
          display: block;
          font-weight: bold;
        }

        .price {
          font-size: 0.9rem;
          color: #555;
          margin-bottom: 0.5rem;
        }

        .quantity-controls {
          display: flex;
          align-items: center;
          gap: 0.5rem;

          button {
            width: 28px;
            height: 28px;
            border: 1px solid #888;
            background: white;
            cursor: pointer;
            border-radius: 4px;
            font-weight: bold;
            line-height: 1;

            &:hover {
              background: #eee;
            }
          }

          span {
            min-width: 20px;
            text-align: center;
            font-weight: 600;
          }
        }
      }

      button {
        background: transparent;
        border: none;
        color: red;
        cursor: pointer;
        font-size: 1.2rem;
      }
    }
  }

  .checkout-btn {
    background: #2a9d8f;
    color: white;
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 6px;
    margin-top: 1rem;
    cursor: pointer;

    &:hover {
      background: darken(#2a9d8f, 10%);
    }
  }
}
</style>
