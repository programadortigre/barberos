<script setup>
definePageMeta({ layout: 'aplicacion' })
</script>
<template>

    <div class="container">
        <div class="content">
            <!-- Bienvenida Mejorada -->
            <div class="tabs">
                <div class="tab active" data-tab="register">Registrar venta</div>
                <div class="tab" data-tab="history">Historial</div>
            </div>
            <div id="register-tab" class="tab-content">
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-shopping-cart"></i>
                        <h2>Detalles de la venta</h2>
                    </div>

                    <div class="form-group">
                        <label for="client">Cliente</label>
                        <div class="select-wrapper">
                            <select id="client" class="form-control">
                                <option value="">Seleccionar cliente</option>
                                <option value="1">Juan Pérez (Cliente frecuente)</option>
                                <option value="2">María García</option>
                                <option value="3">Carlos López</option>
                                <option value="4">Ana Martínez</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="date">Fecha y hora</label>
                        <input type="datetime-local" id="date" class="form-control" value="2025-06-21T14:30">
                    </div>

                    <div class="form-group">
                        <label for="payment">Método de pago</label>
                        <div class="select-wrapper">
                            <select id="payment" class="form-control">
                                <option value="">Seleccionar método</option>
                                <option value="cash">Efectivo</option>
                                <option value="card">Tarjeta de crédito</option>
                                <option value="transfer">Transferencia</option>
                                <option value="digital">Pago digital</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-box"></i>
                        <h2>Productos</h2>
                    </div>

                    <div class="product-list">
                        <div class="product-item">
                            <div class="product-img">
                                <i class="fas fa-tshirt"></i>
                            </div>
                            <div class="product-details">
                                <div class="product-name">Camiseta básica</div>
                                <div class="product-price">$25.00</div>
                            </div>
                            <div class="product-quantity">
                                <div class="quantity-btn minus">-</div>
                                <input type="text" class="quantity-input" value="2" readonly="">
                                <div class="quantity-btn plus">+</div>
                            </div>
                        </div>

                        <div class="product-item">
                            <div class="product-img">
                                <i class="fas fa-shoe-prints"></i>
                            </div>
                            <div class="product-details">
                                <div class="product-name">Zapatos deportivos</div>
                                <div class="product-price">$59.99</div>
                            </div>
                            <div class="product-quantity">
                                <div class="quantity-btn minus">-</div>
                                <input type="text" class="quantity-input" value="1" readonly="">
                                <div class="quantity-btn plus">+</div>
                            </div>
                        </div>

                        <div class="product-item">
                            <div class="product-img">
                                <i class="fas fa-baseball-ball"></i>
                            </div>
                            <div class="product-details">
                                <div class="product-name">Balón de fútbol</div>
                                <div class="product-price">$19.99</div>
                            </div>
                            <div class="product-quantity">
                                <div class="quantity-btn minus">-</div>
                                <input type="text" class="quantity-input" value="1" readonly="">
                                <div class="quantity-btn plus">+</div>
                            </div>
                        </div>
                    </div>

                    <button class="btn btn-outline">
                        <i class="fas fa-plus"></i> Agregar producto
                    </button>
                </div>

                <div class="card">
                    <div class="total-summary">
                        <div class="total-label">Total:</div>
                        <div class="total-amount">$129.97</div>
                    </div>

                    <div class="form-group">
                        <label for="discount">Descuento</label>
                        <input type="text" id="discount" class="form-control" placeholder="0.00">
                    </div>

                    <div class="form-group">
                        <label for="notes">Notas adicionales</label>
                        <textarea id="notes" class="form-control" rows="3"
                            placeholder="Agregar notas sobre esta venta"></textarea>
                    </div>

                    <button class="btn">
                        <i class="fas fa-check"></i> Registrar venta
                    </button>
                </div>
            </div>
            <!-- Bienvenida Mejorada -->

        </div>
    </div>

</template>
<style scoped lang="scss">
.tabs {
    display: flex;
    background: white;
    margin: 0 15px 20px;
    border-radius: 50px;
    padding: 5px;
    box-shadow: var(--card-shadow);

    .tab {
        flex: 1;
        text-align: center;
        padding: 12px;
        border-radius: 50px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s;
    }

    .tab.active {
        background: var(--primary);
        color: white;
    }
}

.card {
    background: white;
    border-radius: 16px;
    box-shadow: var(--card-shadow);
    padding: 20px;
    margin: 0 15px 20px;

    .card-title {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid var(--light-gray);

        i {
            background: var(--primary);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 18px;
        }

        h2 {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
        }
    }
}

.form-group {
    margin-bottom: 20px;

    label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: var(--dark);
    }

    .select-wrapper {
        position: relative;

        &::after {
            content: "▼";
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
            pointer-events: none;
        }

        select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background: white;
        }


    }

    .form-control {
        width: 100%;
        padding: 15px;
        border: 2px solid var(--border);
        border-radius: 12px;
        font-size: 16px;
        transition: all 0.3s;

        &:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }

    }
}
</style>