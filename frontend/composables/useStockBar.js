export const useStockBar = () => {
  const getStockInfo = (producto, maximoVisual = 30) => {
    const porcentaje = Math.min((producto.stock / maximoVisual) * 100, 100);

    let clase = '';
    let texto = '';

    if (producto.stock > 10) {
      clase = 'stock-high';
      texto = 'Disponible';
    } else if (producto.stock > 0) {
      clase = 'stock-medium';
      texto = `Últimas ${producto.stock} unidades`;
    } else {
      clase = 'stock-low';
      texto = 'Agotado';
    }

    return {
      clase,
      texto,
      estilo: { width: porcentaje + '%' }
    };
  };

  return {
    getStockInfo
  };
};
