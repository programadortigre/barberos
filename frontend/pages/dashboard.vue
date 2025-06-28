<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'

interface Negocio {
  nombre: string
  tipo: string
  modulos: string[]
}

const router = useRouter()
const logoFile = ref<File | null>(null)
const previewLogo = ref<string | null>(null)
const seleccionManual = ref(false)

// Tipos de negocio
const tiposNegocio = [
  { label: 'Barbería/Peluquería', value: 'barberia', icon: '✂️' },
  { label: 'Tienda de ropa', value: 'ropa', icon: '👕' },
  { label: 'Bodega/Minimarket', value: 'bodega', icon: '🏪' },
  { label: 'Restaurante/Menú', value: 'restaurant', icon: '🍽️' },
  { label: 'Ferretería', value: 'ferreteria', icon: '🔧' },
  { label: 'Repuestos', value: 'repuestos', icon: '🚗' },
  { label: 'Hotel/Hospedaje', value: 'hotel', icon: '🏨' },
  { label: 'Otro', value: 'otro', icon: '❓' }
]

// Módulos disponibles
const modulosDisponibles = [
  { name: 'Ventas', icon: '💰', descripcion: 'Registra y consulta tus ventas' },
  { name: 'Productos', icon: '📦', descripcion: 'Administra tus productos' },
  { name: 'Stock', icon: '📊', descripcion: 'Control de inventario' },
  { name: 'Compras', icon: '🛒', descripcion: 'Registra compras' },
  { name: 'Finanzas', icon: '📈', descripcion: 'Ingresos, egresos y balances' },
  { name: 'Clientes', icon: '👥', descripcion: 'Gestión de clientes' },
  { name: 'Proveedores', icon: '🚚', descripcion: 'Gestiona proveedores' },
  { name: 'Agenda', icon: '📅', descripcion: 'Citas y reservas' },
  { name: 'Reportes', icon: '📄', descripcion: 'Informes de negocio' },
  { name: 'Galería', icon: '🖼️', descripcion: 'Fotos de tu negocio' },
  { name: 'Pedidos', icon: '📋', descripcion: 'Seguimiento de pedidos' },
  { name: 'Menú', icon: '📖', descripcion: 'Define tu carta o menú' },
  { name: 'Caja diaria', icon: '🏦', descripcion: 'Control diario de caja' },
  { name: 'Habitaciones', icon: '🛏️', descripcion: 'Gestiona reservas' },
  { name: 'Servicios', icon: '🔧', descripcion: 'Servicios que ofreces' }
]

// Módulos preasignados
const modulosPorTipo: Record<string, string[]> = {
  barberia: ['Servicios', 'Agenda', 'Clientes', 'Finanzas', 'Caja diaria'],
  ropa: ['Productos', 'Ventas', 'Stock', 'Clientes'],
  bodega: ['Ventas', 'Productos', 'Stock'],
  restaurant: ['Menú', 'Pedidos', 'Clientes', 'Compras'],
  ferreteria: ['Productos', 'Stock', 'Ventas', 'Proveedores'],
  repuestos: ['Productos', 'Ventas', 'Proveedores'],
  hotel: ['Habitaciones', 'Reservas', 'Clientes'],
  otro: []
}

const negocio = ref<Negocio>({
  nombre: '',
  tipo: '',
  modulos: []
})

// Módulos recomendados
const modulosRecomendados = computed(() => {
  return negocio.value.tipo ? modulosPorTipo[negocio.value.tipo] || [] : []
})

// Watch para sincronizar módulos cuando cambia el tipo
watch(
  () => negocio.value.tipo,
  (nuevoTipo) => {
    if (!seleccionManual.value) {
      negocio.value.modulos = modulosPorTipo[nuevoTipo] || []
    }
  }
)

// Convertir archivo a Base64
const fileToBase64 = (file: File): Promise<string> => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(reader.result as string)
    reader.onerror = reject
    reader.readAsDataURL(file)
  })
}

// Manejar cambio de logo
const handleLogoChange = async (event: Event) => {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  
  if (file && file.type.startsWith('image/')) {
    logoFile.value = file
    previewLogo.value = await fileToBase64(file)
  } else {
    input.value = ''
    alert('Por favor selecciona una imagen válida')
  }
}

// Crear negocio
const crearNegocio = () => {
  if (!negocio.value.nombre.trim()) {
    alert('Ingresa el nombre de tu negocio')
    return
  }
  
  if (!negocio.value.tipo) {
    alert('Selecciona el tipo de negocio')
    return
  }
  
  // Si está en modo automático, usar los módulos recomendados
  if (!seleccionManual.value) {
    negocio.value.modulos = modulosPorTipo[negocio.value.tipo] || []
  }
  
  if (negocio.value.modulos.length === 0) {
    alert('Selecciona al menos un módulo')
    return
  }

  const negocioData = {
    ...negocio.value,
    logo: previewLogo.value
  }

  localStorage.setItem('negocio', JSON.stringify(negocioData))
  router.push('/welcome')
}

// Toggle módulo
const toggleModulo = (modulo: string) => {
  const index = negocio.value.modulos.indexOf(modulo)
  if (index === -1) {
    negocio.value.modulos.push(modulo)
  } else {
    negocio.value.modulos.splice(index, 1)
  }
}
</script>

<template>
  <div class="config-negocio">
    <header class="header">
      <h1 class="titulo">Configura tu negocio</h1>
      <p class="subtitulo">
        Personaliza los módulos que necesitas para administrar tu negocio
      </p>
    </header>

    <main class="contenido">
      <!-- Sección de información básica -->
      <section class="seccion">
        <h2 class="seccion-titulo">Información básica</h2>
        
        <div class="campo">
          <label for="nombre" class="campo-label">Nombre del negocio</label>
          <input
            id="nombre"
            type="text"
            v-model="negocio.nombre"
            placeholder="Ej: Mi Negocio"
            class="campo-input"
            autofocus
          />
        </div>
        
        <div class="campo">
          <label class="campo-label">Logo (opcional)</label>
          <div class="logo-uploader">
            <label for="logo-upload" class="logo-label">
              <span v-if="!previewLogo">➕ Subir logo</span>
              <img v-else :src="previewLogo" alt="Logo preview" class="logo-preview" />
            </label>
            <input
              id="logo-upload"
              type="file"
              accept="image/*"
              @change="handleLogoChange"
              class="logo-input"
            />
          </div>
        </div>
      </section>

      <!-- Sección de tipo de negocio -->
      <section class="seccion">
        <h2 class="seccion-titulo">Tipo de negocio</h2>
        <p class="seccion-desc">Selecciona el que más se ajuste a tu actividad</p>
        
        <div class="tipo-grid">
          <button
            v-for="tipo in tiposNegocio"
            :key="tipo.value"
            class="tipo-card"
            :class="{ 'tipo-card--selected': negocio.tipo === tipo.value }"
            @click="negocio.tipo = tipo.value"
          >
            <span class="tipo-icono">{{ tipo.icon }}</span>
            <span class="tipo-nombre">{{ tipo.label }}</span>
          </button>
        </div>
      </section>

      <!-- Sección de módulos -->
      <section class="seccion">
        <div class="modulo-header">
          <h2 class="seccion-titulo">Módulos</h2>
          <label class="modulo-toggle">
            <input type="checkbox" v-model="seleccionManual">
            <span>Personalizar</span>
          </label>
        </div>
        
        <p class="seccion-desc">
          Selecciona las funcionalidades que necesitas para tu negocio
        </p>
        
        <div v-if="seleccionManual" class="modulo-grid">
          <div
            v-for="modulo in modulosDisponibles"
            :key="modulo.name"
            class="modulo-card"
            :class="{ 'modulo-card--selected': negocio.modulos.includes(modulo.name) }"
            @click="toggleModulo(modulo.name)"
          >
            <div class="modulo-icono">{{ modulo.icon }}</div>
            <div class="modulo-info">
              <h3 class="modulo-nombre">{{ modulo.name }}</h3>
              <p class="modulo-desc">{{ modulo.descripcion }}</p>
            </div>
          </div>
        </div>
        
        <div v-else class="modulo-auto">
          <div class="recomendados">
            <h3 class="recomendados-titulo">Módulos recomendados</h3>
            <p class="recomendados-desc">Hemos seleccionado estos módulos según tu tipo de negocio</p>
          </div>
          
          <div class="modulo-grid">
            <div
              v-for="modulo in modulosRecomendados"
              :key="modulo"
              class="modulo-card modulo-card--selected"
            >
              <div class="modulo-icono">
                {{ modulosDisponibles.find(m => m.name === modulo)?.icon || '📁' }}
              </div>
              <div class="modulo-info">
                <h3 class="modulo-nombre">{{ modulo }}</h3>
                <p class="modulo-desc">
                  {{ modulosDisponibles.find(m => m.name === modulo)?.descripcion || '' }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="footer">
      <button class="btn-crear" @click="crearNegocio">
        Crear mi negocio
      </button>
    </footer>
  </div>
</template>

<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap');
*{
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
$color-primary: #4361ee;
$color-success: #06d6a0;
$color-light: #f8f9fa;
$color-dark: #212529;
$color-gray: #6c757d;
$color-border: #dee2e6;
$shadow-sm: 0 2px 8px rgba(0,0,0,0.1);
$radius: 12px;
$transition: all 0.3s ease;

.config-negocio {
  font-family: 'Poppins', sans-serif;
  max-width: 100%;
  padding: 1rem;
  background-color: #f5f7fb;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  text-align: center;
  padding: 1.5rem 0 1rem;
  
  .titulo {
    font-size: 1.8rem;
    font-weight: 700;
    color: $color-dark;
    margin-bottom: 0.5rem;
  }
  
  .subtitulo {
    font-size: 1rem;
    color: $color-gray;
    max-width: 500px;
    margin: 0 auto;
  }
}

.seccion {
  background: white;
  border-radius: $radius;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  box-shadow: $shadow-sm;
  
  &-titulo {
    font-size: 1.4rem;
    font-weight: 600;
    margin-bottom: 0.75rem;
    color: $color-dark;
  }
  
  &-desc {
    font-size: 0.9rem;
    color: $color-gray;
    margin-bottom: 1.5rem;
  }
}

.campo {
  margin-bottom: 1.5rem;
  
  &-label {
    display: block;
    font-weight: 500;
    margin-bottom: 0.5rem;
    color: $color-dark;
  }
  
  &-input {
    width: 100%;
    padding: 0.9rem 1.2rem;
    border: 1px solid $color-border;
    border-radius: 8px;
    font-size: 1rem;
    transition: $transition;
    
    &:focus {
      outline: none;
      border-color: $color-primary;
      box-shadow: 0 0 0 3px rgba($color-primary, 0.2);
    }
  }
}

.logo-uploader {
  display: flex;
  flex-direction: column;
  align-items: center;
  
  .logo-label {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 120px;
    height: 120px;
    border: 2px dashed $color-border;
    border-radius: 50%;
    cursor: pointer;
    overflow: hidden;
    transition: $transition;
    
    &:hover {
      border-color: $color-primary;
      background-color: rgba($color-primary, 0.05);
    }
    
    span {
      color: $color-gray;
      font-size: 0.9rem;
    }
  }
  
  .logo-preview {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  
  .logo-input {
    display: none;
  }
}

.tipo-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
  gap: 0.8rem;
}

.tipo-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1rem 0.5rem;
  border: 1px solid $color-border;
  border-radius: 8px;
  background: white;
  cursor: pointer;
  transition: $transition;
  
  &:hover {
    transform: translateY(-3px);
    border-color: $color-primary;
  }
  
  &--selected {
    border-color: $color-primary;
    background-color: rgba($color-primary, 0.1);
    box-shadow: 0 4px 6px rgba($color-primary, 0.1);
  }
  
  .tipo-icono {
    font-size: 2rem;
    margin-bottom: 0.5rem;
  }
  
  .tipo-nombre {
    font-size: 0.85rem;
    text-align: center;
    font-weight: 500;
    color: $color-dark;
  }
}

.modulo-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.modulo-toggle {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9rem;
  color: $color-gray;
  cursor: pointer;
}

.modulo-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 1rem;
}

.modulo-card {
  display: flex;
  align-items: flex-start;
  padding: 1rem;
  border: 1px solid $color-border;
  border-radius: 10px;
  background: white;
  cursor: pointer;
  transition: $transition;
  
  &:hover {
    transform: translateY(-2px);
    border-color: $color-primary;
  }
  
  &--selected {
    border-color: $color-primary;
    background-color: rgba($color-primary, 0.05);
    
    .modulo-icono {
      background-color: rgba($color-primary, 0.1);
      color: $color-primary;
    }
  }
  
  .modulo-icono {
    font-size: 1.4rem;
    padding: 0.5rem;
    border-radius: 8px;
    margin-right: 0.8rem;
    flex-shrink: 0;
  }
  
  .modulo-info {
    flex: 1;
  }
  
  .modulo-nombre {
    font-size: 0.95rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
    color: $color-dark;
  }
  
  .modulo-desc {
    font-size: 0.8rem;
    color: $color-gray;
    line-height: 1.4;
  }
}

.modulo-auto {
  .recomendados {
    background-color: rgba($color-primary, 0.05);
    border-radius: 10px;
    padding: 1rem;
    margin-bottom: 1rem;
    
    &-titulo {
      font-size: 1.1rem;
      font-weight: 600;
      color: $color-primary;
      margin-bottom: 0.25rem;
    }
    
    &-desc {
      font-size: 0.85rem;
      color: $color-gray;
    }
  }
}

.btn-crear {
  display: block;
  width: 100%;
  padding: 1.1rem;
  background: $color-primary;
  color: white;
  border: none;
  border-radius: $radius;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: $transition;
  box-shadow: 0 4px 12px rgba($color-primary, 0.3);
  
  &:hover {
    background: darken($color-primary, 8%);
    transform: translateY(-2px);
  }
  
  &:active {
    transform: translateY(0);
  }
}

.footer {
  padding: 1.5rem 0;
}

/* Responsive */
@media (max-width: 480px) {
  .seccion {
    padding: 1.2rem;
  }
  
  .tipo-grid {
    grid-template-columns: repeat(auto-fill, minmax(90px, 1fr));
  }
  
  .modulo-grid {
    grid-template-columns: 1fr;
  }
  
  .tipo-card {
    padding: 0.8rem 0.3rem;
    
    .tipo-icono {
      font-size: 1.8rem;
    }
    
    .tipo-nombre {
      font-size: 0.75rem;
    }
  }
  
  .logo-label {
    width: 100px;
    height: 100px;
  }
}
</style>