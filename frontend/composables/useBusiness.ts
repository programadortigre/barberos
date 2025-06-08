export function useBusiness() {
  const business = ref({
    name: '',
    category: '',
    logo: '',
  })

  const saveBusiness = (data: { name: string; category: string; logo?: string }) => {
    business.value = { ...data }
    localStorage.setItem('business', JSON.stringify(business.value))
  }

  const loadBusiness = () => {
    const stored = localStorage.getItem('business')
    if (stored) {
      business.value = JSON.parse(stored)
    }
  }

  const clearBusiness = () => {
    localStorage.removeItem('business')
    business.value = { name: '', category: '', logo: '' }
  }

  // Carga automáticamente si existe
  onMounted(() => {
    loadBusiness()
  })

  return {
    business,
    saveBusiness,
    loadBusiness,
    clearBusiness,
  }
}
