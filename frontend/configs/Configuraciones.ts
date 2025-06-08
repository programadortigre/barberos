export const data = {
  endpoint: 'configuraciones',
  relaciones: [
    { key: 'creado_por', recurso: 'personas', label: 'nombres' }
  ],
  columnas: [
    { key: 'valor', label: 'Valor' },
    { key: 'descripcion', label: 'Descripción' },
    { key: 'tipo', label: 'Tipo' },
    { key: 'creado_por', label: 'Creado por' },
    { key: 'clave', label: 'Clave' },
    { key: 'created_at', label: 'Fecha de creación' },
  ],
  camposFormulario: [
    { key: 'rol_id', label: 'Rol', type: 'select' },
    { key: 'permiso_id', label: 'Permiso', type: 'select' },
    { key: 'creado_por', label: 'Creado por', type: 'select' }  
  ]
}
