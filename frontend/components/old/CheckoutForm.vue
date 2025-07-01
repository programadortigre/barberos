<template>
  <form class="form-section" @submit.prevent="enviarPedido">
    <h2>🧾 Finalizar compra</h2>

    <fieldset>
      <legend>🧍 Datos del cliente</legend>
      <input v-model="form.nombre" placeholder="Nombre completo" required />
      <input v-model="form.email" type="email" placeholder="Correo electrónico" required />
      <input v-model="form.telefono" placeholder="Teléfono / WhatsApp" required />
      <input v-model="form.direccion" placeholder="Dirección de entrega" required />
    </fieldset>

    <fieldset>
      <legend>🚚 Método de envío</legend>
      <label><input type="radio" value="retiro" v-model="form.envio" /> Retiro</label>
      <label><input type="radio" value="delivery" v-model="form.envio" /> Delivery</label>
    </fieldset>

    <fieldset>
      <legend>💳 Método de pago</legend>
      <label><input type="radio" value="yape" v-model="form.pago" /> Yape</label>
      <label><input type="radio" value="plin" v-model="form.pago" /> Plin</label>
      <label><input type="radio" value="tarjeta" v-model="form.pago" /> Tarjeta</label>
      <label><input type="radio" value="efectivo" v-model="form.pago" /> Efectivo</label>
    </fieldset>

    <button type="submit">📤 Enviar pedido por WhatsApp</button>
  </form>
</template>

<script setup lang="ts">
import { useCheckout } from '@/composables/useCheckout'
const { form, enviarPedido } = useCheckout()
</script>

<style scoped lang="scss"> 
  .form-section {
    flex: 1;
    min-width: 300px;
    background: var(--bg-color);
    padding: 1.5rem;
    border-radius: 10px;
    box-shadow: 0 0 10px #ddd;

    fieldset {
      margin-bottom: 1.2rem;
      border: 1px solid #ccc;
      padding: 1rem;
      border-radius: 8px;

      legend {
        font-weight: bold;
        margin-bottom: 0.5rem;
      }

      input[type='text'],
      input[type='email'] {
        display: block;
        width: 100%;
        margin-top: 0.5rem;
        margin-bottom: 0.8rem;
        padding: 0.6rem;
        border: 1px solid #ccc;
        border-radius: 6px;
      }

      label {
        display: block;
        margin-top: 0.5rem;
      }
    }

    button {
      background: #25d366;
      color: white;
      padding: 0.7rem 1.2rem;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: bold;
      transition: background 0.2s;

      &:hover {
        background: #1ebe5d;
      }
    }
  }
</style>