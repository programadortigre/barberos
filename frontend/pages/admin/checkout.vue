<template>
  <div class="checkout-container">
    <CheckoutForm />

    <div class="cart-section">
      <h2>🛒 Tu pedido</h2>
      <div v-if="cart.items.length" class="cart-grid">
        <CartItem v-for="item in cart.items" :key="item.id" :item="item" />
        <div class="total">Total: ${{ cart.total.toFixed(2) }}</div>
      </div>
      <p v-else>Tu carrito está vacío.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import CheckoutForm from '@/components/CheckoutForm.vue'
import CartItem from '@/components/CartItem.vue'
import { useCartStore } from '@/stores/cart'
const cart = useCartStore()
definePageMeta({ layout: 'admin' })

</script>

<style scoped lang="scss">
.checkout-container {
  display: flex;
  flex-wrap: wrap;
  gap: 2rem;
  max-width: 1200px;
  margin: 2rem auto;
  padding: 1rem;
  .cart-section {
    flex: 1;
    min-width: 300px;
    .cart-grid {
      display: flex;
      flex-direction: column;
      gap: 1rem;
      .total {
        text-align: right;
        font-size: 1.2rem;
        font-weight: bold;
        margin-top: 1rem;
      }
    }
  }
}
</style>
