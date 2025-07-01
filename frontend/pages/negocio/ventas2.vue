<template>
    <div class="app-container">
        <!-- Encabezado estilo app -->
        <header class="app-header">
            <div class="header-decoration"></div>
            <div class="header-decoration"></div>

            <div class="header-top">
                <div class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-store"></i>
                    </div>
                    <span>VentasYape</span>
                </div>
                <div class="header-actions">
                    <div class="header-icon" @click="showNotification('Historial de ventas', true)">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="header-icon" @click="showNotification('No hay notificaciones', true)">
                        <i class="fas fa-bell"></i>
                    </div>
                </div>
            </div>
            <div class="header-title">Nueva Venta</div>
        </header>

        <!-- Contenido principal -->
        <div class="app-content">
            <!-- Tarjeta de cliente estilo app -->
            <div class="client-card animate-in">
                <div class="client-header">
                    <div class="section-title">
                        <i class="fas fa-user-circle"></i>
                        <span>Cliente</span>
                    </div>
                    <button class="action-button" @click="showClientModal = true">
                        <i class="fas fa-exchange-alt"></i>
                        <span>Cambiar</span>
                    </button>
                </div>
                <div class="client-info">
                    <div class="client-avatar">{{ selectedClient.name.charAt(0) }}</div>
                    <div class="client-details">
                        <div class="client-name">{{ selectedClient.name }}</div>
                        <div class="client-contact">
                            <i class="fas fa-envelope"></i>
                            <span>{{ selectedClient.email }}</span>
                        </div>
                        <div class="client-contact">
                            <i class="fas fa-phone"></i>
                            <span>{{ selectedClient.phone }}</span>
                        </div>
                        <div class="client-notes">
                            <i class="fas fa-info-circle"></i>
                            {{ selectedClient.notes }}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Buscador de productos estilo app -->
            <div class="search-container animate-in">
                <div class="search-bar">
                    <div class="search-input">
                        <i class="fas fa-search"></i>
                        <input type="text" v-model="searchTerm" placeholder="Buscar productos...">
                    </div>
                    <div class="filter-button" @click="showNotification('Filtros aplicados', true)">
                        <i class="fas fa-filter"></i>
                    </div>
                </div>
            </div>

            <!-- Productos -->
            <div class="section-title animate-in">
                <i class="fas fa-box"></i>
                <span>Productos Disponibles</span>
            </div>

            <ul class="products-grid">
                <li class="product-card animate-in" v-for="product in filteredProducts" :key="product.id"
                    @click="addToCart(product)">
                    <div class="product-image">
                        <i :class="product.img"></i>
                    </div>
                    <div class="product-info">
                        <div class="product-title">{{ product.name }}</div>
                        <div class="product-price">${{ product.price.toFixed(2) }}</div>
                        <div class="product-stock" :class="{
                            'in-stock': product.stock > 10,
                            'low-stock': product.stock > 0 && product.stock <= 10,
                            'out-of-stock': product.stock === 0
                        }">
                            <i :class="{
                                'fas fa-check-circle': product.stock > 10,
                                'fas fa-exclamation-triangle': product.stock > 0 && product.stock <= 10,
                                'fas fa-times-circle': product.stock === 0
                            }"></i>
                            {{ stockStatusText(product) }}
                        </div>
                    </div>
                </li>
            </ul>

            <!-- Venta actual estilo app -->
            <div class="section-title animate-in">
                <i class="fas fa-shopping-cart"></i>
                <span>Tu Venta</span>
            </div>
            <div class="current-sale animate-in">
                <div class="sale-header">
                    <div class="sale-title">
                        <span>Resumen</span>
                    </div>
                    <button class="action-button" @click="clearCart">
                        <i class="fas fa-trash-alt"></i>
                        <span>Limpiar</span>
                    </button>
                </div>

                <div class="sale-items">
                    <div class="no-products" v-if="cart.length === 0">Agrega productos a tu venta</div>
                    <div class="sale-item" v-for="item in cart" :key="item.id">
                        <div class="item-info">
                            <div class="item-name">{{ item.name }}</div>
                            <div class="item-details">
                                <span>${{ item.price.toFixed(2) }}</span>
                                <span>{{ item.quantity }} {{ item.quantity > 1 ? 'unidades' : 'unidad' }}</span>
                            </div>
                        </div>
                        <div class="item-actions">
                            <div class="quantity-control">
                                <div class="quantity-btn minus" @click.stop="updateQuantity(item.id, -1)">
                                    <i class="fas fa-minus"></i>
                                </div>
                                <div class="quantity-value">{{ item.quantity }}</div>
                                <div class="quantity-btn plus" @click.stop="updateQuantity(item.id, 1)">
                                    <i class="fas fa-plus"></i>
                                </div>
                            </div>
                            <div class="remove-btn" @click.stop="removeFromCart(item.id)">
                                <i class="fas fa-trash"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="sale-summary">
                    <div class="discount-input">
                        <input type="text" v-model="discountInput" placeholder="Descuento (ej. 10% o $5)"
                            @keyup.enter="applyDiscount">
                        <button @click="applyDiscount">Aplicar</button>
                    </div>

                    <div class="summary-row">
                        <span>Subtotal:</span>
                        <span>${{ subtotal.toFixed(2) }}</span>
                    </div>
                    <div class="summary-row">
                        <span>Descuento:</span>
                        <span>- ${{ discountAmount.toFixed(2) }}</span>
                    </div>
                    <div class="summary-row">
                        <span>IVA (12%):</span>
                        <span>${{ taxAmount.toFixed(2) }}</span>
                    </div>
                    <div class="summary-row total-row">
                        <span>Total:</span>
                        <span>${{ totalAmount.toFixed(2) }}</span>
                    </div>
                </div>
            </div>

            <!-- Botones de acción estilo app -->
            <div class="action-buttons">
                <button class="btn btn-cancel" @click="cancelSale">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                <button class="btn btn-pay" @click="showPaymentModal = true">
                    <i class="fas fa-credit-card"></i>
                    Cobrar
                </button>
            </div>
        </div>

        <!-- Botón flotante para crear cliente -->
        <div class="floating-btn" @click="showCreateClientModal = true">
            <i class="fas fa-plus"></i>
        </div>

        <!-- Modal Cliente estilo app -->
        <div class="modal" :class="{ active: showClientModal }">
            <div class="modal-content">
                <div class="modal-header">Seleccionar Cliente</div>
                <div class="modal-body">
                    <div class="help-text">Puedes buscar un cliente existente o crear uno nuevo</div>

                    <div class="form-group">
                        <label for="client-search"><i class="fas fa-search"></i> Buscar Cliente:</label>
                        <input type="text" v-model="clientSearch" placeholder="Nombre, teléfono o email">
                    </div>

                    <div class="client-list">
                        <div class="client-info" v-for="client in filteredClients" :key="client.id"
                            @click="selectClient(client)"
                            style="cursor: pointer; padding: 15px; border-bottom: 1px solid #eee; transition: var(--transition);">
                            <div class="client-avatar">{{ client.name.charAt(0) }}</div>
                            <div class="client-details">
                                <div class="client-name">{{ client.name }}</div>
                                <div class="client-contact">
                                    <i class="fas fa-envelope"></i> {{ client.email }}
                                </div>
                                <div class="client-contact">
                                    <i class="fas fa-phone"></i> {{ client.phone }}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="modal-btn modal-btn-cancel" @click="showClientModal = false">Cancelar</button>
                    <button class="modal-btn modal-btn-confirm"
                        @click="showCreateClientModal = true; showClientModal = false;">
                        Crear Cliente
                    </button>
                </div>
            </div>
        </div>

        <!-- Modal Crear Cliente estilo app -->
        <div class="modal" :class="{ active: showCreateClientModal }">
            <div class="modal-content">
                <div class="modal-header">Crear Nuevo Cliente</div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="client-name"><i class="fas fa-user"></i> Nombre completo:</label>
                        <input type="text" v-model="newClient.name" placeholder="Ingrese el nombre completo">
                    </div>

                    <div class="form-group">
                        <label for="client-email"><i class="fas fa-envelope"></i> Email:</label>
                        <input type="email" v-model="newClient.email" placeholder="Ingrese el email">
                    </div>

                    <div class="form-group">
                        <label for="client-phone"><i class="fas fa-phone"></i> Teléfono:</label>
                        <input type="text" v-model="newClient.phone" placeholder="Ingrese el teléfono">
                    </div>

                    <div class="form-group">
                        <label for="client-notes"><i class="fas fa-info-circle"></i> Notas:</label>
                        <input type="text" v-model="newClient.notes" placeholder="Información adicional">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="modal-btn modal-btn-cancel" @click="showCreateClientModal = false">Cancelar</button>
                    <button class="modal-btn modal-btn-confirm" @click="saveNewClient">Guardar Cliente</button>
                </div>
            </div>
        </div>

        <!-- Modal Método de Pago estilo app -->
        <div class="modal" :class="{ active: showPaymentModal }">
            <div class="modal-content">
                <div class="modal-header">Método de Pago</div>
                <div class="modal-body">
                    <div class="help-text">Selecciona cómo deseas recibir el pago</div>

                    <div class="payment-methods">
                        <div class="payment-method" :class="{ active: paymentMethod === 'cash' }"
                            @click="paymentMethod = 'cash'">
                            <i class="fas fa-money-bill-wave"></i>
                            <span>Efectivo</span>
                        </div>
                        <div class="payment-method" :class="{ active: paymentMethod === 'card' }"
                            @click="paymentMethod = 'card'">
                            <i class="fas fa-credit-card"></i>
                            <span>Tarjeta</span>
                        </div>
                        <div class="payment-method" :class="{ active: paymentMethod === 'transfer' }"
                            @click="paymentMethod = 'transfer'">
                            <i class="fas fa-exchange-alt"></i>
                            <span>Transferencia</span>
                        </div>
                        <div class="payment-method" :class="{ active: paymentMethod === 'check' }"
                            @click="paymentMethod = 'check'">
                            <i class="fas fa-money-check"></i>
                            <span>Cheque</span>
                        </div>
                    </div>

                    <div class="form-group" style="margin-top:25px;">
                        <label for="payment-notes"><i class="fas fa-sticky-note"></i> Notas (opcional):</label>
                        <input type="text" v-model="paymentNotes" placeholder="Ej: Pago en dos cuotas">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="modal-btn modal-btn-cancel" @click="showPaymentModal = false">Cancelar</button>
                    <button class="modal-btn modal-btn-confirm" @click="confirmPayment">Confirmar Pago</button>
                </div>
            </div>
        </div>

        <!-- Modal Confirmación estilo app -->
        <div class="modal" :class="{ active: showConfirmationModal }">
            <div class="modal-content">
                <div class="modal-header">¡Venta Completada!</div>
                <div class="modal-body">
                    <div style="text-align:center; padding:40px 0;">
                        <i class="fas fa-check-circle" style="font-size:5rem; color:#36d7b7;"></i>
                        <h2 style="margin:30px 0; font-size:1.8rem;">¡Transacción exitosa!</h2>
                        <p style="font-size:1.3rem; margin-bottom:15px;">Cliente: <strong>{{ selectedClient.name
                        }}</strong></p>
                        <p style="font-size:1.3rem; margin-bottom:15px;">Método: <strong>{{ paymentMethodText
                        }}</strong></p>
                        <p style="font-size:1.3rem; margin-bottom:25px;">Total: <strong>${{ totalAmount.toFixed(2)
                        }}</strong></p>
                        <p
                            style="font-size:1.2rem; background: rgba(54, 215, 183, 0.1); padding: 15px; border-radius: 12px;">
                            Se ha enviado un comprobante al cliente
                        </p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="modal-btn modal-btn-confirm" @click="closeConfirmation">Aceptar</button>
                </div>
            </div>
        </div>

        <!-- Notificación flotante -->
        <div v-if="notification.show" class="notification" :class="{ success: notification.success }">
            <i :class="notification.icon"></i>
            <span>{{ notification.message }}</span>
        </div>
    </div>
</template>

<script setup>
definePageMeta({ layout: 'aplicacion' })

import { ref, reactive, computed, onMounted } from 'vue';

// Datos de productos
const products = ref([
    {
        id: 1,
        name: "Laptop HP ProBook",
        sku: "LAP-HP-001",
        img: "fas fa-laptop",
        price: 899.99,
        stock: 15,
        min: 10,
        category: "Tecnología"
    },
    {
        id: 2,
        name: "Smartphone Samsung S21",
        sku: "PHN-SS-002",
        img: "fas fa-mobile-alt",
        price: 749.99,
        stock: 8,
        min: 5,
        category: "Tecnología"
    },
    {
        id: 3,
        name: "Tablet iPad Air",
        sku: "TAB-IPAD-003",
        img: "fas fa-tablet-alt",
        price: 599.99,
        stock: 12,
        min: 8,
        category: "Tecnología"
    },
    {
        id: 4,
        name: "Monitor 24\" Full HD",
        sku: "MON-FHD-004",
        img: "fas fa-desktop",
        price: 199.99,
        stock: 5,
        min: 4,
        category: "Tecnología"
    },
    {
        id: 5,
        name: "Teclado Inalámbrico",
        sku: "KEY-WL-005",
        img: "fas fa-keyboard",
        price: 59.99,
        stock: 22,
        min: 10,
        category: "Accesorios"
    },
    {
        id: 6,
        name: "Mouse Ergonómico",
        sku: "MSE-ERG-006",
        img: "fas fa-mouse",
        price: 39.99,
        stock: 30,
        min: 12,
        category: "Accesorios"
    },
    {
        id: 7,
        name: "Impresora Multifuncional",
        sku: "PRT-MULTI-007",
        img: "fas fa-print",
        price: 129.99,
        stock: 7,
        min: 5,
        category: "Oficina"
    },
    {
        id: 8,
        name: "Disco Duro Externo 1TB",
        sku: "HDD-EXT1TB-008",
        img: "fas fa-hdd",
        price: 69.99,
        stock: 18,
        min: 10,
        category: "Almacenamiento"
    }
]);


// Datos de clientes
const clients = ref([
    { id: 1, name: "María Cortés", email: "maria.c@ejemplo.com", phone: "555-1234", notes: "Cliente frecuente - Prefiere pago con tarjeta" },
    { id: 2, name: "Carlos Rodríguez", email: "carlos.r@ejemplo.com", phone: "555-5678", notes: "Prefiere factura" },
    { id: 3, name: "Ana García", email: "ana.g@ejemplo.com", phone: "555-9012", notes: "Descuento del 5%" },
    { id: 4, name: "Luis Fernández", email: "luis.f@ejemplo.com", phone: "555-3456", notes: "Solo pago en efectivo" }
]);

// Variables de estado
const cart = ref([]);
const discountInput = ref('');
const selectedClient = ref(clients.value[0]);
const paymentMethod = ref('');
const paymentNotes = ref('');
const searchTerm = ref('');
const clientSearch = ref('');

// Estados de los modales
const showClientModal = ref(false);
const showCreateClientModal = ref(false);
const showPaymentModal = ref(false);
const showConfirmationModal = ref(false);

// Notificación
const notification = reactive({
    show: false,
    message: '',
    success: true,
    icon: 'fas fa-check-circle'
});

// Nuevo cliente
const newClient = reactive({
    name: '',
    email: '',
    phone: '',
    notes: ''
});

// Cálculos
const subtotal = computed(() => {
    return cart.value.reduce((sum, item) => sum + (item.price * item.quantity), 0);
});

const discountAmount = computed(() => {
    if (discountInput.value.includes('%')) {
        const percent = parseFloat(discountInput.value.replace('%', ''));
        return !isNaN(percent) ? subtotal.value * (percent / 100) : 0;
    } else if (discountInput.value.includes('$')) {
        const amount = parseFloat(discountInput.value.replace('$', ''));
        return !isNaN(amount) ? Math.min(amount, subtotal.value) : 0;
    } else {
        const num = parseFloat(discountInput.value);
        return !isNaN(num) ? Math.min(num, subtotal.value) : 0;
    }
});

const taxable = computed(() => {
    return Math.max(0, subtotal.value - discountAmount.value);
});

const taxAmount = computed(() => {
    return taxable.value * 0.12; // 12% IVA
});

const totalAmount = computed(() => {
    return taxable.value + taxAmount.value;
});

const paymentMethodText = computed(() => {
    switch (paymentMethod.value) {
        case 'cash': return 'Efectivo';
        case 'card': return 'Tarjeta';
        case 'transfer': return 'Transferencia';
        case 'check': return 'Cheque';
        default: return '';
    }
});

const filteredProducts = computed(() => {
    if (!searchTerm.value) return products.value;
    const term = searchTerm.value.toLowerCase();
    return products.value.filter(p =>
        p.name.toLowerCase().includes(term) ||
        p.category.toLowerCase().includes(term)
    );
});

const filteredClients = computed(() => {
    if (!clientSearch.value) return clients.value;
    const term = clientSearch.value.toLowerCase();
    return clients.value.filter(c =>
        c.name.toLowerCase().includes(term) ||
        c.email.toLowerCase().includes(term) ||
        c.phone.includes(term)
    );
});

// Métodos
const showNotification = (message, isSuccess = true) => {
    notification.message = message;
    notification.success = isSuccess;
    notification.icon = isSuccess ? 'fas fa-check-circle' : 'fas fa-exclamation-circle';
    notification.show = true;

    setTimeout(() => {
        notification.show = false;
    }, 3000);
};

const stockStatusText = (product) => {
    if (product.stock > 10) return 'Disponible';
    if (product.stock > 0) return `Últimas ${product.stock} unidades`;
    return 'Agotado';
};

const addToCart = (product) => {
    const existingItem = cart.value.find(item => item.id === product.id);

    if (existingItem) {
        existingItem.quantity += 1;
    } else {
        cart.value.push({
            id: product.id,
            name: product.name,
            price: product.price,
            quantity: 1
        });
    }

    showNotification(`"${product.name}" agregado al carrito`);
};

const updateQuantity = (id, change) => {
    const item = cart.value.find(item => item.id === id);
    if (item) {
        item.quantity += change;

        if (item.quantity <= 0) {
            cart.value = cart.value.filter(item => item.id !== id);
        }
    }
};

const removeFromCart = (id) => {
    cart.value = cart.value.filter(item => item.id !== id);
    showNotification('Producto eliminado');
};

const clearCart = () => {
    cart.value = [];
    discountInput.value = '';
    showNotification('Venta limpiada');
};

const applyDiscount = () => {
    if (!discountInput.value) return;

    const value = discountInput.value.trim();

    if (value.includes('%')) {
        const percent = parseFloat(value.replace('%', ''));
        if (!isNaN(percent) && percent >= 0 && percent <= 100) {
            showNotification(`Descuento del ${percent}% aplicado`);
        } else {
            showNotification('Porcentaje de descuento inválido', false);
        }
    } else if (value.includes('$')) {
        const amount = parseFloat(value.replace('$', ''));
        if (!isNaN(amount) && amount >= 0) {
            showNotification(`Descuento de $${amount.toFixed(2)} aplicado`);
        } else {
            showNotification('Monto de descuento inválido', false);
        }
    } else {
        const num = parseFloat(value);
        if (!isNaN(num)) {
            if (num <= 100) {
                showNotification(`Descuento del ${num}% aplicado`);
            } else {
                showNotification(`Descuento de $${num.toFixed(2)} aplicado`);
            }
        } else {
            showNotification('Formato de descuento no válido', false);
        }
    }
};

const saveNewClient = () => {
    if (!newClient.name) {
        showNotification('Ingrese el nombre del cliente', false);
        return;
    }

    const client = {
        id: clients.value.length + 1,
        name: newClient.name,
        email: newClient.email,
        phone: newClient.phone,
        notes: newClient.notes || 'Nuevo cliente'
    };

    clients.value.push(client);
    selectedClient.value = client;
    showCreateClientModal.value = false;

    // Resetear formulario
    newClient.name = '';
    newClient.email = '';
    newClient.phone = '';
    newClient.notes = '';

    showNotification(`Cliente "${client.name}" creado`);
};

const selectClient = (client) => {
    selectedClient.value = client;
    showClientModal.value = false;
    showNotification(`Cliente seleccionado: ${client.name}`);
};

const confirmPayment = () => {
    if (!paymentMethod.value) {
        showNotification('Seleccione un método de pago', false);
        return;
    }

    showPaymentModal.value = false;
    showConfirmationModal.value = true;
};

const closeConfirmation = () => {
    showConfirmationModal.value = false;
    clearCart();
};

const cancelSale = () => {
    if (cart.value.length === 0) {
        showNotification('No hay productos en la venta');
        return;
    }

    if (confirm('¿Cancelar la venta actual? Se perderán todos los productos')) {
        clearCart();
        showNotification('Venta cancelada');
    }
};

// Animaciones al cargar
onMounted(() => {
    // Simular animaciones de entrada
    const elements = document.querySelectorAll('.animate-in');
    elements.forEach((el, index) => {
        setTimeout(() => {
            el.style.opacity = 1;
            el.style.transform = 'translateY(0)';
        }, 100 + (index * 100));
    });
});
</script>

<style lang="scss" scoped>
.app-container {
    max-width: 500px;
    margin: 0 auto;
    background: white;
    min-height: 100vh;
    box-shadow: 0 0 30px rgba(0, 0, 0, 0.05);
    position: relative;
    overflow-x: hidden;
}

/* Header Styles */
.app-header {
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    color: white;
    padding: 20px 20px 25px;
    position: relative;
    overflow: hidden;
}

.header-decoration {
    position: absolute;
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.1);
    top: -150px;

    &:nth-child(1) {
        left: -100px;
    }

    &:nth-child(2) {
        right: -100px;
        top: -100px;
        width: 200px;
        height: 200px;
    }
}

.header-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    position: relative;
    z-index: 2;
}

.logo {
    display: flex;
    align-items: center;
    font-size: 1.4rem;
    font-weight: 700;
}

.logo-icon {
    width: 40px;
    height: 40px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
}

.header-actions {
    display: flex;
    gap: 15px;
}

.header-icon {
    width: 40px;
    height: 40px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: var(--transition);

    &:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: translateY(-2px);
    }
}

.header-title {
    font-size: 1.8rem;
    font-weight: 600;
    text-align: center;
    position: relative;
    z-index: 2;
}

/* Content Styles */
.app-content {
    padding: 20px;
    padding-bottom: 100px;
}

.animate-in {
    animation: fadeInUp 0.5s ease forwards;
    opacity: 0;
    transform: translateY(20px);
}

@keyframes fadeInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Card Styles */
.client-card,
.current-sale {
    background: white;
    border-radius: var(--border-radius);
    box-shadow: var(--box-shadow);
    margin-bottom: 25px;
    overflow: hidden;
}

.client-header,
.sale-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 20px;
    border-bottom: 1px solid var(--light-gray);
}

.section-title {
    display: flex;
    align-items: center;
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--dark);

    i {
        margin-right: 10px;
        color: var(--primary);
        font-size: 1.2rem;
    }
}

.action-button {
    background: rgba(108, 99, 255, 0.1);
    color: var(--primary);
    border: none;
    padding: 8px 15px;
    border-radius: 30px;
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 500;
    cursor: pointer;
    transition: var(--transition);

    &:hover {
        background: rgba(108, 99, 255, 0.2);
    }
}

.client-info {
    display: flex;
    padding: 20px;
}

.client-avatar {
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    font-weight: 600;
    margin-right: 20px;
    flex-shrink: 0;
}

.client-details {
    flex-grow: 1;
}

.client-name {
    font-weight: 600;
    font-size: 1.2rem;
    margin-bottom: 5px;
}

.client-contact,
.client-notes {
    display: flex;
    align-items: center;
    color: var(--gray);
    margin-top: 8px;
    font-size: 0.9rem;

    i {
        margin-right: 8px;
        width: 16px;
        text-align: center;
    }
}

.client-notes {
    margin-top: 12px;
    padding: 10px;
    background: rgba(54, 215, 183, 0.1);
    border-radius: 8px;
    color: var(--secondary-dark);
    font-size: 0.85rem;
}

/* Search Styles */
.search-container {
    margin-bottom: 25px;
}

.search-bar {
    display: flex;
    gap: 10px;
}

.search-input {
    flex-grow: 1;
    display: flex;
    align-items: center;
    background: white;
    border-radius: 30px;
    padding: 0 20px;
    box-shadow: var(--box-shadow);
    border: 1px solid var(--light-gray);

    i {
        color: var(--gray);
        margin-right: 10px;
    }

    input {
        flex-grow: 1;
        height: 50px;
        border: none;
        outline: none;
        font-size: 1rem;
        background: transparent;
    }
}

.filter-button {
    width: 50px;
    height: 50px;
    background: var(--primary);
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: var(--box-shadow);
    transition: var(--transition);

    &:hover {
        background: var(--primary-dark);
        transform: translateY(-3px);
    }
}

/* Products Grid */
.products-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
    margin-bottom: 25px;
}

.product-card {
    background: white;
    border-radius: var(--border-radius);
    overflow: hidden;
    box-shadow: var(--box-shadow);
    cursor: pointer;
    transition: var(--transition);

    &:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
    }
}

.product-image {
    height: 140px;
    background: #f8f9fa;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;

    img {
        max-width: 100%;
        max-height: 100px;
        object-fit: contain;
    }
}

.product-info {
    padding: 15px;
}

.product-title {
    font-weight: 600;
    margin-bottom: 8px;
    height: 40px;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.product-price {
    font-weight: 700;
    color: var(--primary);
    font-size: 1.1rem;
    margin-bottom: 8px;
}

.product-stock {
    font-size: 0.85rem;
    display: flex;
    align-items: center;

    &.in-stock {
        color: var(--secondary-dark);
    }

    &.low-stock {
        color: #ff9800;
    }

    &.out-of-stock {
        color: var(--danger);
    }

    i {
        margin-right: 5px;
    }
}

/* Sale Items */
.current-sale {
    margin-bottom: 25px;
}

.sale-items {
    padding: 15px;
    min-height: 100px;
    max-height: 300px;
    overflow-y: auto;
}

.no-products {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100px;
    color: var(--gray);
    font-style: italic;
}

.sale-item {
    display: flex;
    justify-content: space-between;
    padding: 15px 0;
    border-bottom: 1px solid var(--light-gray);
}

.item-info {
    flex-grow: 1;
}

.item-name {
    font-weight: 500;
    margin-bottom: 5px;
}

.item-details {
    display: flex;
    gap: 15px;
    color: var(--gray);
    font-size: 0.9rem;
}

.item-actions {
    display: flex;
    align-items: center;
    gap: 15px;
}

.quantity-control {
    display: flex;
    align-items: center;
    background: #f8f9fa;
    border-radius: 30px;
    overflow: hidden;
}

.quantity-btn {
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--light-gray);
    cursor: pointer;
    transition: var(--transition);

    &:hover {
        background: var(--primary);
        color: white;
    }
}

.quantity-value {
    width: 30px;
    text-align: center;
    font-weight: 500;
}

.remove-btn {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: rgba(255, 101, 132, 0.1);
    color: var(--danger);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: var(--transition);

    &:hover {
        background: var(--danger);
        color: white;
    }
}

/* Summary */
.sale-summary {
    padding: 20px;
    background: #f8f9fa;
    border-top: 1px solid var(--light-gray);
}

.discount-input {
    display: flex;
    margin-bottom: 15px;
    gap: 10px;

    input {
        flex-grow: 1;
        height: 45px;
        border: 1px solid var(--light-gray);
        border-radius: 30px;
        padding: 0 20px;
        font-size: 1rem;
        outline: none;

        &:focus {
            border-color: var(--primary);
        }
    }

    button {
        height: 45px;
        padding: 0 20px;
        background: var(--primary);
        color: white;
        border: none;
        border-radius: 30px;
        font-weight: 500;
        cursor: pointer;
        transition: var(--transition);

        &:hover {
            background: var(--primary-dark);
        }
    }
}

.summary-row {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    font-size: 1rem;
}

.total-row {
    font-size: 1.2rem;
    font-weight: 600;
    padding-top: 15px;
    margin-top: 10px;
    border-top: 1px solid var(--light-gray);
}

/* Action Buttons */
.action-buttons {
    display: flex;
    gap: 15px;
    margin-top: 20px;
}

.btn {
    flex: 1;
    height: 60px;
    border-radius: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    font-size: 1.1rem;
    font-weight: 600;
    border: none;
    cursor: pointer;
    transition: var(--transition);
}

.btn-cancel {
    background: #f8f9fa;
    color: var(--gray);

    &:hover {
        background: #e9ecef;
    }
}

.btn-pay {
    background: var(--primary);
    color: white;
    box-shadow: 0 10px 25px rgba(108, 99, 255, 0.4);

    &:hover {
        background: var(--primary-dark);
        transform: translateY(-3px);
        box-shadow: 0 15px 30px rgba(108, 99, 255, 0.5);
    }
}

/* Floating Button */
.floating-btn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 60px;
    height: 60px;
    background: var(--primary);
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    box-shadow: 0 10px 25px rgba(108, 99, 255, 0.4);
    cursor: pointer;
    transition: var(--transition);
    z-index: 100;

    &:hover {
        background: var(--primary-dark);
        transform: translateY(-5px) rotate(90deg);
    }
}

/* Modal Styles */
.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.6);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    opacity: 0;
    visibility: hidden;
    transition: var(--transition);

    &.active {
        opacity: 1;
        visibility: visible;
    }
}

.modal-content {
    background: white;
    width: 90%;
    max-width: 450px;
    border-radius: var(--border-radius);
    overflow: hidden;
    transform: translateY(20px);
    transition: var(--transition);
}

.modal.active .modal-content {
    transform: translateY(0);
}

.modal-header {
    padding: 20px;
    font-size: 1.4rem;
    font-weight: 600;
    background: #f8f9fa;
    border-bottom: 1px solid var(--light-gray);
    text-align: center;
}

.modal-body {
    padding: 25px;
    max-height: 70vh;
    overflow-y: auto;
}

.help-text {
    text-align: center;
    color: var(--gray);
    margin-bottom: 20px;
}

.form-group {
    margin-bottom: 20px;

    label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    input {
        width: 100%;
        height: 50px;
        border: 1px solid var(--light-gray);
        border-radius: 12px;
        padding: 0 15px;
        font-size: 1rem;
        outline: none;

        &:focus {
            border-color: var(--primary);
        }
    }
}

.client-list {
    margin-top: 20px;
}

.payment-methods {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
    margin-top: 15px;
}

.payment-method {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 25px 10px;
    background: #f8f9fa;
    border-radius: var(--border-radius);
    cursor: pointer;
    transition: var(--transition);
    border: 2px solid transparent;

    &.active {
        border-color: var(--primary);
        background: rgba(108, 99, 255, 0.05);
    }

    i {
        font-size: 2.5rem;
        color: var(--primary);
        margin-bottom: 15px;
    }

    span {
        font-weight: 500;
    }
}

.modal-footer {
    display: flex;
    padding: 20px;
    background: #f8f9fa;
    border-top: 1px solid var(--light-gray);
}

.modal-btn {
    flex: 1;
    height: 50px;
    border-radius: 12px;
    font-weight: 500;
    font-size: 1rem;
    cursor: pointer;
    transition: var(--transition);
    border: none;
}

.modal-btn-cancel {
    background: #e9ecef;
    color: var(--gray);
    margin-right: 10px;

    &:hover {
        background: #dee2e6;
    }
}

.modal-btn-confirm {
    background: var(--primary);
    color: white;
    margin-left: 10px;

    &:hover {
        background: var(--primary-dark);
    }
}

/* Notification */
.notification {
    position: fixed;
    top: 30px;
    left: 50%;
    transform: translateX(-50%);
    background: var(--secondary);
    color: white;
    padding: 18px 35px;
    border-radius: 50px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    z-index: 1000;
    animation: fadeInOut 3s forwards;
    font-size: 1.2rem;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 15px;

    &.success {
        background: var(--secondary);
    }

    &:not(.success) {
        background: var(--danger);
    }
}

@keyframes fadeInOut {
    0% {
        opacity: 0;
        top: 10px;
    }

    10% {
        opacity: 1;
        top: 30px;
    }

    90% {
        opacity: 1;
        top: 30px;
    }

    100% {
        opacity: 0;
        top: 10px;
    }
}

/* Responsive */
@media (max-width: 480px) {
    .products-grid {
        grid-template-columns: 1fr;
    }

    .action-buttons {
        flex-direction: column;
    }

    .modal-body {
        padding: 15px;
    }
}
</style>