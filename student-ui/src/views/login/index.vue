<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-left">
        <div class="login-animation">
          <!-- SVG动画背景 -->
          <svg viewBox="0 0 500 500" class="login-svg">
            <path d="M50,250c0-110.5,89.5-200,200-200s200,89.5,200,200s-89.5,200-200,200S50,360.5,50,250" fill="none" stroke="#4080ff" stroke-width="2">
              <animate attributeName="d" dur="10s" repeatCount="indefinite" values="M50,250c0-110.5,89.5-200,200-200s200,89.5,200,200s-89.5,200-200,200S50,360.5,50,250;
                M50,250c0-110.5,89.5-200,200-200s200,89.5,200,200s-89.5,200-200,200S50,360.5,50,250"/>
            </path>
          </svg>
        </div>
      </div>
      <div class="login-right">
        <div class="login-form">
          <h2 class="login-title">学生管理系统</h2>
          <a-form :model="loginForm" @submit="handleSubmit">
            <a-form-item field="username" :rules="[{ required: true, message: '请输入用户名' }]">
              <a-input v-model="loginForm.username" placeholder="用户名">
                <template #prefix>
                  <icon-user />
                </template>
              </a-input>
            </a-form-item>
            <a-form-item field="password" :rules="[{ required: true, message: '请输入密码' }]">
              <a-input-password v-model="loginForm.password" placeholder="密码">
                <template #prefix>
                  <icon-lock />
                </template>
              </a-input-password>
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit" long :loading="loading">
                登录
              </a-button>
            </a-form-item>
          </a-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { Message } from '@arco-design/web-vue'

const router = useRouter()
const loading = ref(false)
const loginForm = reactive({
  username: '',
  password: ''
})

const handleSubmit = async () => {
  loading.value = true
  try {
    // TODO: 实现登录逻辑
    await new Promise(resolve => setTimeout(resolve, 1000))
    Message.success('登录成功')
    router.push('/')
  } catch (error) {
    Message.error('登录失败')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  height: 100vh;
  width: 100vw;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7ff 0%, #c3cfe2 100%);
}

.login-box {
  width: 80%;
  max-width: 1000px;
  height: 600px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  display: flex;
  overflow: hidden;
}

.login-left {
  flex: 1;
  background: #f5f6f9;
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-animation {
  width: 100%;
  height: 100%;
  position: relative;
}

.login-svg {
  width: 100%;
  height: 100%;
}

.login-right {
  flex: 1;
  padding: 48px;
  display: flex;
  align-items: center;
}

.login-form {
  width: 100%;
  max-width: 380px;
  margin: 0 auto;
}

.login-title {
  text-align: center;
  margin-bottom: 40px;
  color: #1d2129;
  font-size: 28px;
  font-weight: 500;
}
</style> 