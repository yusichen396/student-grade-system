import { createApp } from 'vue'
import ArcoVue from '@arco-design/web-vue'
import '@arco-design/web-vue/dist/arco.css'
import { createPinia } from 'pinia'
import router from './router'
import './styles/index.css'
import App from './App.vue'

const app = createApp(App)
const pinia = createPinia()

app.use(ArcoVue)
app.use(router)
app.use(pinia)
app.mount('#app')
