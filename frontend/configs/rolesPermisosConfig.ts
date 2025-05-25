// configs/rolesPermisosConfig.ts
export const columnas = [
  { key: 'rol_id', label: 'Rol' },
  { key: 'permiso_id', label: 'Permiso' },
  { key: 'creado_por', label: 'Creado por' },
  { key: 'fecha_creacion', label: 'Fecha de creación' }
]

export const camposFormularioBase = [
  {
    key: 'rol_id',
    label: 'Rol',
    type: 'select'
  },
  {
    key: 'permiso_id',
    label: 'Permiso',
    type: 'select'
  },
  {
    key: 'creado_por',
    label: 'Creado por',
    type: 'select'
  }
]