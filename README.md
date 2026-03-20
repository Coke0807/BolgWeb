# BolgWeb

一个现代化的全栈博客系统，基于 Spring Boot + Vue 3 构建，支持容器化部署。

## 技术栈

### 后端
- **框架**: Spring Boot 3.2.0
- **ORM**: MyBatis Plus 3.5.5
- **数据库**: MySQL 8.0
- **Java**: OpenJDK 17

### 前端
- **框架**: Vue 3.4
- **构建工具**: Vite 5.0
- **路由**: Vue Router 4.2
- **状态管理**: Pinia 2.1
- **HTTP 客户端**: Axios 1.6

### 部署
- **容器化**: Docker
- **Web 服务器**: Nginx

## 项目结构

```
bolg/
├── backend/                 # Spring Boot 后端
│   ├── src/main/java/      # Java 源代码
│   │   └── com.bolgweb/
│   │       ├── config/     # 配置类
│   │       ├── controller/  # 控制器
│   │       ├── dto/         # 数据传输对象
│   │       ├── entity/      # 实体类
│   │       ├── mapper/      # MyBatis 映射器
│   │       └── service/     # 业务逻辑
│   ├── src/main/resources/ # 配置文件
│   └── pom.xml             # Maven 依赖配置
├── frontend/               # Vue 3 前端
│   ├── src/
│   │   ├── api/            # API 接口
│   │   ├── assets/         # 静态资源
│   │   ├── components/     # 公共组件
│   │   ├── router/         # 路由配置
│   │   ├── stores/         # Pinia 状态管理
│   │   └── views/          # 页面视图
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
├── sql/                    # 数据库脚本
│   └── init.sql
├── .env.example            # 环境变量模板
├── Dockerfile              # Docker 镜像构建
└── nginx.conf              # Nginx 配置
```

## 环境配置

### 1. 复制环境变量模板

```bash
cp .env.example .env
```

### 2. 编辑 `.env` 文件，填入你的配置

```bash
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_NAME=bolgweb
DB_USERNAME=root
DB_PASSWORD=your_password_here

# JWT 配置（建议至少 256 位随机字符串）
JWT_SECRET=your_very_long_and_secure_secret_key_here_min_256_bits
```

### 3. Docker 部署时使用

```bash
docker run -d -p 8080:8080 \
  -e DB_HOST=your_db_host \
  -e DB_PASSWORD=your_password \
  -e JWT_SECRET=your_secret \
  bolgweb
```

## 快速开始

### 环境要求

- JDK 17+
- Node.js 18+
- MySQL 8.0+
- Docker (可选)

### 后端启动

```bash
cd backend
# 设置环境变量 (Linux/Mac)
export DB_PASSWORD=your_password
export JWT_SECRET=your_secret

# Windows PowerShell
$env:DB_PASSWORD="your_password"
$env:JWT_SECRET="your_secret"

./mvnw spring-boot:run
# 或
java -jar target/bolgweb-backend-1.0.0.jar
```

### 前端启动

```bash
cd frontend
npm install
npm run dev
```

### Docker 部署

```bash
docker build -t bolgweb .
docker run -d -p 8080:8080 bolgweb
```

## 功能特性

- 用户认证与权限管理
- 文章发布与编辑
- 评论系统
- 响应式设计

## API 文档

| 接口路径 | 说明 |
|---------|------|
| `/api/auth/*` | 认证相关 |
| `/api/posts/*` | 文章管理 |
| `/api/comments/*` | 评论管理 |

## 许可证

MIT License
