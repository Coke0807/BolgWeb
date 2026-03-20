# BolgWeb 全栈项目启动指南

## 项目结构
```
bolgweb/
├── frontend/          # Vue 3 前端项目
├── backend/           # Spring Boot 后端项目
└── sql/
    └── init.sql       # 数据库初始化脚本
```

## 数据库初始化

请手动执行以下 SQL 脚本初始化数据库：

1. 登录腾讯云数据库：
```bash
mysql -h sh-cynosdbmysql-grp-h7vr2qty.sql.tencentcdb.com -P 21203 -u root -p[你的密码]
```

2. 执行 sql/init.sql 文件中的所有 SQL 语句

**注意**：如果密码不正确，请修改 backend/src/main/resources/application.yml 中的密码配置。

## 后端启动

```bash
cd backend
mvn spring-boot:run
```

后端启动地址：http://localhost:8088

## 前端启动

```bash
cd frontend
npm install
npm run dev
```

前端启动地址：http://localhost:3000

## 登录信息

- 默认管理员账号：admin
- 默认密码：admin123

## 功能说明

- 首页：浏览所有文章
- 文章详情：查看文章内容和评论
- 关于我：作者介绍
- 登录后：可以发表评论

## 注意事项

1. 确保腾讯云数据库已开启外网访问
2. 确保 application.yml 中的数据库密码正确
3. 前端开发服务器会自动代理 /api 请求到后端
