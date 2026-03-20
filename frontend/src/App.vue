<template>
  <div id="app">
    <div id="read-progress"></div>
    <Navbar />
    <router-view />
    <button id="back-top" @click="scrollToTop">↑</button>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import Navbar from './components/Navbar.vue'

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

onMounted(() => {
  const backTop = document.getElementById('back-top')
  const readBar = document.getElementById('read-progress')

  window.addEventListener('scroll', () => {
    backTop.classList.toggle('visible', window.scrollY > 300)

    const scrollTop = window.scrollY
    const docHeight = document.documentElement.scrollHeight - window.innerHeight
    const pct = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0
    readBar.style.width = pct.toFixed(2) + '%'
  })
})
</script>

<style>
#app {
  min-height: 100vh;
}
</style>
