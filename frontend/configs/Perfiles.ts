export const data = {
  endpoint: 'perfiles',
  relaciones: [
    { key: 'persona_id', recurso: 'personas', label: 'nombres' },
    { key: 'tipo_perfil_id', recurso: 'personas', label: 'nombres' }

  ],
  columnas: [
    { key: 'persona_id', label: 'Creado por' },
    { key: 'tipo_perfil_id', label: 'Creado por' },
    { key: 'datos_personalizados_json', label: 'Datos personalizados JSON' }
  ],
  camposFormulario: [
    { key: 'persona_id', label: 'Creado por', type: 'select' },  
    { key: 'tipo_perfil_id', label: 'Creado por', type: 'select' },
    { key: 'datos_personalizados_json', label: 'Datos personalizados JSON', type: 'textarea' }
  ]

}
