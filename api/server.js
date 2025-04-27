/**
 * AI创意大脑 - API服务器
 * 提供API接口与n8n工作流交互
 */

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');
const fs = require('fs');
const path = require('path');

// 环境变量配置
require('dotenv').config();

// 创建Express应用
const app = express();
const PORT = process.env.PORT || 5000;

// 中间件
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));

// 创建必要的目录
const uploadsDir = path.join(__dirname, '..', 'uploads');
const logsDir = path.join(__dirname, '..', 'logs');

if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

// n8n配置
const n8nConfig = {
  url: process.env.N8N_URL || 'http://n8n:5678',
  username: process.env.N8N_USERNAME || 'cavinfu007@gmail.com',
  password: process.env.N8N_PASSWORD || '!YbRUMbtHmjC52K'
};

// API路由
app.get('/api/v2/system/health', (req, res) => {
  res.json({
    status: 'ok',
    version: '2.3.1',
    timestamp: new Date().toISOString(),
    services: {
      api: 'running',
      database: 'connected',
      n8n: n8nConfig.url
    }
  });
});

app.get('/api/v2/system/status', (req, res) => {
  res.json({
    status: 'operational',
    version: '2.3.1',
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    environment: process.env.NODE_ENV || 'production'
  });
});