// composables/useUsuarios.ts

const baseUrl = 'http://localhost:8000/usuarios'

export function useUsuarios() {
    const getUsuarios = () => useFetch(baseUrl)

    const getUsuario = (id: number) => useFetch(`${baseUrl}/${id}`)

    const crearUsuario = async (datos: {
        username: string
        password: string
        estado: string
        persona_id: number
        rol_id: number
    }) => {
        return await $fetch(baseUrl, {
            method: 'POST',
            body: datos,
        })
    }

    const actualizarUsuario = async (id: number, datos: any) => {
        return await $fetch(`${baseUrl}/${id}`, {
            method: 'PUT',
            body: datos,
        })
    }

    const eliminarUsuario = async (id: number) => {
        return await $fetch(`${baseUrl}/${id}`, {
            method: 'DELETE',
        })
    }

    return {
        getUsuarios,
        getUsuario,
        crearUsuario,
        actualizarUsuario,
        eliminarUsuario,
    }
}
