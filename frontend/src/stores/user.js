import { defineStore } from 'pinia'
import api from '../api'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('token') || '',
    userId: localStorage.getItem('userId') || null,
    username: localStorage.getItem('username') || '',
    nickname: localStorage.getItem('nickname') || '',
    avatar: localStorage.getItem('avatar') || 'B',
    role: localStorage.getItem('role') || ''
  }),

  getters: {
    isLoggedIn: state => !!state.token
  },

  actions: {
    async login(username, password) {
      const res = await api.login(username, password)
      if (res.code === 200) {
        const { token, userId, username, nickname, avatar, role } = res.data
        this.token = token
        this.userId = userId
        this.username = username
        this.nickname = nickname
        this.avatar = avatar
        this.role = role

        localStorage.setItem('token', token)
        localStorage.setItem('userId', userId)
        localStorage.setItem('username', username)
        localStorage.setItem('nickname', nickname)
        localStorage.setItem('avatar', avatar)
        localStorage.setItem('role', role)

        return true
      }
      throw new Error(res.message)
    },

    logout() {
      this.token = ''
      this.userId = null
      this.username = ''
      this.nickname = ''
      this.avatar = 'B'
      this.role = ''

      localStorage.removeItem('token')
      localStorage.removeItem('userId')
      localStorage.removeItem('username')
      localStorage.removeItem('nickname')
      localStorage.removeItem('avatar')
      localStorage.removeItem('role')
    }
  }
})
