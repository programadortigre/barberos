export const rolesPermisosConfig = {
  endpoint: 'roles_permisos',
  relaciones: [
    { key: 'rol_id', recurso: 'roles', label: 'nombre' },
    { key: 'permiso_id', recurso: 'permisos', label: 'nombre' },
    { key: 'creado_por', recurso: 'personas', label: 'nombres' }
  ],
  columnas: [
    { key: 'rol_id', label: 'Rol' },
    { key: 'permiso_id', label: 'Permiso' },
    { key: 'creado_por', label: 'Creado por' },
    { key: 'created_at', label: 'Fecha de creación' }
  ],
  camposFormulario: [
    { key: 'rol_id', label: 'Rol', type: 'select' },
    { key: 'permiso_id', label: 'Permiso', type: 'select' },
    { key: 'creado_por', label: 'Creado por', type: 'select' }  
  ]
}