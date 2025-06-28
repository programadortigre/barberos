<template>
  <div class="overflow-x-auto">
    <table class="w-full border rounded-md">
      <thead class="bg-gray-100">
        <tr>
          <th v-for="col in columns" :key="col.key" class="p-2 text-left">
            {{ col.label }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(row, i) in data" :key="i" class="border-t hover:bg-gray-50">
          <td v-for="col in columns" :key="col.key" class="p-2">
            <template v-if="col.type === 'image'">
              <img :src="row[col.key]" class="h-10 w-10 object-cover rounded-full" />
            </template>

            <template v-else-if="col.type === 'actions'">
              <div class="flex gap-2">
                <button class="text-blue-600 hover:underline" @click="$emit('edit', row)">Editar</button>
                <button class="text-red-600 hover:underline" @click="$emit('delete', row)">Eliminar</button>
              </div>
            </template>

            <template v-else>
              {{ row[col.key] }}
            </template>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
defineProps({
  columns: Array,
  data: Array
})
defineEmits(['edit', 'delete'])
</script>
