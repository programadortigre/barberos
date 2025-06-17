
import type { DefineComponent, SlotsType } from 'vue'
type IslandComponent<T extends DefineComponent> = T & DefineComponent<{}, {refresh: () => Promise<void>}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, SlotsType<{ fallback: { error: unknown } }>>
type HydrationStrategies = {
  hydrateOnVisible?: IntersectionObserverInit | true
  hydrateOnIdle?: number | true
  hydrateOnInteraction?: keyof HTMLElementEventMap | Array<keyof HTMLElementEventMap> | true
  hydrateOnMediaQuery?: string
  hydrateAfter?: number
  hydrateWhen?: boolean
  hydrateNever?: true
}
type LazyComponent<T> = (T & DefineComponent<HydrationStrategies, {}, {}, {}, {}, {}, {}, { hydrated: () => void }>)
interface _GlobalComponents {
      'AppContainer': typeof import("../components/AppContainer.vue")['default']
    'AuthTabs': typeof import("../components/AuthTabs.vue")['default']
    'BaseTable': typeof import("../components/BaseTable.vue")['default']
    'BusinessWelcome': typeof import("../components/BusinessWelcome.vue")['default']
    'CartDrawer': typeof import("../components/CartDrawer.vue")['default']
    'CartItem': typeof import("../components/CartItem.vue")['default']
    'CheckoutForm': typeof import("../components/CheckoutForm.vue")['default']
    'CrudForm': typeof import("../components/CrudForm.vue")['default']
    'CrudTable': typeof import("../components/CrudTable.vue")['default']
    'CrudTable1': typeof import("../components/CrudTable1.vue")['default']
    'CrudTableToolbar': typeof import("../components/CrudTableToolbar.vue")['default']
    'DynamicForm': typeof import("../components/DynamicForm.vue")['default']
    'FormInput': typeof import("../components/FormInput.vue")['default']
    'FormularioUniversal': typeof import("../components/FormularioUniversal.vue")['default']
    'ListaUniversal': typeof import("../components/ListaUniversal.vue")['default']
    'LoginForm': typeof import("../components/LoginForm.vue")['default']
    'ModuleHeader': typeof import("../components/ModuleHeader.vue")['default']
    'NegocioSwiper': typeof import("../components/NegocioSwiper.vue")['default']
    'PersonaForm': typeof import("../components/PersonaForm.vue")['default']
    'PluginCard': typeof import("../components/PluginCard.vue")['default']
    'ProductGrid': typeof import("../components/ProductGrid.vue")['default']
    'RolesPermissions': typeof import("../components/RolesPermissions.vue")['default']
    'Sidebar': typeof import("../components/Sidebar.vue")['default']
    'ThemeToggle': typeof import("../components/ThemeToggle.vue")['default']
    'Topbar': typeof import("../components/Topbar.vue")['default']
    'UserFormModal': typeof import("../components/UserFormModal.vue")['default']
    'UsersList': typeof import("../components/UsersList.vue")['default']
    'ProductosProductCard': typeof import("../components/productos/ProductCard.vue")['default']
    'ProductosProductDetail': typeof import("../components/productos/ProductDetail.vue")['default']
    'ProductosProductGrid': typeof import("../components/productos/ProductGrid.vue")['default']
    'QuoteTemplate': typeof import("../components/quote/QuoteTemplate.vue")['default']
    'UiCard': typeof import("../components/ui/Card.vue")['default']
    'UiCrudTable': typeof import("../components/ui/CrudTable.vue")['default']
    'UiDataTable': typeof import("../components/ui/DataTable.vue")['default']
    'NuxtWelcome': typeof import("../node_modules/nuxt/dist/app/components/welcome.vue")['default']
    'NuxtLayout': typeof import("../node_modules/nuxt/dist/app/components/nuxt-layout")['default']
    'NuxtErrorBoundary': typeof import("../node_modules/nuxt/dist/app/components/nuxt-error-boundary.vue")['default']
    'ClientOnly': typeof import("../node_modules/nuxt/dist/app/components/client-only")['default']
    'DevOnly': typeof import("../node_modules/nuxt/dist/app/components/dev-only")['default']
    'ServerPlaceholder': typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']
    'NuxtLink': typeof import("../node_modules/nuxt/dist/app/components/nuxt-link")['default']
    'NuxtLoadingIndicator': typeof import("../node_modules/nuxt/dist/app/components/nuxt-loading-indicator")['default']
    'NuxtTime': typeof import("../node_modules/nuxt/dist/app/components/nuxt-time.vue")['default']
    'NuxtRouteAnnouncer': typeof import("../node_modules/nuxt/dist/app/components/nuxt-route-announcer")['default']
    'NuxtImg': typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtImg']
    'NuxtPicture': typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtPicture']
    'ColorScheme': typeof import("../node_modules/@nuxtjs/color-mode/dist/runtime/component.vue3.vue")['default']
    'NuxtPage': typeof import("../node_modules/nuxt/dist/pages/runtime/page")['default']
    'NoScript': typeof import("../node_modules/nuxt/dist/head/runtime/components")['NoScript']
    'Link': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Link']
    'Base': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Base']
    'Title': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Title']
    'Meta': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Meta']
    'Style': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Style']
    'Head': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Head']
    'Html': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Html']
    'Body': typeof import("../node_modules/nuxt/dist/head/runtime/components")['Body']
    'NuxtIsland': typeof import("../node_modules/nuxt/dist/app/components/nuxt-island")['default']
    'NuxtRouteAnnouncer': IslandComponent<typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']>
      'LazyAppContainer': LazyComponent<typeof import("../components/AppContainer.vue")['default']>
    'LazyAuthTabs': LazyComponent<typeof import("../components/AuthTabs.vue")['default']>
    'LazyBaseTable': LazyComponent<typeof import("../components/BaseTable.vue")['default']>
    'LazyBusinessWelcome': LazyComponent<typeof import("../components/BusinessWelcome.vue")['default']>
    'LazyCartDrawer': LazyComponent<typeof import("../components/CartDrawer.vue")['default']>
    'LazyCartItem': LazyComponent<typeof import("../components/CartItem.vue")['default']>
    'LazyCheckoutForm': LazyComponent<typeof import("../components/CheckoutForm.vue")['default']>
    'LazyCrudForm': LazyComponent<typeof import("../components/CrudForm.vue")['default']>
    'LazyCrudTable': LazyComponent<typeof import("../components/CrudTable.vue")['default']>
    'LazyCrudTable1': LazyComponent<typeof import("../components/CrudTable1.vue")['default']>
    'LazyCrudTableToolbar': LazyComponent<typeof import("../components/CrudTableToolbar.vue")['default']>
    'LazyDynamicForm': LazyComponent<typeof import("../components/DynamicForm.vue")['default']>
    'LazyFormInput': LazyComponent<typeof import("../components/FormInput.vue")['default']>
    'LazyFormularioUniversal': LazyComponent<typeof import("../components/FormularioUniversal.vue")['default']>
    'LazyListaUniversal': LazyComponent<typeof import("../components/ListaUniversal.vue")['default']>
    'LazyLoginForm': LazyComponent<typeof import("../components/LoginForm.vue")['default']>
    'LazyModuleHeader': LazyComponent<typeof import("../components/ModuleHeader.vue")['default']>
    'LazyNegocioSwiper': LazyComponent<typeof import("../components/NegocioSwiper.vue")['default']>
    'LazyPersonaForm': LazyComponent<typeof import("../components/PersonaForm.vue")['default']>
    'LazyPluginCard': LazyComponent<typeof import("../components/PluginCard.vue")['default']>
    'LazyProductGrid': LazyComponent<typeof import("../components/ProductGrid.vue")['default']>
    'LazyRolesPermissions': LazyComponent<typeof import("../components/RolesPermissions.vue")['default']>
    'LazySidebar': LazyComponent<typeof import("../components/Sidebar.vue")['default']>
    'LazyThemeToggle': LazyComponent<typeof import("../components/ThemeToggle.vue")['default']>
    'LazyTopbar': LazyComponent<typeof import("../components/Topbar.vue")['default']>
    'LazyUserFormModal': LazyComponent<typeof import("../components/UserFormModal.vue")['default']>
    'LazyUsersList': LazyComponent<typeof import("../components/UsersList.vue")['default']>
    'LazyProductosProductCard': LazyComponent<typeof import("../components/productos/ProductCard.vue")['default']>
    'LazyProductosProductDetail': LazyComponent<typeof import("../components/productos/ProductDetail.vue")['default']>
    'LazyProductosProductGrid': LazyComponent<typeof import("../components/productos/ProductGrid.vue")['default']>
    'LazyQuoteTemplate': LazyComponent<typeof import("../components/quote/QuoteTemplate.vue")['default']>
    'LazyUiCard': LazyComponent<typeof import("../components/ui/Card.vue")['default']>
    'LazyUiCrudTable': LazyComponent<typeof import("../components/ui/CrudTable.vue")['default']>
    'LazyUiDataTable': LazyComponent<typeof import("../components/ui/DataTable.vue")['default']>
    'LazyNuxtWelcome': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/welcome.vue")['default']>
    'LazyNuxtLayout': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-layout")['default']>
    'LazyNuxtErrorBoundary': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-error-boundary.vue")['default']>
    'LazyClientOnly': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/client-only")['default']>
    'LazyDevOnly': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/dev-only")['default']>
    'LazyServerPlaceholder': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']>
    'LazyNuxtLink': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-link")['default']>
    'LazyNuxtLoadingIndicator': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-loading-indicator")['default']>
    'LazyNuxtTime': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-time.vue")['default']>
    'LazyNuxtRouteAnnouncer': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-route-announcer")['default']>
    'LazyNuxtImg': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtImg']>
    'LazyNuxtPicture': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtPicture']>
    'LazyColorScheme': LazyComponent<typeof import("../node_modules/@nuxtjs/color-mode/dist/runtime/component.vue3.vue")['default']>
    'LazyNuxtPage': LazyComponent<typeof import("../node_modules/nuxt/dist/pages/runtime/page")['default']>
    'LazyNoScript': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['NoScript']>
    'LazyLink': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Link']>
    'LazyBase': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Base']>
    'LazyTitle': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Title']>
    'LazyMeta': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Meta']>
    'LazyStyle': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Style']>
    'LazyHead': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Head']>
    'LazyHtml': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Html']>
    'LazyBody': LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Body']>
    'LazyNuxtIsland': LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-island")['default']>
    'LazyNuxtRouteAnnouncer': LazyComponent<IslandComponent<typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']>>
}

declare module 'vue' {
  export interface GlobalComponents extends _GlobalComponents { }
}

export const AppContainer: typeof import("../components/AppContainer.vue")['default']
export const AuthTabs: typeof import("../components/AuthTabs.vue")['default']
export const BaseTable: typeof import("../components/BaseTable.vue")['default']
export const BusinessWelcome: typeof import("../components/BusinessWelcome.vue")['default']
export const CartDrawer: typeof import("../components/CartDrawer.vue")['default']
export const CartItem: typeof import("../components/CartItem.vue")['default']
export const CheckoutForm: typeof import("../components/CheckoutForm.vue")['default']
export const CrudForm: typeof import("../components/CrudForm.vue")['default']
export const CrudTable: typeof import("../components/CrudTable.vue")['default']
export const CrudTable1: typeof import("../components/CrudTable1.vue")['default']
export const CrudTableToolbar: typeof import("../components/CrudTableToolbar.vue")['default']
export const DynamicForm: typeof import("../components/DynamicForm.vue")['default']
export const FormInput: typeof import("../components/FormInput.vue")['default']
export const FormularioUniversal: typeof import("../components/FormularioUniversal.vue")['default']
export const ListaUniversal: typeof import("../components/ListaUniversal.vue")['default']
export const LoginForm: typeof import("../components/LoginForm.vue")['default']
export const ModuleHeader: typeof import("../components/ModuleHeader.vue")['default']
export const NegocioSwiper: typeof import("../components/NegocioSwiper.vue")['default']
export const PersonaForm: typeof import("../components/PersonaForm.vue")['default']
export const PluginCard: typeof import("../components/PluginCard.vue")['default']
export const ProductGrid: typeof import("../components/ProductGrid.vue")['default']
export const RolesPermissions: typeof import("../components/RolesPermissions.vue")['default']
export const Sidebar: typeof import("../components/Sidebar.vue")['default']
export const ThemeToggle: typeof import("../components/ThemeToggle.vue")['default']
export const Topbar: typeof import("../components/Topbar.vue")['default']
export const UserFormModal: typeof import("../components/UserFormModal.vue")['default']
export const UsersList: typeof import("../components/UsersList.vue")['default']
export const ProductosProductCard: typeof import("../components/productos/ProductCard.vue")['default']
export const ProductosProductDetail: typeof import("../components/productos/ProductDetail.vue")['default']
export const ProductosProductGrid: typeof import("../components/productos/ProductGrid.vue")['default']
export const QuoteTemplate: typeof import("../components/quote/QuoteTemplate.vue")['default']
export const UiCard: typeof import("../components/ui/Card.vue")['default']
export const UiCrudTable: typeof import("../components/ui/CrudTable.vue")['default']
export const UiDataTable: typeof import("../components/ui/DataTable.vue")['default']
export const NuxtWelcome: typeof import("../node_modules/nuxt/dist/app/components/welcome.vue")['default']
export const NuxtLayout: typeof import("../node_modules/nuxt/dist/app/components/nuxt-layout")['default']
export const NuxtErrorBoundary: typeof import("../node_modules/nuxt/dist/app/components/nuxt-error-boundary.vue")['default']
export const ClientOnly: typeof import("../node_modules/nuxt/dist/app/components/client-only")['default']
export const DevOnly: typeof import("../node_modules/nuxt/dist/app/components/dev-only")['default']
export const ServerPlaceholder: typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']
export const NuxtLink: typeof import("../node_modules/nuxt/dist/app/components/nuxt-link")['default']
export const NuxtLoadingIndicator: typeof import("../node_modules/nuxt/dist/app/components/nuxt-loading-indicator")['default']
export const NuxtTime: typeof import("../node_modules/nuxt/dist/app/components/nuxt-time.vue")['default']
export const NuxtRouteAnnouncer: typeof import("../node_modules/nuxt/dist/app/components/nuxt-route-announcer")['default']
export const NuxtImg: typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtImg']
export const NuxtPicture: typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtPicture']
export const ColorScheme: typeof import("../node_modules/@nuxtjs/color-mode/dist/runtime/component.vue3.vue")['default']
export const NuxtPage: typeof import("../node_modules/nuxt/dist/pages/runtime/page")['default']
export const NoScript: typeof import("../node_modules/nuxt/dist/head/runtime/components")['NoScript']
export const Link: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Link']
export const Base: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Base']
export const Title: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Title']
export const Meta: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Meta']
export const Style: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Style']
export const Head: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Head']
export const Html: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Html']
export const Body: typeof import("../node_modules/nuxt/dist/head/runtime/components")['Body']
export const NuxtIsland: typeof import("../node_modules/nuxt/dist/app/components/nuxt-island")['default']
export const NuxtRouteAnnouncer: IslandComponent<typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']>
export const LazyAppContainer: LazyComponent<typeof import("../components/AppContainer.vue")['default']>
export const LazyAuthTabs: LazyComponent<typeof import("../components/AuthTabs.vue")['default']>
export const LazyBaseTable: LazyComponent<typeof import("../components/BaseTable.vue")['default']>
export const LazyBusinessWelcome: LazyComponent<typeof import("../components/BusinessWelcome.vue")['default']>
export const LazyCartDrawer: LazyComponent<typeof import("../components/CartDrawer.vue")['default']>
export const LazyCartItem: LazyComponent<typeof import("../components/CartItem.vue")['default']>
export const LazyCheckoutForm: LazyComponent<typeof import("../components/CheckoutForm.vue")['default']>
export const LazyCrudForm: LazyComponent<typeof import("../components/CrudForm.vue")['default']>
export const LazyCrudTable: LazyComponent<typeof import("../components/CrudTable.vue")['default']>
export const LazyCrudTable1: LazyComponent<typeof import("../components/CrudTable1.vue")['default']>
export const LazyCrudTableToolbar: LazyComponent<typeof import("../components/CrudTableToolbar.vue")['default']>
export const LazyDynamicForm: LazyComponent<typeof import("../components/DynamicForm.vue")['default']>
export const LazyFormInput: LazyComponent<typeof import("../components/FormInput.vue")['default']>
export const LazyFormularioUniversal: LazyComponent<typeof import("../components/FormularioUniversal.vue")['default']>
export const LazyListaUniversal: LazyComponent<typeof import("../components/ListaUniversal.vue")['default']>
export const LazyLoginForm: LazyComponent<typeof import("../components/LoginForm.vue")['default']>
export const LazyModuleHeader: LazyComponent<typeof import("../components/ModuleHeader.vue")['default']>
export const LazyNegocioSwiper: LazyComponent<typeof import("../components/NegocioSwiper.vue")['default']>
export const LazyPersonaForm: LazyComponent<typeof import("../components/PersonaForm.vue")['default']>
export const LazyPluginCard: LazyComponent<typeof import("../components/PluginCard.vue")['default']>
export const LazyProductGrid: LazyComponent<typeof import("../components/ProductGrid.vue")['default']>
export const LazyRolesPermissions: LazyComponent<typeof import("../components/RolesPermissions.vue")['default']>
export const LazySidebar: LazyComponent<typeof import("../components/Sidebar.vue")['default']>
export const LazyThemeToggle: LazyComponent<typeof import("../components/ThemeToggle.vue")['default']>
export const LazyTopbar: LazyComponent<typeof import("../components/Topbar.vue")['default']>
export const LazyUserFormModal: LazyComponent<typeof import("../components/UserFormModal.vue")['default']>
export const LazyUsersList: LazyComponent<typeof import("../components/UsersList.vue")['default']>
export const LazyProductosProductCard: LazyComponent<typeof import("../components/productos/ProductCard.vue")['default']>
export const LazyProductosProductDetail: LazyComponent<typeof import("../components/productos/ProductDetail.vue")['default']>
export const LazyProductosProductGrid: LazyComponent<typeof import("../components/productos/ProductGrid.vue")['default']>
export const LazyQuoteTemplate: LazyComponent<typeof import("../components/quote/QuoteTemplate.vue")['default']>
export const LazyUiCard: LazyComponent<typeof import("../components/ui/Card.vue")['default']>
export const LazyUiCrudTable: LazyComponent<typeof import("../components/ui/CrudTable.vue")['default']>
export const LazyUiDataTable: LazyComponent<typeof import("../components/ui/DataTable.vue")['default']>
export const LazyNuxtWelcome: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/welcome.vue")['default']>
export const LazyNuxtLayout: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-layout")['default']>
export const LazyNuxtErrorBoundary: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-error-boundary.vue")['default']>
export const LazyClientOnly: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/client-only")['default']>
export const LazyDevOnly: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/dev-only")['default']>
export const LazyServerPlaceholder: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']>
export const LazyNuxtLink: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-link")['default']>
export const LazyNuxtLoadingIndicator: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-loading-indicator")['default']>
export const LazyNuxtTime: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-time.vue")['default']>
export const LazyNuxtRouteAnnouncer: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-route-announcer")['default']>
export const LazyNuxtImg: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtImg']>
export const LazyNuxtPicture: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-stubs")['NuxtPicture']>
export const LazyColorScheme: LazyComponent<typeof import("../node_modules/@nuxtjs/color-mode/dist/runtime/component.vue3.vue")['default']>
export const LazyNuxtPage: LazyComponent<typeof import("../node_modules/nuxt/dist/pages/runtime/page")['default']>
export const LazyNoScript: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['NoScript']>
export const LazyLink: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Link']>
export const LazyBase: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Base']>
export const LazyTitle: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Title']>
export const LazyMeta: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Meta']>
export const LazyStyle: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Style']>
export const LazyHead: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Head']>
export const LazyHtml: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Html']>
export const LazyBody: LazyComponent<typeof import("../node_modules/nuxt/dist/head/runtime/components")['Body']>
export const LazyNuxtIsland: LazyComponent<typeof import("../node_modules/nuxt/dist/app/components/nuxt-island")['default']>
export const LazyNuxtRouteAnnouncer: LazyComponent<IslandComponent<typeof import("../node_modules/nuxt/dist/app/components/server-placeholder")['default']>>

export const componentNames: string[]
