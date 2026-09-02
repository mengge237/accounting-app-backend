# 记账本 App 后端（accounting-app-backend）

Android 记账本应用的服务端 API，Express + MySQL 实现，JWT 鉴权。

## ✨ 功能特性

- 🔐 **JWT + bcrypt 鉴权**：注册/登录/密码加密，安全认证
- 📒 **多模块 API**：账本、账单记录、分类（菜系）、统计报表、日程、背景图、菜谱
- 📊 **统计接口**：账单统计与报表聚合
- ⚙️ **工程化配置**：CORS、环境变量（dotenv）、上传路径统一管理

## 🛠 技术栈

| 层 | 技术 |
|---|---|
| 运行时 | Node.js |
| Web 框架 | Express 4 |
| 数据库 | MySQL（mysql2） |
| 鉴权 | JWT（jsonwebtoken）+ bcryptjs |
| 配置 | dotenv / cors |
| 开发 | nodemon |

## 📁 项目结构

```
├── backend/
│   ├── src/
│   │   ├── routes/        # 路由：auth/records/statistics/ledgers/schedules 等
│   │   ├── database.js    # 数据库连接
│   │   └── *.js           # 各模块业务逻辑
│   ├── uploads/           # 上传文件
│   ├── .env               # 环境变量（DB 配置）
│   └── server.js          # 服务入口
├── server.js              # 入口转发
└── 启动.bat
```

## 🚀 快速开始

```bash
# 1. 安装依赖
cd backend && npm install

# 2. 配置环境变量（backend/.env）
# DB_HOST=localhost  DB_USER=xxx  DB_PASSWORD=xxx  DB_NAME=accounting

# 3. 启动
npm start        # 或 npm run dev（nodemon 热重载）
```

服务默认运行在 `http://localhost:8080`。

## 🔌 API 概览

| 模块 | 路径前缀 | 说明 |
|---|---|---|
| 鉴权 | `/api/auth` | 注册 / 登录（JWT） |
| 账单 | `/api/records` | 记账增删改查 |
| 统计 | `/api/statistics` | 报表统计 |
| 账本 | `/api/ledgers` | 账本管理 |
| 日程 | `/api/schedules` | 日程提醒 |
| 分类 | `/api/cuisines` | 分类管理 |
| 菜谱 | `/api/recipes` | 菜谱数据 |
| 背景 | `/api/background` | 背景图 |

## 📱 配套客户端

Android 客户端（同仓库 Android 工程），对接以上 RESTful API。
