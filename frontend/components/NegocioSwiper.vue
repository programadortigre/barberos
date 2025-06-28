<script setup>
import { ref } from 'vue'
import { Swiper, SwiperSlide } from 'swiper/vue'
import 'swiper/css'
import 'swiper/css/effect-coverflow'

import SwiperCore, { EffectCoverflow } from 'swiper'
SwiperCore.use([EffectCoverflow])

const tiposNegocio = [
  { label: 'Barbería', value: 'barberia', img: '/img/barberia.png' },
  { label: 'Tienda de ropa', value: 'ropa', img: '/img/ropa.png' },
  { label: 'Bodega', value: 'bodega', img: '/img/bodega.png' },
  { label: 'Restaurante', value: 'restaurant', img: '/img/restaurant.png' },
  { label: 'Ferretería', value: 'ferreteria', img: '/img/ferreteria.png' },
  // Agrega más según quieras
]

const negocioSeleccionado = ref(tiposNegocio[0].value)

function onSlideChange(swiper) {
  negocioSeleccionado.value = tiposNegocio[swiper.realIndex].value
}
</script>

<template>
  <div class="w-full max-w-xl mx-auto">
    <Swiper
      :effect="'coverflow'"
      grab-cursor="true"
      centered-slides="true"
      slides-per-view="auto"
      :coverflow-effect="{
        rotate: 50,
        stretch: 0,
        depth: 100,
        modifier: 1,
        slideShadows: true
      }"
      @slideChange="onSlideChange"
      class="mySwiper"
    >
      <SwiperSlide
        v-for="neg in tiposNegocio"
        :key="neg.value"
        class="w-64 h-80 flex flex-col items-center justify-center rounded-xl bg-white shadow-lg cursor-pointer"
        :class="{
          'border-4 border-blue-600': negocioSeleccionado === neg.value
        }"
      >
        <img
          :src="neg.img"
          :alt="neg.label"
          class="w-full h-48 object-contain mb-4"
        />
        <h3 class="text-xl font-semibold">{{ neg.label }}</h3>
      </SwiperSlide>
    </Swiper>

    <p class="mt-6 text-center text-gray-700">
      Negocio seleccionado: <strong>{{ negocioSeleccionado }}</strong>
    </p>
  </div>
</template>

<style scoped>
.mySwiper {
  padding-top: 40px;
  padding-bottom: 80px;
}
</style>
