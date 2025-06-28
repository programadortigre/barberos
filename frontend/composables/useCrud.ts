import { ref, reactive } from 'vue'
import { useRuntimeConfig } from '#app'

export function useCrud<T extends { id?: number | null }>(endpoint: string) {
    const config = useRuntimeConfig()
    const apiBase = config.public.apiBaseUrl?.replace(/\/$/, '') || ''
    const endpointClean = endpoint.replace(/^\//, '')
    const baseUrl = `${apiBase}/${endpointClean}`



    const items = ref<T[]>([])
    const form = reactive<T>({} as T)
    const mensaje = ref('')
    const error = ref<string | null>(null)
    const loading = ref(false)

    const cargar = async () => {
        loading.value = true
        error.value = null
        try {
            items.value = await $fetch<T[]>(baseUrl)
        } catch (err: any) {
            error.value = err.data?.detail || err.message || 'Error al cargar datos'
        } finally {
            loading.value = false
        }
    }

    const fetchAll = async () => {
        await cargar()
    }

    const guardar = async (): Promise<boolean> => {
        if (!form) {
            mensaje.value = 'Formulario incompleto'
            return false
        }

        const method = form.id ? 'PUT' : 'POST'
        const url = form.id ? `${baseUrl}/${form.id}` : baseUrl

        try {
            await $fetch(url, {
                method,
                body: form
            })
            mensaje.value = form.id ? 'Actualizado correctamente' : 'Creado correctamente'
            await cargar()
            return true
        } catch (err: any) {
            mensaje.value = 'Error al guardar'
            error.value = err.data?.detail || err.message || 'Error desconocido'
            return false
        }
    }

    const eliminar = async (id: number) => {
        if (!confirm('¿Seguro quieres eliminar este registro?')) return
        try {
            await $fetch(`${baseUrl}/${id}`, {
                method: 'DELETE'
            })
            mensaje.value = 'Eliminado correctamente'
            await cargar()
        } catch (err: any) {
            mensaje.value = 'Error al eliminar'
            error.value = err.data?.detail || err.message || 'Error desconocido'
        }
    }

    const editar = (item: T) => {
        Object.assign(form, item)
        mensaje.value = ''
    }

    const limpiar = () => {
        Object.keys(form).forEach(key => {
            // Mejor usar undefined para resetear campos (depende del input)
            // @ts-ignore
            form[key] = undefined
        })
        mensaje.value = ''
        error.value = null
    }

    return {
        items,
        form,
        mensaje,
        error,
        loading,
        guardar,
        eliminar,
        editar,
        limpiar,
        cargar,
        fetchAll,   // agrego fetchAll para mayor claridad
    }
}
