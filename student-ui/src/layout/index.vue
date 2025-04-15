<template>
  <div class="layout">
    <!-- 头部 -->
    <div class="layout-header">
      <div class="header-left">
        <a-button class="menu-fold-btn" type="text" @click="toggleCollapse">
          <icon-menu-fold v-if="isCollapse" />
          <icon-menu-unfold v-else />
        </a-button>
        <div class="breadcrumb">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>{{ currentRoute }}</a-breadcrumb-item>
          </a-breadcrumb>
        </div>
      </div>
      <div class="header-right">
        <a-space>
          <a-button type="text" @click="toggleTheme">
            <template #icon>
              <icon-moon-fill v-if="isDark" />
              <icon-sun-fill v-else />
            </template>
          </a-button>
          <a-button type="text" @click="toggleFullScreen">
            <template #icon>
              <icon-fullscreen-exit v-if="isFullscreen" />
              <icon-fullscreen v-else />
            </template>
          </a-button>
          <a-dropdown>
            <a-avatar>
              <img alt="avatar" src="https://p1-arco.byteimg.com/tos-cn-i-uwbnlip3yd/3ee5f13fb09879ecb5185e440cef6eb9.png~tplv-uwbnlip3yd-webp.webp" />
            </a-avatar>
            <template #content>
              <a-doption>
                <template #icon><icon-user /></template>
                个人中心
              </a-doption>
              <a-doption>
                <template #icon><icon-settings /></template>
                系统设置
              </a-doption>
              <a-doption @click="handleLogout">
                <template #icon><icon-export /></template>
                退出登录
              </a-doption>
            </template>
          </a-dropdown>
        </a-space>
      </div>
    </div>
    
    <!-- 侧边栏 -->
    <div class="layout-sider" :class="{ collapsed: isCollapse }">
      <div class="logo">
        <img src="../assets/logo.svg" alt="logo" />
        <h1 v-show="!isCollapse">学生管理系统</h1>
      </div>
      <a-menu
        :style="{ width: isCollapse ? '60px' : '200px' }"
        :collapsed="isCollapse"
        show-collapse-button
        @collapse="handleCollapse"
        :selected-keys="[currentRoute]"
      >
        <a-menu-item key="dashboard">
          <template #icon><icon-dashboard /></template>
          工作台
        </a-menu-item>
        <a-sub-menu key="student">
          <template #icon><icon-user-group /></template>
          <template #title>学生管理</template>
          <a-menu-item key="student-list">
            <router-link to="/student/list">学生列表</router-link>
          </a-menu-item>
          <a-menu-item key="student-grade">
            <router-link to="/student/grade">成绩管理</router-link>
          </a-menu-item>
        </a-sub-menu>
        <a-sub-menu key="system">
          <template #icon><icon-settings /></template>
          <template #title>系统管理</template>
          <a-menu-item key="user">用户管理</a-menu-item>
          <a-menu-item key="role">角色管理</a-menu-item>
        </a-sub-menu>
      </a-menu>
    </div>
    
    <!-- 主内容区 -->
    <div class="layout-content">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </div>
    
    <!-- 底部 -->
    <div class="layout-footer">
      <p>Copyright © 2024 学生管理系统 All Rights Reserved.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Message } from '@arco-design/web-vue'
import { useFullscreen } from '@vueuse/core'

const router = useRouter()
const route = useRoute()
const isCollapse = ref(false)
const isDark = ref(false)
const { isFullscreen, toggle: toggleFullScreen } = useFullscreen()

const currentRoute = computed(() => route.name)

const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}

const handleCollapse = (val) => {
  isCollapse.value = val
}

const toggleTheme = () => {
  isDark.value = !isDark.value
  // TODO: 实现主题切换逻辑
}

const handleLogout = () => {
  Message.success('退出成功')
  router.push('/login')
}
</script>

<style scoped>
.layout {
  height: 100vh;
  width: 100vw;
  display: grid;
  grid-template-areas:
    "header header"
    "sider main"
    "footer footer";
  grid-template-rows: 60px 1fr 40px;
  grid-template-columns: auto 1fr;
}

.layout-header {
  grid-area: header;
  background: #fff;
  border-bottom: 1px solid var(--color-border);
  padding: 0 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.layout-sider {
  grid-area: sider;
  background: #fff;
  border-right: 1px solid var(--color-border);
  transition: width 0.2s;
  width: 200px;
}

.layout-sider.collapsed {
  width: 60px;
}

.logo {
  height: 60px;
  padding: 16px;
  display: flex;
  align-items: center;
  gap: 8px;
  overflow: hidden;
}

.logo img {
  width: 32px;
  height: 32px;
}

.logo h1 {
  margin: 0;
  font-size: 18px;
  font-weight: 500;
  white-space: nowrap;
}

.layout-content {
  grid-area: main;
  padding: 16px;
  background: #f5f7f9;
  overflow: auto;
}

.layout-footer {
  grid-area: footer;
  background: #fff;
  border-top: 1px solid var(--color-border);
  padding: 8px 16px;
  text-align: center;
  color: var(--color-text-3);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style> 