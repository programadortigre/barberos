<template>
  <div class="crud-container">
    <Toast />
    <ConfirmDialog></ConfirmDialog>
    
    <div class="mb-4">
      <Button label="Nuevo" icon="pi pi-plus" @click="openNew" />
    </div>

    <DataTable :value="products" tableStyle="min-width: 50rem">
      <Column field="id" header="ID" sortable></Column>
      <Column field="name" header="Nombre" sortable></Column>
      <Column field="price" header="Precio" sortable>
        <template #body="slotProps">
          ${{ slotProps.data.price }}
        </template>
      </Column>
      <Column header="Estado">
        <template #body="slotProps">
          <Tag :value="slotProps.data.status" 
               :severity="slotProps.data.status === 'activo' ? 'success' : 'danger'" />
        </template>
      </Column>
      <Column header="Acciones">
        <template #body="slotProps">
          <Button icon="pi pi-pencil" severity="info" text rounded @click="editProduct(slotProps.data)" />
          <Button icon="pi pi-trash" severity="danger" text rounded @click="confirmDelete(slotProps.data)" />
        </template>
      </Column>
    </DataTable>

    <Dialog v-model:visible="productDialog" :header="product.id ? 'Editar Servicio' : 'Nuevo Servicio'" modal>
      <div class="p-fluid">
        <div class="field">
          <label for="name">Nombre del servicio</label>
          <InputText id="name" v-model="product.name" required autofocus />
        </div>
        <div class="field">
          <label for="price">Precio ($)</label>
          <InputText id="price" v-model="product.price" required />
        </div>
        <div class="field">
          <label for="status">Estado</label>
          <Dropdown v-model="product.status" :options="statusOptions" optionLabel="label" optionValue="value" placeholder="Selecciona estado" />
        </div>
      </div>
      <template #footer>
        <Button label="Cancelar" icon="pi pi-times" text @click="hideDialog" />
        <Button label="Guardar" icon="pi pi-check" text @click="saveProduct" />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useConfirm } from "primevue/useconfirm";
import { useToast } from "primevue/usetoast";

// Datos de ejemplo (en producción usarías una API)
const initialProducts = [
  { id: 1, name: "Corte Clásico", price: 1500, status: "activo" },
  { id: 2, name: "Afeitado Premium", price: 800, status: "inactivo" },
  { id: 3, name: "Tinte Barba", price: 1200, status: "activo" }
];

const products = ref([...initialProducts]);
const productDialog = ref(false);
const product = ref({});
const submitted = ref(false);
const statusOptions = ref([
  { label: 'Activo', value: 'activo' },
  { label: 'Inactivo', value: 'inactivo' }
]);

const confirm = useConfirm();
const toast = useToast();

const openNew = () => {
  product.value = {};
  submitted.value = false;
  productDialog.value = true;
};

const hideDialog = () => {
  productDialog.value = false;
  submitted.value = false;
};

const editProduct = (prod) => {
  product.value = { ...prod };
  productDialog.value = true;
};

const saveProduct = () => {
  submitted.value = true;
  
  if (product.value.name && product.value.price) {
    if (product.value.id) {
      // Actualizar
      const index = products.value.findIndex(p => p.id === product.value.id);
      products.value[index] = { ...product.value };
      toast.add({ severity: 'success', summary: 'Éxito', detail: 'Servicio actualizado', life: 3000 });
    } else {
      // Crear nuevo
      product.value.id = createId();
      products.value.push({ ...product.value });
      toast.add({ severity: 'success', summary: 'Éxito', detail: 'Servicio creado', life: 3000 });
    }
    
    productDialog.value = false;
    product.value = {};
  }
};

const confirmDelete = (prod) => {
  confirm.require({
    message: `¿Estás seguro de eliminar ${prod.name}?`,
    header: 'Confirmación',
    icon: 'pi pi-exclamation-triangle',
    accept: () => {
      deleteProduct(prod);
      toast.add({ severity: 'success', summary: 'Éxito', detail: 'Servicio eliminado', life: 3000 });
    }
  });
};

const deleteProduct = (prod) => {
  products.value = products.value.filter(p => p.id !== prod.id);
};

const createId = () => {
  return Math.max(...products.value.map(p => p.id), 0) + 1;
};
</script>

<style scoped>
.crud-container {
  max-width: 1200px;
  margin: 2rem auto;
  padding: 0 1rem;
}

.field {
  margin-bottom: 1.5rem;
}
</style>