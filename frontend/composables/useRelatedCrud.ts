// composables/useRelatedCrud.ts
import { ref } from 'vue'
import { useRuntimeConfig } from '#imports'

export function useRelatedCrud<TMain, TRelated extends Record<string, any>>(
    mainEndpoint: string,
    relatedEndpoints: string[]
) {
    const config = useRuntimeConfig()
    const baseUrl = config.public.apiBaseUrl

    const items = ref<TMain[]>([])
    const relatedData = ref<Record<string, TRelated[]>>({})

    const loading = ref(false)
    const error = ref<string | null>(null)

    async function fetchMain() {
        loading.value = true
        error.value = null
        try {
            items.value = await $fetch<TMain[]>(`${baseUrl}/${mainEndpoint}`)
        } catch (err: any) {
            error.value = err.data?.detail || err.message
        } finally {
            loading.value = false
        }
    }

    async function fetchRelated() {
        loading.value = true
        error.value = null
        try {
            for (const endpoint of relatedEndpoints) {
                relatedData.value[endpoint] = await $fetch<TRelated[]>(`${baseUrl}/${endpoint}`)
            }
        } catch (err: any) {
            error.value = err.data?.detail || err.message
        } finally {
            loading.value = false
        }
    }

    async function fetchAll() {
        await Promise.all([fetchMain(), fetchRelated()])
    }

    return {
        items,
        relatedData,
        loading,
        error,
        fetchAll,
    }
}
