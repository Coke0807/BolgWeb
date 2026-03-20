-- =========================================
-- BolgWeb 数据库初始化脚本
-- 数据库: sh-cynosdbmysql-grp-h7vr2qty.sql.tencentcdb.com:21203
-- =========================================

CREATE DATABASE IF NOT EXISTS bolgweb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE bolgweb;

-- =========================================
-- 用户表
-- =========================================
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码（加密存储）',
    `nickname` VARCHAR(100) NOT NULL COMMENT '昵称',
    `avatar` VARCHAR(255) DEFAULT 'B' COMMENT '头像',
    `email` VARCHAR(100) COMMENT '邮箱',
    `role` VARCHAR(20) DEFAULT 'USER' COMMENT '角色：USER-普通用户，ADMIN-管理员',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- =========================================
-- 文章表
-- =========================================
CREATE TABLE IF NOT EXISTS `post` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '文章ID',
    `title` VARCHAR(255) NOT NULL COMMENT '文章标题',
    `content` TEXT NOT NULL COMMENT '文章内容（HTML格式）',
    `excerpt` VARCHAR(500) COMMENT '文章摘要',
    `cover` VARCHAR(255) COMMENT '封面图',
    `author_id` BIGINT NOT NULL COMMENT '作者ID',
    `category` VARCHAR(50) COMMENT '分类',
    `tags` VARCHAR(255) COMMENT '标签（逗号分隔）',
    `view_count` INT DEFAULT 0 COMMENT '浏览量',
    `comment_count` INT DEFAULT 0 COMMENT '评论数',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-草稿，1-发布',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (`author_id`) REFERENCES `user`(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- =========================================
-- 评论表
-- =========================================
CREATE TABLE IF NOT EXISTS `comment` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论ID',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `post_id` BIGINT NOT NULL COMMENT '文章ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父评论ID（0为顶层评论）',
    `reply_to` BIGINT COMMENT '回复的用户ID',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-删除，1-正常',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (`post_id`) REFERENCES `post`(id) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `user`(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';

-- =========================================
-- 初始数据：管理员用户 (密码: admin123)
-- =========================================
INSERT INTO `user` (`username`, `password`, `nickname`, `avatar`, `email`, `role`) VALUES
('admin', 'admin123', '博客作者', 'B', 'admin@bolgweb.com', 'ADMIN'),
('user1', 'admin123', '技术爱好者', 'T', 'user1@example.com', 'USER');

-- =========================================
-- 初始数据：10篇文章
-- =========================================
INSERT INTO `post` (`title`, `content`, `excerpt`, `cover`, `author_id`, `category`, `tags`, `view_count`, `comment_count`, `status`) VALUES

('深入理解 Kubernetes Pod 调度原理',
'<h2>前言</h2><p>Kubernetes（k8s）是目前最流行的容器编排系统。其核心功能之一就是<strong>调度（Scheduling）</strong>——决定将 Pod 部署到哪个 Node 上运行。理解调度原理，有助于我们在生产环境中更精细地管控资源、提升集群利用率。</p><h2>调度器工作流程</h2><p>Kubernetes 调度器的工作分为三个阶段：</p><ol><li><strong>预选（Predicates）</strong>：过滤不符合条件的节点</li><li><strong>优选（Priorities）</strong>：对剩余节点进行打分</li><li><strong>绑定（Binding）</strong>：将 Pod 绑定到最优节点</li></ol><h2>自定义调度策略</h2><p>通过配置 <code>nodeSelector</code>、<code>affinity</code> 和 <code>taint/toleration</code>，我们可以实现更精细的调度控制。</p>',
'本文系统介绍 k8s 调度器的工作机制，包括预选、优选和绑定三个阶段，并通过实例演示自定义调度策略的实现方式。',
'☸️', 1, 'Kubernetes', 'kubernetes,docker,linux', 2340, 15, 1),

('Docker 容器网络详解',
'<h2>什么是容器网络？</h2><p>Docker 容器网络是 Docker 容器之间以及容器与外部世界通信的桥梁。理解容器网络对于设计分布式系统和排查网络问题至关重要。</p><h2>网络模式</h2><p>Docker 提供了多种网络模式：</p><ul><li><strong>bridge</strong>：默认模式，创建独立网络</li><li><strong>host</strong>：容器共享宿主机网络</li><li><strong>overlay</strong>：跨主机容器通信</li><li><strong>none</strong>：禁用网络</li></ul><h2>容器通信原理</h2><p>在同一 bridge 网络下的容器可以通过容器名互相访问，Docker 内置了 DNS 服务来解析容器名。</p>',
'详细介绍 Docker 的四种网络模式，以及容器间通信的原理和实践技巧。',
'🐳', 1, 'Docker', 'docker,linux,网络', 1890, 8, 1),

('Go 语言并发编程实战',
'<h2>Go 的并发模型</h2><p>Go 语言以轻量级的协程（goroutine）和通道（channel）为核心，提供了一种简洁而强大的并发编程模型。与传统的线程相比，goroutine 的创建成本极低，可以轻松创建数万个并发任务。</p><h2>Goroutine</h2><p>只需在函数调用前加 <code>go</code> 关键字，即可启动一个 goroutine：</p><pre><code>go func() {\n    // 并发任务\n}()</code></pre><h2>Channel</h2><p>Channel 是 goroutine 之间的通信机制，保证了数据传递的安全性和同步性。</p>',
'深入讲解 Go 语言的 goroutine、channel 和 select 语句，帮助你掌握高性能并发编程。',
'🔧', 1, 'Go', 'golang,并发,编程', 1560, 12, 1),

('Linux 系统性能调优指南',
'<h2>性能监控工具</h2><p>Linux 提供了丰富的性能监控工具，包括 <code>top</code>、<code>htop</code>、<code>vmstat</code>、<code>iostat</code> 等。这些工具可以帮助我们实时监控系统资源使用情况。</p><h2>CPU 调优</h2><p>通过调整进程优先级、绑定 CPU 核心等手段，可以提升关键业务的处理能力。使用 <code>taskset</code> 命令可以将进程绑定到特定 CPU 核心。</p><h2>内存优化</h2><p>合理的内存缓存策略和 swap 使用可以显著提升系统性能。建议监控 <code>free</code> 和 <code>vmstat</code> 的输出，及时调整。</p>',
'从 CPU、内存、磁盘 I/O 和网络四个方面介绍 Linux 系统性能调优的核心技巧。',
'🐧', 1, 'Linux', 'linux,性能调优,运维', 2100, 20, 1),

('Python 异步编程入门',
'<h2>异步编程概念</h2><p>异步编程是一种并发编程范式，允许在等待 I/O 操作完成时执行其他任务，从而提高程序的整体吞吐率。Python 从 3.5 版本开始支持 <code>async/await</code> 语法。</p><h2>async/await 语法</h2><pre><code>import asyncio\n\nasync def main():\n    await asyncio.sleep(1)\n    print("Hello")\n\nasyncio.run(main())</code></pre><h2>异步 HTTP 请求</h2><p>使用 <code>aiohttp</code> 库可以发起异步 HTTP 请求，适合高并发的爬虫和 API 调用场景。</p>',
'通过实例讲解 Python 异步编程的核心概念和实际应用场景。',
'🐍', 1, 'Python', 'python,异步,编程', 980, 6, 1),

('CI/CD 流水线设计与实践',
'<h2>什么是 CI/CD？</h2><p>CI（持续集成）和 CD（持续交付/部署）是现代软件开发的核心实践。通过自动化的构建、测试和部署流程，可以显著提高软件交付效率和质量。</p><h2>流水线设计</h2><p>一个典型的 CI/CD 流水线包括：</p><ol><li>代码提交触发</li><li>单元测试</li><li>构建镜像</li><li>集成测试</li><li>部署到测试环境</li><li>部署到生产环境</li></ol><h2>工具选择</h2><p>常用的 CI/CD 工具包括 Jenkins、GitLab CI、GitHub Actions 等。</p>',
'从零开始设计一套高效的 CI/CD 流水线，包含工具选型和最佳实践。',
'🔄', 1, 'CI/CD', 'ci/cd,devops,自动化', 1720, 11, 1),

('Spring Boot 项目优化技巧',
'<h2>启动优化</h2><p>Spring Boot 应用的启动速度直接影响部署效率。通过以下方式可以显著提升启动速度：</p><ul><li>启用懒加载（lazy initialization）</li><li>排除不需要的自动配置</li><li>使用 AOT 编译</li></ul><h2>运行时优化</h2><p>使用 <code>@EnableCaching</code> 启用缓存，合理配置连接池大小，使用异步处理耗时操作。</p><h2>监控与诊断</h2><p>集成 Spring Boot Actuator 和 Micrometer，可以实现全面的应用监控。</p>',
'分享 10 个 Spring Boot 项目优化的实用技巧，覆盖启动优化和运行时优化。',
'☕', 1, 'Java', 'java,springboot,后端', 1450, 9, 1),

('深入理解 MySQL 索引原理',
'<h2>索引类型</h2><p>MySQL 支持多种索引类型：</p><ul><li>B-Tree 索引：默认索引类型，适合范围查询</li><li>Hash 索引：适合等值查询</li><li>全文索引：适合文本搜索</li><li>组合索引：多列索引，遵循最左前缀原则</li></ul><h2>索引优化</h2><p>创建索引时需要考虑：</p><ol><li>选择区分度高的列</li><li>控制索引数量，避免过多索引影响写入性能</li><li>合理使用覆盖索引，减少回表查询</li></ol><h2>索引失效场景</h2><p>避免在索引列上使用函数、进行类型转换或使用 <code>NOT NULL</code> 判断。</p>',
'系统讲解 MySQL 索引的数据结构、类型选择和优化策略。',
'🗃️', 1, '数据库', 'mysql,数据库,索引', 2650, 18, 1),

('微服务架构设计模式',
'<h2>微服务拆分策略</h2><p>微服务拆分是架构设计的首要问题。常见的拆分方法包括：</p><ul><li>按业务能力拆分</li><li>按领域驱动设计（DDD）拆分</li><li>按团队边界拆分</li></ul><h2>服务间通信</h2><p>同步通信使用 REST 或 gRPC，异步通信使用消息队列。服务注册与发现通常使用 Nacos 或 Consul。</p><h2>高可用设计</h2><p>通过熔断器（Circuit Breaker）、限流、降级等手段保证系统稳定性。</p>',
'介绍微服务架构的核心设计模式和实践经验。',
'🏛️', 1, '架构', '微服务,架构,设计模式', 1980, 14, 1),

('Redis 缓存设计与最佳实践',
'<h2>缓存策略</h2><p>Redis 常用的缓存策略包括：</p><ul><li><strong>Cache Aside</strong>：应用主导，更新时先更新数据库再删除缓存</li><li><strong>Read Through</strong>：缓存负责加载数据</li><li><strong>Write Through</strong>：写操作同时更新缓存和数据库</li></ul><h2>缓存问题</h2><p>需要处理：</p><ol><li><strong>缓存穿透</strong>：使用布隆过滤器或缓存空值</li><li><strong>缓存击穿</strong>：使用互斥锁或永不过期策略</li><li><strong>缓存雪崩</strong>：设置随机过期时间</li></ol><h2>持久化</h2><p>Redis 提供 RDB 和 AOF 两种持久化方式，根据场景选择合适的策略。</p>',
'全面讲解 Redis 缓存策略、常见问题解决方案和最佳实践。',
'📦', 1, '数据库', 'redis,缓存,数据库', 2250, 16, 1);

-- =========================================
-- 初始评论数据
-- =========================================
INSERT INTO `comment` (`content`, `post_id`, `user_id`, `parent_id`, `reply_to`, `status`) VALUES
('讲得很清楚，终于理解了调度原理！', 1, 2, 0, NULL, 1),
('谢谢分享，期待更多 k8s 文章', 1, 2, 0, NULL, 1),
('请问有关于 Pod 优先级调度的问题', 1, 2, 0, NULL, 1),
('写得很好，对我帮助很大', 2, 2, 0, NULL, 1),
('goroutine 真是 Go 的杀手级特性', 3, 2, 0, NULL, 1),
('收藏了，性能调优正好需要', 4, 2, 0, NULL, 1),
('异步编程确实让代码简洁很多', 5, 2, 0, NULL, 1);
