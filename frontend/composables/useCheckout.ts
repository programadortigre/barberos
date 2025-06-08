// composables/useCheckout.ts
import { useCartStore } from '@/stores/cart'

export function useCheckout() {
  const cart = useCartStore()

  const form = reactive({
    nombre: '',
    email: '',
    telefono: '',
    direccion: '',
    envio: 'delivery',
    pago: 'yape'
  })

  function generarMensaje() {
    const productos = cart.items.map(p =>
      `${p.name} x${p.quantity} - $${(p.price * p.quantity).toFixed(2)}`
    ).join('%0A')

    return `
🧾 *Nuevo pedido*
👤 ${form.nombre}
📞 ${form.telefono}
📧 ${form.email}
📍 ${form.direccion}
🚚 Envío: ${form.envio}
💳 Pago: ${form.pago}
🛍 Productos:
${productos}
💰 Total: $${cart.total.toFixed(2)}
    `.trim()
  }

  function enviarPedido() {
    const url = `https://wa.me/51${form.telefono}?text=${encodeURIComponent(generarMensaje())}`
    window.open(url, '_blank')
  }

  return {
    form,
    enviarPedido
  }
}
