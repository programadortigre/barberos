export const useRoles = () => {
    const config = useRuntimeConfig();
    const baseUrl = config.public.apiBaseUrl + '/roles';

    const listarRoles = () => useFetch(baseUrl);

    const obtenerRol = (id: number) => useFetch(`${baseUrl}/${id}`);

    const crearRol = (data: { nombre: string, descripcion: string }) =>
        useFetch(baseUrl, {
            method: 'POST',
            body: data
        });

    const actualizarRol = (id: number, data: { nombre: string, descripcion: string }) =>
        useFetch(`${baseUrl}/${id}`, {
            method: 'PUT',
            body: data
        });

    const eliminarRol = (id: number) =>
        useFetch(`${baseUrl}/${id}`, {
            method: 'DELETE'
        });

    return {
        listarRoles,
        obtenerRol,
        crearRol,
        actualizarRol,
        eliminarRol
    };
};
