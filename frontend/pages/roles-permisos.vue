<script setup lang="ts">
import { columnas, camposFormularioBase } from '@/configs/rolesPermisosConfig'

definePageMeta({ layout: 'admin' })

const camposFormulario = [...camposFormularioBase]
</script>

<template>
  <CrudTable
    endpoint="roles_permisos"
    :columnas="columnas"
    :camposFormulario="camposFormulario"
    :relaciones="[
      { key: 'rol_id', recurso: 'roles', label: 'nombre' },
      { key: 'permiso_id', recurso: 'permisos', label: 'nombre' },
      { key: 'creado_por', recurso: 'personas', label: 'username' }
    ]"
  />
</template>

