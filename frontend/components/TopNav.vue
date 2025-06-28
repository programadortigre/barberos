<style scoped lang="scss">
header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background: linear-gradient(to right, var(--primary), var(--secondary));
    padding: 12px 16px;
    z-index: 100;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: var(--header-height);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    color: white;

    .header-left {
        display: flex;
        align-items: center;
        gap: 12px;

        .user-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 18px;
            font-weight: 700;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            border: 2px solid rgba(255, 255, 255, 0.5);
        }

        .user-info {
            display: flex;
            flex-direction: column;

            .user-greeting {
                font-size: 13px;
                color: rgba(255, 255, 255, 0.85);
                font-weight: 400;
            }

            .user-name {
                font-size: 16px;
                font-weight: 600;
                color: white;
            }
        }
    }

    .header-actions {
        display: flex;
        gap: 18px;

        .header-action {
            position: relative;
            color: rgba(255, 255, 255, 0.9);
            font-size: 18px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 12px;
            transition: var(--transition);
            background: rgba(255, 255, 255, 0.15);

            .badge {
                position: absolute;
                top: -3px;
                right: -3px;
                background: var(--danger);
                color: white;
                min-width: 18px;
                height: 18px;
                border-radius: 50%;
                font-size: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 0 4px;
                font-weight: 600;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            }
        }

        .header-action:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: scale(1.1);
        }
    }
}
</style>
<template>
    <!-- Header Mejorado con Degradado -->
    <header>
        <div class="header-left">
            <div class="user-avatar">J</div>
            <div class="user-info">
                <div class="user-greeting">Buen día</div>
                <div class="user-name">{{ user?.persona?.nombres || user?.username }}</div>
            </div>
        </div>
        <div class="header-actions">
            <a href="#" class="header-action">
                <i class="fas fa-bell"></i>
                <span class="badge">3</span>
            </a>
            <a href="#" class="header-action">
                <i class="fas fa-cog"></i>
            </a>
            <ThemeToggle />
            <button @click="handleLogout" class="logout-btn">
                <span class="icon">🚪</span>
                <span v-if="!collapsed">Cerrar sesión</span>
            </button>

        </div>
    </header>
</template>
<script setup>
import { useRouter } from 'vue-router'
import { useAuthStore } from '~/stores/auth'
import { computed, onMounted } from 'vue'

const router = useRouter()
const auth = useAuthStore()

function handleLogout() {
    auth.logout()
    router.push('/login')
}
// Asegúrate de cargar el usuario si no está aún
onMounted(async () => {
    if (!auth.user) {
        await auth.init()
    }
})

const user = computed(() => auth.user)
</script>