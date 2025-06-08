import { defineStore } from 'pinia'
import type { Product } from '@/types/product'

interface CartItem extends Product {
  quantity: number
}

export const useCartStore = defineStore('cart', {
  state: () => ({
    items: [] as CartItem[]
  }),

  actions: {
    add(product: Product) {
      const item = this.items.find(i => i.id === product.id)
      if (item) {
        item.quantity++
      } else {
        this.items.push({ ...product, quantity: 1 })
      }
    },

    remove(id: number) {
      this.items = this.items.filter(p => p.id !== id)
    },

    clear() {
      this.items = []
    },

    increment(id: number) {
      const item = this.items.find(i => i.id === id)
      if (item) item.quantity++
    },

    decrement(id: number) {
      const item = this.items.find(i => i.id === id)
      if (item && item.quantity > 1) {
        item.quantity--
      } else {
        this.remove(id)
      }
    }
  },

  getters: {
    count: (state) =>
      state.items.reduce((total, item) => total + item.quantity, 0),

    total: (state) =>
      state.items.reduce((sum, item) => sum + item.price * item.quantity, 0)
  }
})
