<template>
  <div class="quote-container">
    <header class="quote-header">
      <div class="company-info">
        <h1>CNB-TRAINING FOR MINING S.A.C.</h1>
        <p>RUC: 12345678901</p>
        <p>Jr. Minería #123, Lima, Perú</p>
        <p>Email: contacto@cnb-training.pe</p>
      </div>
      <div class="quote-info">
        <h2>COTIZACIÓN</h2>
        <p><strong>N°:</strong> CTZ-{{ quote.number }}</p>
        <p><strong>Fecha:</strong> {{ quote.date }}</p>
      </div>
    </header>

    <section class="client-info">
      <h3>Para:</h3>
      <p><strong>{{ quote.client.name }}</strong></p>
      <p>{{ quote.client.company }}</p>
      <p>{{ quote.client.address }}</p>
      <p>{{ quote.client.email }}</p>
    </section>

    <section class="quote-items">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Descripción</th>
            <th>Cantidad</th>
            <th>Precio Unitario</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in quote.items" :key="index">
            <td>{{ index + 1 }}</td>
            <td>{{ item.description }}</td>
            <td>{{ item.quantity }}</td>
            <td>S/ {{ item.unitPrice.toFixed(2) }}</td>
            <td>S/ {{ (item.quantity * item.unitPrice).toFixed(2) }}</td>
          </tr>
        </tbody>
      </table>
    </section>

    <section class="quote-summary">
      <div class="totals">
        <p><strong>Subtotal:</strong> S/ {{ subtotal.toFixed(2) }}</p>
        <p><strong>IGV (18%):</strong> S/ {{ igv.toFixed(2) }}</p>
        <p class="grand-total"><strong>Total:</strong> S/ {{ total.toFixed(2) }}</p>
      </div>
    </section>

    <footer class="quote-footer">
      <p>Gracias por confiar en nosotros.</p>
      <p><em>Esta cotización tiene una validez de 15 días.</em></p>
    </footer>
  </div>
</template>

<script setup>
const quote = {
  number: '001-2025',
  date: new Date().toLocaleDateString(),
  client: {
    name: 'Juan Pérez',
    company: 'Minería Andina S.A.',
    address: 'Av. Principal 456, Arequipa',
    email: 'juan.perez@mineria.com',
  },
  items: [
    {
      description: 'Capacitación en Operación de Excavadoras',
      quantity: 1,
      unitPrice: 1500,
    },
    {
      description: 'Certificado y materiales de estudio',
      quantity: 1,
      unitPrice: 200,
    },
  ],
};

const subtotal = quote.items.reduce((sum, item) => sum + item.quantity * item.unitPrice, 0);
const igv = subtotal * 0.18;
const total = subtotal + igv;
</script>

<style scoped lang="scss" src="@/assets/styles/quote.scss"></style>
