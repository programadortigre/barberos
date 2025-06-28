export function mapSelectOptions(items: any[], labelKey = 'nombre', valueKey = 'id') {
    return items.map(item => ({
        label: item[labelKey],
        value: item[valueKey]
    }))
}
