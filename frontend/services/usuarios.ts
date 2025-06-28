// services/usuarios.ts
export const obtenerUsuarios = async (apiBase: string) => {
    return await $fetch(`${apiBase}/usuarios?incluir_relaciones=true`)
}
