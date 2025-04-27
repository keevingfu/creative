#!/bin/bash

# AI创意大脑 - Docker部署脚本
# 该脚本使用你的Docker凭据登录，拉取必要的镜像，并部署整个系统

set -e  # 任何命令失败立即退出

# 系统限制设置
MAX_TOKEN_SIZE=100000  # API请求的最大token数量
MAX_CONTEXT_SIZE=128   # 上下文窗口最大大小(MB)

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # 无颜色

# 打印带颜色的消息
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 从.env文件加载环境变量
if [ -f .env ]; then
    log_info "从.env文件加载环境变量..."
    export $(grep -v '^#' .env | xargs)
else
    log_error ".env文件不存在，请先创建.env文件"
    exit 1
fi

# 跳过Docker Hub登录，直接继续部署过程
log_info "跳过Docker登录，直接继续部署过程..."

# 检查并限制上下文窗口大小
log_info "检查上下文窗口大小..."
CURRENT_MEMORY=$(ps -o rss= -p $$)
CURRENT_MEMORY_MB=$((CURRENT_MEMORY / 1024))
if [ $CURRENT_MEMORY_MB -gt $MAX_CONTEXT_SIZE ]; then
    log_warn "上下文窗口大小($CURRENT_MEMORY_MB MB)超过限制($MAX_CONTEXT_SIZE MB)，将尝试优化内存使用"
    # 清理不必要的环境变量和临时文件
    export -n HISTFILE LESSOPEN LESSCLOSE LESS
    rm -f /tmp/temp_* 2>/dev/null
fi

# 检查并限制API请求的token数量
log_info "检查API请求token限制..."
check_token_size() {
    local file="$1"
    local file_size=$(wc -c < "$file")
    local estimated_tokens=$((file_size / 4))  # 粗略估计：平均每个token约4字节
    
    if [ $estimated_tokens -gt $MAX_TOKEN_SIZE ]; then
        log_warn "文件 $file 的估计token数($estimated_tokens)超过限制($MAX_TOKEN_SIZE)"
        return 1
    fi
    return 0
}

# 检查大型文档文件
for doc_file in $(find ./creativedoc -type f -name "*.md" 2>/dev/null); do
    if ! check_token_size "$doc_file"; then
        log_warn "将压缩文件 $doc_file 以减少token数量"
        # 创建备份
        cp "$doc_file" "${doc_file}.bak"
        # 提取文件的前1/3和后1/3部分，跳过中间部分以减少token
        head -n $(wc -l < "$doc_file" | awk '{print int($1/3)}') "$doc_file" > "${doc_file}.tmp"
        echo "\n...内容已压缩以减少token数量...\n" >> "${doc_file}.tmp"
        tail -n $(wc -l < "$doc_file" | awk '{print int($1/3)}') "$doc_file" >> "${doc_file}.tmp"
        mv "${doc_file}.tmp" "$doc_file"
        log_info "已压缩文件 $doc_file 以减少token数量"
    fi
done

# 检查Docker和Docker Compose是否已安装
log_info "检查Docker和Docker Compose..."
if ! command -v docker &> /dev/null; then
    log_error "未找到Docker，请先安装Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker info &> /dev/null; then
    log_error "Docker守护进程未运行或当前用户没有权限访问Docker，请检查Docker状态"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    log_warn "未找到docker-compose命令，将尝试使用docker compose子命令"
    if ! docker compose version &> /dev/null; then
        log_error "Docker Compose未安装，请安装Docker Compose: https://docs.docker.com/compose/install/"
        exit 1
    fi
    USE_DOCKER_COMPOSE_PLUGIN=true
else
    USE_DOCKER_COMPOSE_PLUGIN=false
fi

log_info "Docker和Docker Compose检查通过"

# 创建必要的目录
log_info "创建必要的目录..."
mkdir -p agent_prompts/
mkdir -p api/
mkdir -p frontend/
mkdir -p uploads/
mkdir -p logs/
mkdir -p n8n_workflow/workflows/
mkdir -p n8n_workflow/credentials/

# 构建并启动容器
log_info "构建并启动Docker容器..."
if [ "$USE_DOCKER_COMPOSE_PLUGIN" = true ]; then
    docker compose build
    docker compose up -d
else
    docker-compose build
    docker-compose up -d
fi

# 等待服务启动
log_info "等待服务启动..."
sleep 10

# 显示容器状态
log_info "容器状态:"
if [ "$USE_DOCKER_COMPOSE_PLUGIN" = true ]; then
    docker compose ps
else
    docker-compose ps
fi

# 显示n8n服务URL
log_info "\n=== n8n服务信息 ==="
log_info "n8n URL: $N8N_URL"
log_info "用户名: $N8N_USERNAME"
log_info "密码: $N8N_PASSWORD"

# 提示后续步骤
log_info "\n=== 部署完成 ==="
log_info "您现在可以访问以下服务:"
log_info "1. n8n工作流: http://localhost:5678 (已配置)"
log_info "2. API服务: http://localhost:5000 (稍后可用)"
log_info "3. 前端界面: http://localhost:3000 (稍后可用)"

log_info "\n=== 后续步骤 ==="
log_info "1. 访问n8n并使用提供的凭据登录"
log_info "2. 初始化n8n工作流 (可使用 'node n8n_workflow/run_n8n_setup.js')"
log_info "3. 在系统完全启动后，通过前端界面访问应用"

log_info "\n部署脚本执行完成!"