<template>
  <div class="product-grid">
    <div class="product-card" v-for="product in products" :key="product.id">
      <img :src="product.image" :alt="product.name" />
      <h3>{{ product.name }}</h3>
      <p class="description">{{ product.description }}</p>
      <p class="price">${{ product.price.toFixed(2) }}</p>
      <button>Agregar al carrito</button>
    </div>
  </div>
</template>

<script setup>
const products = [
  {
    id: 1,
    name: 'Camiseta básica',
    description: 'Camiseta de algodón 100% orgánico',
    price: 29.99,
    image: 'https://picsum.photos/300/200?random=1'
  },
  {
    id: 2,
    name: 'Pantalón denim',
    description: 'Pantalón azul clásico para uso diario',
    price: 49.99,
    image: 'https://picsum.photos/300/200?random=2'
  },
  {
    id: 3,
    name: 'Zapatillas deportivas',
    description: 'Cómodas y ligeras para cualquier ocasión',
    price: 89.99,
    image: 'https://picsum.photos/300/200?random=3'
  },
  {
    id: 4,
    name: 'Chaqueta impermeable',
    description: 'Ideal para climas lluviosos',
    price: 119.99,
    image: 'https://picsum.photos/300/200?random=4'
  },
]
</script>

<style lang="scss" scoped>
$product-card-bg: #fff;
$product-card-border: #eee;
$product-card-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
$product-card-radius: 12px;
$primary-color: #e63946;

.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 1.5rem;
  padding: 2rem;
}

.product-card {
  background-color: $product-card-bg;
  border: 1px solid $product-card-border;
  border-radius: $product-card-radius;
  box-shadow: $product-card-shadow;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: transform 0.2s;

  &:hover {
    transform: translateY(-5px);
  }

  img {
    width: 100%;
    height: auto;
    object-fit: cover;
  }

  h3 {
    font-size: 1.2rem;
    margin: 1rem;
  }

  .description {
    font-size: 0.9rem;
    margin: 0 1rem 1rem;
    color: #555;
  }

  .price {
    font-size: 1rem;
    font-weight: bold;
    margin: 0 1rem 1rem;
    color: $primary-color;
  }

  button {
    margin: 0 1rem 1rem;
    padding: 0.5rem 1rem;
    background-color: $primary-color;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;

    &:hover {
      background-color: darken($primary-color, 10%);
    }
  }
}
</style>
