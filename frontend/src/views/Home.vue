<template>
  <div>
    <section class="hero">
      <div class="container">
        <div class="hero-content">
          <span class="hero-label">🚀 欢迎来到我的博客</span>
          <h1>探索技术的<br /><span style="color:var(--primary)">无限可能</span></h1>
          <p>专注于云原生、Kubernetes、后端开发与开源技术，记录每一次成长与探索。</p>
          <div class="hero-actions">
            <a href="#posts" class="btn btn-primary">📖 开始阅读</a>
            <router-link to="/about" class="btn btn-outline">👋 了解作者</router-link>
          </div>
          <div class="hero-stats">
            <div>
              <div class="stat-value">{{ totalPosts }}</div>
              <div class="stat-label">篇文章</div>
            </div>
            <div>
              <div class="stat-value">{{ totalViews }}</div>
              <div class="stat-label">总阅读</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <div class="container main-layout" id="posts">
      <main>
        <div class="search-section">
          <div class="search-wrap">
            <span class="search-icon">🔍</span>
            <input
              type="search"
              v-model="searchQuery"
              @input="filterPosts"
              placeholder="搜索文章标题、摘要或标签…"
              aria-label="搜索文章"
            />
          </div>
          <div class="tags-bar" role="group" aria-label="按标签筛选">
            <button
              v-for="tag in allTags"
              :key="tag"
              class="tag"
              :class="{ active: activeTag === tag }"
              @click="selectTag(tag)"
            >
              {{ tag === 'all' ? '全部' : tag }}
            </button>
          </div>
        </div>

        <div v-if="loading" style="text-align: center; padding: 48px; color: var(--text-muted);">
          加载中...
        </div>

        <div v-else-if="filteredPosts.length === 0" style="text-align: center; padding: 48px; color: var(--text-muted);">
          没有找到相关文章
        </div>

        <div v-else style="margin-top:32px;">
          <article
            v-for="(post, index) in filteredPosts"
            :key="post.id"
            class="post-item"
            :class="{ 'featured-card': index === 0 }"
            @click="goToPost(post.id)"
          >
            <div class="post-card-img-placeholder" aria-hidden="true">{{ post.cover || '📝' }}</div>
            <div class="post-tags" v-if="post.tags">
              <span v-for="tag in post.tags.split(',')" :key="tag" class="post-tag">{{ tag }}</span>
            </div>
            <h2>{{ post.title }}</h2>
            <p>{{ post.excerpt }}</p>
            <div class="post-meta" style="margin-top:16px;">
              <div class="author">
                <div class="avatar">{{ post.authorAvatar || 'B' }}</div>
                <span class="author-name">{{ post.authorNickname || '博客作者' }}</span>
              </div>
              <span class="dot">•</span>
              <span>{{ formatDate(post.createdAt) }}</span>
              <span class="dot">•</span>
              <span>{{ post.viewCount }} 次阅读</span>
            </div>
          </article>
        </div>
      </main>

      <aside class="sidebar">
        <div class="side-widget">
          <h3>📂 分类</h3>
          <ul>
            <li v-for="cat in categories" :key="cat" @click="selectCategory(cat)" style="cursor: pointer;">
              <span>{{ cat }}</span>
            </li>
          </ul>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../api'

const router = useRouter()
const posts = ref([])
const loading = ref(false)
const searchQuery = ref('')
const activeTag = ref('all')

const allTags = computed(() => {
  const tags = new Set(['all'])
  posts.value.forEach(post => {
    if (post.tags) {
      post.tags.split(',').forEach(tag => tags.add(tag.trim()))
    }
  })
  return Array.from(tags)
})

const categories = computed(() => {
  const cats = new Set()
  posts.value.forEach(post => {
    if (post.category) cats.add(post.category)
  })
  return Array.from(cats)
})

const totalPosts = computed(() => posts.value.length)
const totalViews = computed(() => {
  return posts.value.reduce((sum, p) => sum + (p.viewCount || 0), 0).toLocaleString()
})

const filteredPosts = computed(() => {
  let result = posts.value

  if (activeTag.value !== 'all') {
    result = result.filter(p => p.tags && p.tags.includes(activeTag.value))
  }

  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    result = result.filter(p =>
      p.title.toLowerCase().includes(q) ||
      (p.excerpt && p.excerpt.toLowerCase().includes(q)) ||
      (p.tags && p.tags.toLowerCase().includes(q))
    )
  }

  return result
})

function selectTag(tag) {
  activeTag.value = tag
}

function selectCategory(cat) {
  activeTag.value = cat
}

function goToPost(id) {
  router.push(`/post/${id}`)
}

function formatDate(dateStr) {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日`
}

async function fetchPosts() {
  loading.value = true
  try {
    const res = await api.getPosts(1, 100)
    if (res.code === 200) {
      posts.value = res.data.records || []
    }
  } catch (error) {
    console.error('Failed to fetch posts:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchPosts()
})
</script>
