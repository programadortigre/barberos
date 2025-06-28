<script setup>
definePageMeta({ layout: 'aplicacion' })
</script>
<template>
    
    <div class="container">
        <div class="content">
            <!-- Bienvenida Mejorada -->

            <!-- Accesos Rápidos Mejorados -->
            <h2 class="section-title">
                <i class="fas fa-bolt"></i> Operaciones
            </h2>
            <div class="quick-access">
                <div class="quick-item">
                    <i class="fas fa-cash-register"></i>
                    <p>Nueva Venta</p>
                </div>
                <div class="quick-item">
                    <i class="fas fa-user-plus"></i>
                    <p>Agregar Cliente</p>
                </div>
                <div class="quick-item">
                    <i class="fas fa-calendar-plus"></i>
                    <p>Nueva Cita</p>
                </div>
                <div class="quick-item">
                    <i class="fas fa-box-open"></i>
                    <p>Agregar Producto</p>
                </div>
                <div class="quick-item">
                    <i class="fas fa-receipt"></i>
                    <p>Registrar Gasto</p>
                </div>
                <div class="quick-item">
                    <i class="fas fa-chart-pie"></i>
                    <p>Ver Reportes</p>
                </div>
            </div>


            <!-- Actividad Reciente Mejorada -->
            <h2 class="section-title">
                <i class="fas fa-history"></i> Actividad Reciente
            </h2>
            <div class="recent-activity">
                <ul class="activity-list">
                    <li class="activity-item activity-sales">
                        <div class="activity-icon">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Nueva venta registrada <i class="fas fa-check-circle"></i></div>
                            <div class="activity-description">Venta #00128 por $125.00 a María Rodríguez</div>
                            <div class="activity-time"><i class="fas fa-clock"></i> Hace 15 minutos</div>
                        </div>
                    </li>

                    <li class="activity-item activity-appointment">
                        <div class="activity-icon">
                            <i class="fas fa-calendar-day"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Cita confirmada <i class="fas fa-check-circle"></i></div>
                            <div class="activity-description">Carlos Sánchez confirmó cita para mañana a las 10:00 AM
                            </div>
                            <div class="activity-time"><i class="fas fa-clock"></i> Hace 1 hora</div>
                        </div>
                    </li>

                    <li class="activity-item activity-payment">
                        <div class="activity-icon">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Pago recibido <i class="fas fa-check-circle"></i></div>
                            <div class="activity-description">Pedro Gómez pagó $350.00 por la venta #00125</div>
                            <div class="activity-time"><i class="fas fa-clock"></i> Hace 3 horas</div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>

</template> 