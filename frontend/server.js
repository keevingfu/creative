/**
 * AI创意大脑 - 前端静态服务器
 */

const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// 静态文件服务
app.use(express.static(path.join(__dirname)));

// 路由
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'html', 'index.html'));
});

app.get('/creative-generation', (req, res) => {
  res.sendFile(path.join(__dirname, 'html', 'creative-generation.html'));
});

app.get('/script-editing', (req, res) => {
  res.sendFile(path.join(__dirname, 'html', 'script-editing.html'));
});

app.get('/quadrant-validation', (req, res) => {
  res.sendFile(path.join(__dirname, 'html', 'quadrant-validation.html'));
});

// 服务器启动
app.listen(PORT, '0.0.0.0', () => {
  console.log(`AI创意大脑前端服务已启动，监听端口: ${PORT}`);
});
