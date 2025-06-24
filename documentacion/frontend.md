frontend/
├── assets/                  # Estilos globales, variables Sass, imágenes estáticas
│   └── styles/
│       ├── _variables.scss  # Variables Sass globales
│       ├── _mixins.scss     # Mixins Sass
│       └── main.scss        # Archivo principal de estilos globales
│
├── components/              # Componentes Vue reutilizables (botones, inputs, cards, sliders, etc)
│   ├── users/
│   │    ├── UserCard.vue    # Ejemplo componente para mostrar usuario
│   │    └── UserForm.vue    # Formulario para editar/crear usuarios
│   ├── roles/
│   ├── personas/
│   ├── permisos/
│   └── common/              # Componentes comunes (botones, loaders, modales, etc)
│
├── composables/             # Funciones reusables de composición (hooks), p. ej. usar auth, usar usuarios, etc
│   ├── useAuth.ts
│   ├── useUsuarios.ts
│   ├── useRoles.ts
│   └── usePermisos.ts
│
├── layouts/                 # Layouts para páginas (default.vue, admin.vue, auth.vue, etc)
│   ├── default.vue          # Layout principal con header, footer, menú
│   └── auth.vue             # Layout para páginas de login/registro
│
├── middleware/              # Middlewares para rutas, ej. auth, roles, permisos
│
├── pages/                   # Páginas automáticamente enlazadas a rutas
│   ├── index.vue            # Página principal o dashboard
│   ├── login.vue
│   ├── usuarios/            # Carpeta con CRUD de usuarios
│   │   ├── index.vue        # Listado de usuarios
│   │   ├── [id].vue         # Vista detalle o edición
│   │   └── create.vue       # Crear usuario
│   ├── roles/
│   ├── personas/
│   ├── permisos/
│   └── configuraciones/
│
├── plugins/                 # Plugins Nuxt, ej. para Swiper, axios (si usas), etc
│
├── public/                  # Archivos estáticos (favicon, robots.txt)
│
├── utils/                   # Utilidades y helpers JS/TS
│
├── nuxt.config.ts           # Configuración principal Nuxt
└── package.json
