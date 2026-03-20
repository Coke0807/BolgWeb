<template>
  <div v-if="post">
    <div class="post-hero">
      <div class="container">
        <div class="post-hero-inner">
          <nav class="breadcrumb" aria-label="面包屑导航">
            <router-link to="/">首页</router-link>
            <span>›</span>
            <span>{{ post.category }}</span>
            <span>›</span>
            <span>{{ post.title }}</span>
          </nav>
          <div class="post-tags" style="margin-bottom:16px;" v-if="post.tags">
            <span v-for="tag in post.tags.split(',')" :key="tag" class="post-tag">{{ tag }}</span>
          </div>
          <h1>{{ post.title }}</h1>
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
        </div>
      </div>
    </div>

    <div class="container post-detail-layout">
      <article class="post-content">
        <div class="post-cover-placeholder" role="img" :aria-label="`${post.title} 封面图`">
          {{ post.cover || '📝' }}
        </div>
        <div v-html="post.content"></div>

        <div class="comment-section">
          <h3>💬 评论 ({{ comments.length }})</h3>

          <div class="comment-form" v-if="isLoggedIn">
            <textarea
              v-model="newComment"
              placeholder="写下你的评论..."
            ></textarea>
            <button class="btn btn-primary" @click="submitComment">发表评论</button>
          </div>
          <div v-else style="margin-bottom: 24px; color: var(--text-muted);">
            请 <router-link to="/login">登录</router-link> 后发表评论
          </div>

          <div v-if="loadingComments" style="text-align: center; padding: 24px; color: var(--text-muted);">
            加载评论中...
          </div>
          <div v-else-if="comments.length === 0" style="text-align: center; padding: 24px; color: var(--text-muted);">
            暂无评论，来抢沙发吧！
          </div>
          <div v-else>
            <div v-for="comment in comments" :key="comment.id" class="comment-item">
              <div class="avatar">{{ comment.userAvatar || 'U' }}</div>
              <div class="comment-body">
                <div class="comment-header">
                  <span class="comment-author">{{ comment.userNickname }}</span>
                  <span class="comment-time">{{ formatDate(comment.createdAt) }}</span>
                </div>
                <div class="comment-text">{{ comment.content }}</div>
                <div class="comment-actions" v-if="isLoggedIn">
                  <button @click="replyTo(comment)">回复</button>
                </div>

                <div v-if="replyingTo === comment.id" class="comment-reply">
                  <textarea
                    v-model="replyContent"
                    :placeholder="`回复 @${comment.userNickname}...`"
                    style="width: 100%; min-height: 80px; margin-bottom: 8px;"
                  ></textarea>
                  <button class="btn btn-primary" style="padding: 8px 16px;" @click="submitReply(comment.id)">发送回复</button>
                  <button class="btn btn-outline" style="padding: 8px 16px; margin-left: 8px;" @click="cancelReply">取消</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </article>

      <aside class="sidebar">
        <div class="side-widget">
          <h3>📌 关于作者</h3>
          <div style="text-align: center; padding: 16px 0;">
            <div class="avatar" style="width: 64px; height: 64px; font-size: 1.5rem; margin: 0 auto 12px;">
              {{ post.authorAvatar || 'B' }}
            </div>
            <div style="font-weight: 600;">{{ post.authorNickname || '博客作者' }}</div>
            <div style="font-size: 0.85rem; color: var(--text-muted); margin-top: 4px;">技术博主</div>
          </div>
        </div>

        <div class="side-widget">
          <h3>📚 相关标签</h3>
          <div class="post-tags" v-if="post.tags">
            <span v-for="tag in post.tags.split(',')" :key="tag" class="post-tag">{{ tag }}</span>
          </div>
        </div>
      </aside>
    </div>
  </div>

  <div v-else-if="loading" style="text-align: center; padding: 120px 0;">
    <div style="font-size: 1.2rem; color: var(--text-muted);">加载中...</div>
  </div>

  <div v-else style="text-align: center; padding: 120px 0;">
    <div style="font-size: 1.2rem; color: var(--text-muted);">文章不存在</div>
    <router-link to="/" class="btn btn-primary" style="margin-top: 24px;">返回首页</router-link>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import api from '../api'
import { useUserStore } from '../stores/user'

const route = useRoute()
const userStore = useUserStore()

const post = ref(null)
const comments = ref([])
const loading = ref(false)
const loadingComments = ref(false)
const newComment = ref('')
const replyContent = ref('')
const replyingTo = ref(null)

const isLoggedIn = computed(() => userStore.isLoggedIn)

function formatDate(dateStr) {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日`
}

async function fetchPost() {
  loading.value = true
  try {
    const res = await api.getPost(route.params.id)
    if (res.code === 200) {
      post.value = res.data
    }
  } catch (error) {
    console.error('Failed to fetch post:', error)
  } finally {
    loading.value = false
  }
}

async function fetchComments() {
  loadingComments.value = true
  try {
    const res = await api.getComments(route.params.id)
    if (res.code === 200) {
      comments.value = res.data || []
    }
  } catch (error) {
    console.error('Failed to fetch comments:', error)
  } finally {
    loadingComments.value = false
  }
}

async function submitComment() {
  if (!newComment.value.trim()) return
  try {
    const res = await api.addComment({
      content: newComment.value,
      postId: route.params.id,
      userId: userStore.userId,
      parentId: 0
    })
    if (res.code === 200) {
      newComment.value = ''
      fetchComments()
    }
  } catch (error) {
    alert('评论失败')
  }
}

function replyTo(comment) {
  replyingTo.value = comment.id
  replyContent.value = ''
}

function cancelReply() {
  replyingTo.value = null
  replyContent.value = ''
}

async function submitReply(parentId) {
  if (!replyContent.value.trim()) return
  try {
    const res = await api.addComment({
      content: replyContent.value,
      postId: route.params.id,
      userId: userStore.userId,
      parentId: parentId,
      replyTo: comments.value.find(c => c.id === parentId)?.userId
    })
    if (res.code === 200) {
      replyContent.value = ''
      replyingTo.value = null
      fetchComments()
    }
  } catch (error) {
    alert('回复失败')
  }
}

onMounted(() => {
  fetchPost()
  fetchComments()
})
</script>
