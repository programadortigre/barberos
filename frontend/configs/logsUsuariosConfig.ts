export const logsUsuariosConfig  = {
  endpoint: 'logs_usuarios',
  relaciones: [
    { key: 'rol_id', recurso: 'roles', label: 'nombre' },
    { key: 'permiso_id', recurso: 'permisos', label: 'nombre' },
    { key: 'usuario_id', recurso: 'usuarios', label: 'username' }
  ],
  columnas: [
    { key: 'usuario_id', label: 'Usuarios' },
    { key: 'accion', label: 'Accion' },
    { key: 'tabla_afectada', label: 'Tabla afectada' },
    {key: 'registro_id', label: 'Registro afectado' },
    { key: 'descripcion', label: 'Descripción' },
    { key: 'ip_address', label: 'IP Address' },
    { key: 'detalles_json', label: 'Detalles JSON' },
    { key: 'user_agent', label: 'User Agent' },
    { key: 'navegador', label: 'Navegador' }
  ],
  camposFormulario: [
        {
        key: 'usuario_id',
        label: 'Usuario',
        type: 'select'
        },
        {
        key: 'accion',
        label: 'Accion',
        type: 'text'
        },
        {
        key: 'tabla_afectada',
        label: 'Tabla afectada',
        type: 'text'
        },
        {
        key: 'registro_id',
        label: 'Registro afectado',
        type: 'text'
        },
        {
        key: 'descripcion',
        label: 'Descripción',
        type: 'text'
        },
        {
        key: 'ip_address',
        label: 'IP Address',
        type: 'text'
        },
        {
        key: 'detalles_json',
        label: 'Detalles JSON',
        type: 'text'
        },
        {
        key: 'user_agent',
        label: 'User Agent',
        type: 'text'
        },
        {
        key: 'navegador',
        label: 'Navegador',
        type: 'text'
        }
  ]
}
