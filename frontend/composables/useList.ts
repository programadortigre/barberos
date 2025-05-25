import { ref } from 'vue'
import { useRuntimeConfig } from '#app'

export function useList(endpoint: string) {
    const config = useRuntimeConfig()
    const baseUrl = config.public.apiBaseUrl + '/' + endpoint

    const items = ref<any[]>([])
    const error = ref<string | null>(null)
    const loading = ref(false)

    const cargar = async () => {
        loading.value = true
        error.value = null
        try {
            items.value = await $fetch(baseUrl)
        } catch (err: any) {
            error.value = err.data?.detail || err.message
        } finally {
            loading.value = false
        }
    }

    return { items, error, loading, cargar }
}
