export const Usuarios = {
  endpoint: 'usuarios',
  relaciones: [
    { key: 'rol_id', recurso: 'roles', label: 'nombre' },
    { key: 'persona_id', recurso: 'personas', label: 'nombres' }
  ],
  columnas: [
    { key: 'username', label: 'Usuario' },
    { key: 'estado', label: 'Estado' },
    { key: 'persona_id', label: 'Persona' },
    { key: 'rol_id', label: 'Rol' },
  ],
  camposFormulario: [
    { key: 'username', label: 'Usuario', type: 'text' },
    { key: 'password', label: 'Contraseña', type: 'password' },
    {
      key: 'estado',
      label: 'Estado',
      type: 'select',
      options: [
        { label: 'Activo', value: 'activo' },
        { label: 'Inactivo', value: 'inactivo' },
      ]
    },
    { key: 'persona_id', label: 'Persona' },
    { key: 'rol_id', label: 'Rol' }
  ]
}
