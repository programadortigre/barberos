-- Tabla usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    estado ENUM('activo', 'suspendido', 'eliminado') DEFAULT 'activo',
    ultimo_login DATETIME,
    intentos_fallidos INT DEFAULT 0,
    api_key_hash VARCHAR(255),
    api_key_expira DATETIME,
    creado_por INT,
    modificado_por INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_persona FOREIGN KEY (persona_id) REFERENCES personas(id),
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES roles(id),
    CONSTRAINT fk_usuarios_creado_por FOREIGN KEY (creado_por) REFERENCES usuarios(id),
    CONSTRAINT fk_usuarios_modificado_por FOREIGN KEY (modificado_por) REFERENCES usuarios(id)
);
-- Tabla roles
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla personas
CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(20) NOT NULL,
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) NOT NULL DEFAULT 'O' COMMENT 'M: Masculino, F: Femenino, O: Otro',
    direccion_cifrada VARBINARY(512),
    telefono_cifrado VARBINARY(128),
    correo_cifrado VARBINARY(256),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_apellidos (apellido_paterno, apellido_materno)
);

-- Tabla permisos
CREATE TABLE permisos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    clave VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Tabla roles_permisos (relación muchos a muchos)
CREATE TABLE roles_permisos (
    rol_id INT NOT NULL,
    permiso_id INT NOT NULL,
    creado_por INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (rol_id, permiso_id),
    CONSTRAINT fk_roles_permisos_rol FOREIGN KEY (rol_id) REFERENCES roles(id),
    CONSTRAINT fk_roles_permisos_permiso FOREIGN KEY (permiso_id) REFERENCES permisos(id),
    CONSTRAINT fk_roles_permisos_creado_por FOREIGN KEY (creado_por) REFERENCES usuarios(id)
);
-- Tabla logs_usuarios
CREATE TABLE logs_usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    accion VARCHAR(255) NOT NULL,
    tabla_afectada VARCHAR(100),
    registro_id INT,
    descripcion TEXT,
    ip_address VARCHAR(45),
    detalles_json TEXT,
    user_agent VARCHAR(255),
    navegador VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_logs_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
-- Tabla tokens
CREATE TABLE tokens (
    token CHAR(36) PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo_token ENUM('access', 'refresh', 'api'),
    expiracion DATETIME NOT NULL,
    revocado BOOLEAN DEFAULT FALSE,
    revocado_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tokens_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
-- Tabla tipos_perfil
CREATE TABLE tipos_perfil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    campos_json TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla perfiles
CREATE TABLE perfiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    tipo_perfil_id INT NOT NULL,
    datos_personalizados_json TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY ux_perfiles_persona_tipo (persona_id, tipo_perfil_id),
    CONSTRAINT fk_perfiles_persona FOREIGN KEY (persona_id) REFERENCES personas(id),
    CONSTRAINT fk_perfiles_tipo_perfil FOREIGN KEY (tipo_perfil_id) REFERENCES tipos_perfil(id)
);
-- Tabla configuraciones
CREATE TABLE configuraciones (
    clave VARCHAR(100) PRIMARY KEY,
    valor TEXT NOT NULL,
    descripcion TEXT,
    tipo ENUM('string', 'int', 'bool', 'json') DEFAULT 'string',
    creado_por INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_configuraciones_creado_por FOREIGN KEY (creado_por) REFERENCES usuarios(id)
);