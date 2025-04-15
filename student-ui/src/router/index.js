import { createRouter, createWebHistory } from 'vue-router'
import Layout from '@/layout/index.vue'

const routes = [
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/login/index.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'dashboard',
        component: () => import('@/views/dashboard/index.vue'),
        meta: { title: '工作台' }
      },
      {
        path: 'student',
        name: 'student',
        redirect: '/student/list',
        meta: { title: '学生管理' },
        children: [
          {
            path: 'list',
            name: 'student-list',
            component: () => import('@/views/student/index.vue'),
            meta: { title: '学生列表' }
          },
          {
            path: 'grade',
            name: 'student-grade',
            component: () => import('@/views/student/grade.vue'),
            meta: { title: '成绩管理' }
          }
        ]
      },
      {
        path: 'system',
        name: 'system',
        meta: { title: '系统管理' },
        children: [
          {
            path: 'user',
            name: 'user',
            component: () => import('@/views/system/user.vue'),
            meta: { title: '用户管理' }
          },
          {
            path: 'role',
            name: 'role',
            component: () => import('@/views/system/role.vue'),
            meta: { title: '角色管理' }
          }
        ]
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 设置标题
  document.title = to.meta.title ? `${to.meta.title} - 学生管理系统` : '学生管理系统'
  
  // 判断是否需要登录
  const token = localStorage.getItem('token')
  if (to.path !== '/login' && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router 