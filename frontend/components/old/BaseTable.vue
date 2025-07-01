<template>
  <div class="table-container">
    <input
      v-model="searchTerm"
      type="text"
      placeholder="🔍 Buscar..."
      class="search-input"
    />

    <table class="custom-table">
      <thead>
        <tr>
          <th
            v-for="header in headers"
            :key="header.key"
            @click="sortBy(header.key)"
            :class="{ sortable: true, active: sortKey === header.key }"
          >
            {{ header.label }}
            <span v-if="sortKey === header.key">
              {{ sortDir === 'asc' ? '▲' : '▼' }}
            </span>
          </th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in pagedData" :key="item.id">
          <td v-for="header in headers" :key="header.key + item.id">
            <slot :name="`cell-${header.key}`" :item="item">
              {{ item[header.key] }}
            </slot>
          </td>
          <td class="action-buttons">
            <button class="btn edit" @click="$emit('edit', item)">✏️</button>
            <button class="btn delete" @click="$emit('delete', item)">🗑️</button>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="pagination">
      <button :disabled="page === 1" @click="page--">←</button>
      <span>Página {{ page }} de {{ totalPages }}</span>
      <button :disabled="page === totalPages" @click="page++">→</button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  data: Array,
  headers: Array,
  rowsPerPage: {
    type: Number,
    default: 5
  }
})

const searchTerm = ref('')
const page = ref(1)
const sortKey = ref(null)
const sortDir = ref('asc')

const filteredData = computed(() => {
  if (!searchTerm.value) return props.data
  return props.data.filter(item =>
    props.headers.some(header => {
      const val = item[header.key]
      return val?.toString().toLowerCase().includes(searchTerm.value.toLowerCase())
    })
  )
})

const sortedData = computed(() => {
  if (!sortKey.value) return filteredData.value
  return [...filteredData.value].sort((a, b) => {
    if (a[sortKey.value] < b[sortKey.value]) return sortDir.value === 'asc' ? -1 : 1
    if (a[sortKey.value] > b[sortKey.value]) return sortDir.value === 'asc' ? 1 : -1
    return 0
  })
})

const totalPages = computed(() => Math.ceil(sortedData.value.length / props.rowsPerPage))

const pagedData = computed(() => {
  const start = (page.value - 1) * props.rowsPerPage
  return sortedData.value.slice(start, start + props.rowsPerPage)
})

watch(searchTerm, () => { page.value = 1 })

function sortBy(key) {
  if (sortKey.value === key) {
    sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortKey.value = key
    sortDir.value = 'asc'
  }
}
</script>

<style scoped>
.table-container {
  padding: 1rem;
  border-radius: 8px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}

.search-input {
  width: 100%;
  max-width: 300px;
  padding: 8px 12px;
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
}

.custom-table {
  width: 100%;
  border-collapse: collapse;

  th, td {
    padding: 12px 14px;
    border-bottom: 1px solid #eee;
    text-align: left;
  }

  th.sortable {
    cursor: pointer;
    user-select: none;
  }

  th.sortable.active {
    color: #007bff;
  }

  tbody tr:hover {
    background-color: #000;
    color: #fff;
  }
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.action-buttons .btn {
  padding: 6px 10px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.3s;
}

.action-buttons .btn.edit {
  background: #e0f7fa;
  color: #00796b;
}

.action-buttons .btn.delete {
  background: #ffebee;
  color: #c62828;
}

.action-buttons .btn:hover {
  opacity: 0.9;
}

.pagination {
  margin-top: 1rem;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
}

.pagination button {
  padding: 6px 10px;
  border: none;
  border-radius: 4px;
  background: #007bff;
  color: #fff;
  font-size: 14px;
  cursor: pointer;
}

.pagination button:disabled {
  background: #ccc;
  cursor: not-allowed;
}
</style>
