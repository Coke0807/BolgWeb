<template>
  <nav class="navbar">
    <div class="container navbar-inner">
      <router-link to="/" class="brand">
        <div class="brand-icon">✍️</div>
        BolgWeb
      </router-link>
      <ul class="nav-links">
        <li><router-link to="/" :class="{ active: $route.path === '/' }">首页</router-link></li>
        <li><router-link to="/about" :class="{ active: $route.path === '/about' }">关于我</router-link></li>
      </ul>
      <div class="nav-actions">
        <button v-if="isLoggedIn" class="btn-outline" @click="handleLogout" style="padding: 8px 16px; font-size: 0.85rem;">
          退出
        </button>
        <router-link v-else to="/login" class="btn-outline" style="padding: 8px 16px; font-size: 0.85rem;">
          登录
        </router-link>
        <button class="btn-icon" @click="toggleTheme" :title="isDark ? '切换浅色主题' : '切换深色主题'">
          {{ isDark ? '☀️' : '🌙' }}
        </button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '../stores/user'
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const router = useRouter()
const isLoggedIn = userStore.isLoggedIn

const isDark = ref(false)

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : 'light')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

function handleLogout() {
  userStore.logout()
  router.push('/login')
}

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    isDark.value = true
    document.documentElement.setAttribute('data-theme', 'dark')
  }
})
</script>
