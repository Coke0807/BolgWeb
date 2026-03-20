<template>
  <div>
    <section class="about-hero">
      <div class="container">
        <div class="about-hero-inner">
          <div>
            <h1>你好，我是 <span style="color:var(--primary)">{{ authorName }}</span> 👋</h1>
            <div class="about-role">☸️ 云原生工程师 · 后端开发者 · 开源爱好者</div>
            <p class="about-intro">
              热爱技术，专注于云原生生态与后端系统设计。日常与 Kubernetes、Docker、Go 和 Linux
              打交道，喜欢把踩过的坑和学到的经验记录下来，希望能帮助到更多人。
            </p>
            <div style="margin-top:24px; display:flex; gap:12px; flex-wrap:wrap;">
              <router-link to="/" class="btn btn-primary">📖 阅读博客</router-link>
              <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="btn btn-outline">🐙 GitHub</a>
            </div>
          </div>
          <div class="about-avatar-wrap">
            <div class="about-avatar">B</div>
            <div style="font-size:.85rem; color:var(--text-muted);">云原生工程师</div>
          </div>
        </div>
      </div>
    </section>

    <div class="container" style="padding-top: 80px; padding-bottom: 80px;">
      <div style="max-width: 800px; margin: 0 auto;">
        <h2 style="font-size: 1.75rem; font-weight: 700; margin-bottom: 24px;">🎯 技术栈</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 48px;">
          <div class="side-widget" style="margin-bottom: 0;">
            <h3 style="font-size: 1rem;">☸️ 容器编排</h3>
            <ul>
              <li>Kubernetes</li>
              <li>Docker</li>
              <li>Helm</li>
            </ul>
          </div>
          <div class="side-widget" style="margin-bottom: 0;">
            <h3 style="font-size: 1rem;">💻 后端开发</h3>
            <ul>
              <li>Java / Spring Boot</li>
              <li>Go</li>
              <li>Python</li>
            </ul>
          </div>
          <div class="side-widget" style="margin-bottom: 0;">
            <h3 style="font-size: 1rem;">🗄️ 数据库</h3>
            <ul>
              <li>MySQL</li>
              <li>Redis</li>
              <li>MongoDB</li>
            </ul>
          </div>
          <div class="side-widget" style="margin-bottom: 0;">
            <h3 style="font-size: 1rem;">🔧 运维工具</h3>
            <ul>
              <li>GitLab CI/CD</li>
              <li>Prometheus</li>
              <li>Grafana</li>
            </ul>
          </div>
        </div>

        <h2 style="font-size: 1.75rem; font-weight: 700; margin-bottom: 24px;">📝 关于博客</h2>
        <div class="side-widget" style="margin-bottom: 0;">
          <p style="line-height: 1.8; color: var(--text);">
            这个博客是我学习和成长的记录空间。我会定期分享云原生、后端开发、DevOps
            相关的技术文章，也会记录一些踩坑心得和最佳实践。如果你觉得我的文章对你有帮助，欢迎关注！
          </p>
          <p style="line-height: 1.8; color: var(--text); margin-top: 16px;">
            如果你有任何问题或建议，欢迎在文章下方留言，我会尽量回复每一条评论。
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const authorName = '博客作者'
</script>
