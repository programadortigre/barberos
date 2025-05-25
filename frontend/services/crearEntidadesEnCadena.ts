export const crearEntidadesEnCadena = async (steps = [], apiBase) => {
    const resultados = {}
    for (const step of steps) {
        const resolvedBody = typeof step.body === 'function' ? step.body(resultados) : step.body
        const res = await $fetch(`${apiBase}/${step.endpoint}`, {
            method: step.method || 'POST',
            body: resolvedBody
        })
        resultados[step.key] = res
    }
    return resultados
}
