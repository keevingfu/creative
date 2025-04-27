# AI创意大脑 - 快速入门指南

欢迎使用AI创意大脑！本指南将帮助您快速上手我们的创意开发平台。

## 1. 系统概述

AI创意大脑是一个基于大语言模型的专业化创意开发平台，主要功能包括：

- **四象限创意生成**：基于已知已知、已知未知、未知已知、未知未知四象限方法论
- **分镜头脚本生成**：将创意方案转化为详细的分镜头脚本
- **视频创意分析**：分析竞品创意视频，提供可借鉴的创意元素
- **创意质量验证**：从多维度评估创意质量和可行性

## 2. 系统要求

- **操作系统**：Windows 10/11, macOS 10.15+, Ubuntu 20.04+
- **浏览器**：Chrome 90+, Firefox 90+, Edge 90+
- **网络**：稳定的互联网连接

## 3. 快速部署

### 使用Docker（推荐）

1. 确保已安装Docker和Docker Compose
2. 克隆代码库：`git clone https://github.com/yourusername/creative-brain.git`
3. 进入项目目录：`cd creative-brain`
4. 配置环境变量：
   ```
   cp .env.example .env
   # 编辑.env文件，设置必要的API密钥
   ```
5. 启动服务：`./setup.sh`

系统将在以下地址可用：
- 前端界面：http://localhost:3000
- API服务：http://localhost:5000
- n8n工作流：http://localhost:5678

### 手动部署

1. 安装Node.js (v16+) 和 MongoDB (v5+)
2. 克隆代码库并安装依赖：
   ```
   git clone https://github.com/yourusername/creative-brain.git
   cd creative-brain
   npm install
   ```
3. 配置环境变量：`cp .env.example .env`
4. 启动API服务：`npm start`
5. 在新终端中启动前端服务：`cd frontend && node server.js`

## 4. 基本使用流程

### 创意生成

1. 访问`http://localhost:3000/creative-generation`
2. 填写产品信息：
   - 产品名称和描述
   - 目标受众
   - 选择平台和时长
   - 选择创意象限
3. 点击「生成创意」按钮
4. 系统将生成多个创意方案，包含标题、概述、创意机制、视觉风格等

### 分镜头脚本生成

1. 在创意列表中，找到满意的创意方案
2. 点击「生成分镜脚本」
3. 系统将生成详细的分镜头脚本，包含：
   - 分镜说明
   - 视觉效果
   - 音频指导
   - 制作注意事项

### 创意搜索与分析

1. 访问`http://localhost:3000/search`
2. 输入相关关键词
3. 系统将返回主流平台的相关视频，并进行四象限分类
4. 查看详细分析报告，了解创意机制和可借鉴元素

## 5. 高级功能

### 自定义n8n工作流

1. 访问`http://localhost:5678`
2. 使用默认凭据登录：
   - 用户名：admin@example.com
   - 密码：admin123
3. 在工作流面板中，可以查看和编辑现有工作流
4. 可以调整大语言模型参数，或添加新的处理节点

### API集成

您可以通过API将AI创意大脑集成到现有系统中：

```javascript
async function generateCreative() {
  const response = await fetch('http://localhost:5000/api/v2/creative/generate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      product_name: '智能解压球',
      product_description: '一款能够感应压力并提供减压反馈的智能玩具',
      target_audience: '都市白领',
      quadrant: '已知未知'
    })
  });
  return await response.json();
}
```

## 6. 故障排除

### 常见问题

1. **服务无法启动**
   - 检查端口是否被占用
   - 确认MongoDB服务是否正常运行
   - 查看日志：`docker-compose logs -f`

2. **n8n工作流执行失败**
   - 确认API密钥设置正确
   - 检查工作流配置和连接
   - 增加执行超时时间

3. **生成结果质量不佳**
   - 增加产品描述的详细程度
   - 明确目标受众和使用场景
   - 调整n8n工作流中的模型参数

### 获取支持

- 查阅详细文档：`/creativedoc/documents/`
- 提交GitHub Issue：`https://github.com/yourusername/creative-brain/issues`
- 联系支持团队：support@example.com

## 7. 后续步骤

- 探索更多文档完善您的使用体验
- 参考示例项目了解最佳实践
- 尝试定制开发，扩展平台功能

感谢您使用AI创意大脑，祝您创作愉快！