export const useCrudRelations = () => {
  const relationData = ref<Record<string, any[]>>({})

  const fetchRelations = async (relations: RelationConfig[]) => {
    await Promise.all(
      relations.map(async ({ resource, key }) => {
        const { items } = useCrud(resource)
        await items.fetch()
        relationData.value[key] = items.value
      })
    )
  }

  const getRelationOptions = (relationKey: string) => {
    return relationData.value[relationKey]?.map(item => ({
      label: item.name,
      value: item.id
    })) || []
  }

  return { 
    relationData,
    fetchRelations,
    getRelationOptions 
  }
}