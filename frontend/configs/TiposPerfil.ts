export const TiposPerfilConfig  = {
  endpoint: 'tipos_perfil',
  relaciones: [
    { key: 'rol_id', recurso: 'roles', label: 'nombre' },
    { key: 'permiso_id', recurso: 'permisos', label: 'nombre' },
    { key: 'usuario_id', recurso: 'usuarios', label: 'username' }
  ],
  columnas: [
    { key: 'nombre', label: 'Nombre' },
    { key: 'descripcion', label: 'Descripción' },
    { key: 'campos_json', label:'Campos JSON' }
  ],
  camposFormulario: [
    { key: 'nombre', label: 'Nombre' },
    { key: 'descripcion', label: 'Descripción' },
    { key: 'clave', label:'clave' },
    { key: 'campos_json', label:'Campos JSON' }
  ]
}
