import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

api.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default {
  login(username, password) {
    return api.post('/auth/login', { username, password })
  },

  getPosts(current = 1, size = 10, category, tag) {
    const params = { current, size }
    if (category) params.category = category
    if (tag) params.tag = tag
    return api.get('/posts', { params })
  },

  getPost(id) {
    return api.get(`/posts/${id}`)
  },

  createPost(data) {
    return api.post('/posts', data)
  },

  updatePost(id, data) {
    return api.put(`/posts/${id}`, data)
  },

  deletePost(id) {
    return api.delete(`/posts/${id}`)
  },

  getComments(postId) {
    return api.get(`/comments/post/${postId}`)
  },

  addComment(data) {
    return api.post('/comments', data)
  },

  deleteComment(id) {
    return api.delete(`/comments/${id}`)
  }
}
