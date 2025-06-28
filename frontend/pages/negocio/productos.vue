<script setup>
definePageMeta({ layout: 'aplicacion' })
</script>
<template>

    <div class="container">
        <div class="content">
            <!-- Bienvenida Mejorada -->
            <div class="card">
                <div class="search-bar">
                    <input type="text" class="search-input" placeholder="Buscar productos...">
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>

                <div class="filter-bar">
                    <div class="filter-btn active">Todos</div>
                    <div class="filter-btn">Bajo stock</div>
                    <div class="filter-btn">Agotados</div>
                    <div class="filter-btn">Próximos a vencer</div>
                    <div class="filter-btn">Sin movimiento</div>
                </div>

                <ul class="inventory-list">
                    <li class="inventory-item">
                        <div class="inventory-img">
                            <i class="fas fa-tshirt"></i>
                        </div>
                        <div class="inventory-details">
                            <div class="inventory-name">Camiseta Algodón Premium</div>
                            <div class="inventory-info">
                                <span>SKU: CM-001</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Categoría: Ropa</span>
                            </div>
                            <div class="inventory-stock">
                                <span>Stock: 45</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Mínimo: 10</span>
                            </div>
                            <div class="stock-bar">
                                <div class="stock-level stock-high"></div>
                            </div>
                        </div>
                    </li>

                    <li class="inventory-item">
                        <div class="inventory-img">
                            <i class="fas fa-blender"></i>
                        </div>
                        <div class="inventory-details">
                            <div class="inventory-name">Licuadora Profesional</div>
                            <div class="inventory-info">
                                <span>SKU: LC-450</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Categoría: Hogar</span>
                            </div>
                            <div class="inventory-stock">
                                <span>Stock: 3</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Mínimo: 5</span>
                            </div>
                            <div class="stock-bar">
                                <div class="stock-level stock-low"></div>
                            </div>
                        </div>
                    </li>

                    <li class="inventory-item">
                        <div class="inventory-img">
                            <i class="fas fa-wine-bottle"></i>
                        </div>
                        <div class="inventory-details">
                            <div class="inventory-name">Aceite de Oliva Extra Virgen</div>
                            <div class="inventory-info">
                                <span>SKU: AL-022</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Categoría: Alimentos</span>
                            </div>
                            <div class="inventory-stock">
                                <span>Stock: 0</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Mínimo: 5</span>
                            </div>
                            <div class="stock-bar">
                                <div class="stock-level stock-low" style="width: 0"></div>
                            </div>
                        </div>
                    </li>

                    <li class="inventory-item">
                        <div class="inventory-img">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="inventory-details">
                            <div class="inventory-name">Libro de Cocina Gourmet</div>
                            <div class="inventory-info">
                                <span>SKU: LB-780</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Categoría: Libros</span>
                            </div>
                            <div class="inventory-stock">
                                <span>Stock: 28</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Mínimo: 5</span>
                            </div>
                            <div class="stock-bar">
                                <div class="stock-level stock-high"></div>
                            </div>
                        </div>
                    </li>

                    <li class="inventory-item">
                        <div class="inventory-img">
                            <i class="fas fa-headphones"></i>
                        </div>
                        <div class="inventory-details">
                            <div class="inventory-name">Audífonos Bluetooth</div>
                            <div class="inventory-info">
                                <span>SKU: AU-205</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Categoría: Electrónica</span>
                            </div>
                            <div class="inventory-stock">
                                <span>Stock: 12</span>
                                <span style="margin: 0 10px;">|</span>
                                <span>Mínimo: 8</span>
                            </div>
                            <div class="stock-bar">
                                <div class="stock-level stock-medium"></div>
                            </div>
                        </div>
                    </li>
                </ul>

                <button class="btn btn-outline">
                    <i class="fas fa-sync-alt"></i> Cargar más productos
                </button>
            </div>
            <!-- Bienvenida Mejorada -->

        </div>
    </div>

</template>
<style scoped lang="scss">
.card {
    background: var(--color-bg);
    border-radius: 16px;
    box-shadow: var(--card-shadow);
    padding: 20px;
    margin: 0 15px 20px;
}

.search-bar {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;

    .search-input {
        flex: 1;
        padding: 15px;
        border: 2px solid var(--border);
        border-radius: 12px;
        font-size: 16px;
    }

    .search-btn {
        width: 50px;
        background: var(--primary);
        color: white;
        border: none;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
    }
}

.filter-bar {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
    overflow-x: auto;
    padding-bottom: 5px;

    .filter-bar::-webkit-scrollbar {
        height: 4px;
    }

    .filter-bar::-webkit-scrollbar-thumb {
        background: var(--primary);
        border-radius: 2px;
    }

    .filter-btn {
        padding: 10px 15px;
        background: white;
        border: 2px solid var(--border);
        border-radius: 50px;
        font-size: 14px;
        font-weight: 500;
        white-space: nowrap;
        cursor: pointer;
        transition: all 0.3s;
    }

    .filter-btn.active {
        background: var(--primary);
        color: white;
        border-color: var(--primary);
    }

}

.inventory-list {
    list-style: none;

    .inventory-item {
        display: flex;
        align-items: center;
        padding: 15px 0;
        border-bottom: 1px solid var(--border);

        &:last-child {
            border-bottom: none;
        }

        .inventory-img {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            background: var(--light-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            overflow: hidden;

            i {
                font-size: 24px;
                color: var(--gray);
            }
        }

        .inventory-details {
            flex: 1;

            .inventory-name {
                font-weight: 600;
                margin-bottom: 5px;
            }

            .inventory-info {
                display: flex;
                font-size: 14px;
                color: var(--gray);
                margin-bottom: 5px;
            }

            .inventory-stock {
                display: flex;
                align-items: center;
            }

            .stock-bar {
                height: 6px;
                background: var(--light-gray);
                border-radius: 3px;
                margin-top: 8px;
                overflow: hidden;
                position: relative;

                .stock-level {
                    height: 100%;
                    border-radius: 3px;
                    position: absolute;
                    left: 0;
                    top: 0;
                }

                .stock-high {
                    background: var(--success);
                    width: 85%;
                }

                .stock-medium {
                    background: var(--warning);
                    width: 45%;
                }

                .stock-low {
                    background: var(--danger);
                    width: 15%;
                }
            }
        }
    }
}
</style>