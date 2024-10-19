import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/createCert',
    name: 'createCertPg',
    component: () => import('@/views/createCert.vue')
  },
  // Health facility.
  {
    path: '/productLaunch',
    name: 'productLaunchPg',
    component: () => import('@/views/productLaunch.vue')
  }
]
const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
