export const Roles = {
  endpoint: 'roles',
  /*relaciones: [
    { key: 'rol_id', recurso: 'roles', label: 'nombre' },
    { key: 'permiso_id', recurso: 'permisos', label: 'nombre' },
    { key: 'creado_por', recurso: 'personas', label: 'username' }
  ],*/
  columnas: [
    { key: 'nombre', label: 'Nombre' },
    { key: 'descripcion', label: 'Descripción' }
  ],
  camposFormulario: [
    { key: 'nombre', label: 'Nombre' },
    { key: 'descripcion', label: 'Descripción' }
  ]
}
