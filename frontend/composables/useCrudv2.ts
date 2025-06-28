import { ref, computed } from 'vue'
import { useRuntimeConfig } from '#imports'

export function useCrud<T>(endpoint: string) {
    const config = useRuntimeConfig()
    const baseUrl = config.public.apiBaseUrl + '/' + endpoint

    const items = ref<T[]>([])
    const item = ref<Partial<T> | null>(null)
    const loading = ref(false)
    const error = ref<string | null>(null)

    const fetchAll = async () => {
        loading.value = true
        error.value = null
        try {
            items.value = await $fetch<T[]>(baseUrl)
        } catch (err: any) {
            error.value = err.data?.detail || err.message
        } finally {
            loading.value = false
        }
    }

    const fetchOne = async (id: number | string) => {
        loading.value = true
        error.value = null
        try {
            item.value = await $fetch<T>(`${baseUrl}/${id}`)
        } catch (err: any) {
            error.value = err.data?.detail || err.message
        } finally {
            loading.value = false
        }
    }

    const create = async (data: any) => {
        error.value = null
        try {
            const created = await $fetch<T>(baseUrl, {
                method: 'POST',
                body: data
            })
            await fetchAll()
            return created
        } catch (err: any) {
            error.value = err.data?.detail || err.message
            throw err
        }
    }

    const update = async (id: number | string, data: any) => {
        error.value = null
        try {
            const updated = await $fetch<T>(`${baseUrl}/${id}`, {
                method: 'PUT',
                body: data
            })
            await fetchAll()
            return updated
        } catch (err: any) {
            error.value = err.data?.detail || err.message
            throw err
        }
    }

    const remove = async (id: number | string) => {
        error.value = null
        try {
            await $fetch(`${baseUrl}/${id}`, {
                method: 'DELETE'
            })
            await fetchAll()
        } catch (err: any) {
            error.value = err.data?.detail || err.message
            throw err
        }
    }

    return {
        items,
        item,
        loading,
        error,
        fetchAll,
        fetchOne,
        create,
        update,
        remove
    }
}
