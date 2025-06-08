export default {
  async getProducts() {
    return await $fetch('/api/products');
  },
  
  async createProduct(product) {
    return await $fetch('/api/products', {
      method: 'POST',
      body: product
    });
  },
  
  async updateProduct(id, product) {
    return await $fetch(`/api/products/${id}`, {
      method: 'PUT',
      body: product
    });
  },
  
  async deleteProduct(id) {
    return await $fetch(`/api/products/${id}`, {
      method: 'DELETE'
    });
  }
};