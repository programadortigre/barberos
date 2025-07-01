<template>
    <div :class="['card-item', customClass]">
        <!-- Galería de imágenes -->
        <div class="card-media" v-if="images.length">
            <img :src="images[activeImage]" class="main-img" />
            <div class="thumbnails" v-if="images.length > 1">
                <img v-for="(img, i) in images" :key="i" :src="img" class="thumb" :class="{ active: i === activeImage }"
                    @click="activeImage = i" />
            </div>
        </div>

        <!-- Ícono si no hay imágenes -->
        <div class="card-icon" v-else-if="icon">
            <i :class="icon"></i>
        </div>

        <!-- Contenido principal -->
        <div class="card-content">
            <h3 class="card-title">{{ title }}</h3>
            <p class="card-subtitle" v-if="subtitle">{{ subtitle }}</p>

            <ul class="card-details" v-if="details.length">
                <li v-for="(item, i) in details" :key="i">
                    <strong>{{ item.label }}:</strong> {{ item.value }}
                </li>
            </ul>

            <div class="card-status" v-if="statusInfo?.texto" :class="['card-status', statusInfo.clase]">
                {{ statusInfo.texto }}
            </div>

            <div class="stock-bar" v-if="statusInfo?.estilo">
                <div class="stock-level" :class="statusInfo.clase" :style="statusInfo.estilo"></div>
            </div>

            <div class="card-actions" v-if="actions?.length">
                <button v-for="(btn, i) in actions" :key="i" :class="btn.class" @click="btn.onClick">
                    {{ btn.label }}
                </button>
            </div>

            <slot />
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
    icon: String,
    title: { type: String, required: true },
    subtitle: String,
    details: { type: Array, default: () => [] },
    images: { type: Array, default: () => [] },
    customClass: { type: String, default: '' },
    item: { type: Object, required: true },
    getStatusInfo: Function,
    actions: {
        type: Array,
        default: () => [],
        validator: (arr) => arr.every(btn => typeof btn.label === 'string' && typeof btn.onClick === 'function')
    }

})

const activeImage = ref(0)

const statusInfo = computed(() =>
    props.getStatusInfo ? props.getStatusInfo(props.item) : null
)
</script>

<style scoped>
.card-item {
    display: flex;
    flex-direction: column;
    background: #fff;
    border-radius: 1rem;
    overflow: hidden;
    padding: 1rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.card-media {
    position: relative;
    margin-bottom: 1rem;
}

.main-img {
    width: 100%;
    border-radius: 0.75rem;
    object-fit: cover;
}

.thumbnails {
    display: flex;
    gap: 0.5rem;
    margin-top: 0.5rem;
}

.thumb {
    width: 48px;
    height: 48px;
    object-fit: cover;
    border-radius: 0.5rem;
    cursor: pointer;
    opacity: 0.6;
    border: 2px solid transparent;
    transition: 0.2s ease;
}

.thumb.active {
    opacity: 1;
    border-color: #000;
}

.card-icon {
    font-size: 3rem;
    color: #333;
    text-align: center;
    margin-bottom: 1rem;
}

.card-title {
    font-size: 1.25rem;
    font-weight: bold;
    margin-bottom: 0.25rem;
}

.card-subtitle {
    font-size: 0.9rem;
    color: #666;
    margin-bottom: 0.75rem;
}

.card-details {
    list-style: none;
    padding: 0;
    margin: 0 0 0.75rem;
}

.card-details li {
    margin-bottom: 0.25rem;
}

.card-status {
    font-size: 0.85rem;
    margin-bottom: 0.5rem;
    font-weight: 600;
}

/* Solo color del texto */
.card-status.stock-high {
    color: #28a745;
}

.card-status.stock-medium {
    color: #ffc107;
}

.card-status.stock-low {
    color: #dc3545;
}

.stock-bar {
    height: 6px;
    background: #eee;
    border-radius: 4px;
    overflow: hidden;
}

.stock-level {
    height: 100%;
    transition: width 0.3s ease, background-color 0.3s ease;
}

/* Solo color de fondo de la barra */
.stock-level.stock-high {
    background-color: #28a745;
}

.stock-level.stock-medium {
    background-color: #ffc107;
}

.stock-level.stock-low {
    background-color: #dc3545;
}
</style>
