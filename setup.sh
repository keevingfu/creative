#!/bin/bash

# AI创意大脑 - 自动部署脚本
# 该脚本用于自动化AI创意大脑应用的部署和初始化过程

set -e  # 任何命令失败立即退出

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

# 检查Docker和Docker Compose是否已安装
check_prerequisites() {
    log_info "检查前提条件..."
    
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
    
    log_info "前提条件检查通过!"
}

# 设置环境变量
setup_environment() {
    log_info "设置环境变量..."
    
    if [ ! -f .env ]; then
        log_info "创建.env文件..."
        cp .env.example .env
        log_warn "已创建.env文件，请编辑该文件并设置必要的API密钥和其他配置"
        read -p "是否现在编辑.env文件? (y/n): " edit_env
        if [[ $edit_env == "y" || $edit_env == "Y" ]]; then
            if command -v nano &> /dev/null; then
                nano .env
            elif command -v vim &> /dev/null; then
                vim .env
            else
                log_warn "未找到nano或vim编辑器，请手动编辑.env文件"
            fi
        fi
    else
        log_info ".env文件已存在，跳过创建"
    fi
}

# 构建并启动容器
start_services() {
    log_info "启动AI创意大脑服务..."
    
    if [ "$USE_DOCKER_COMPOSE_PLUGIN" = true ]; then
        docker compose build
        docker compose up -d
    else
        docker-compose build
        docker-compose up -d
    fi
    
    log_info "服务启动成功!"
}

# 等待服务启动完成
wait_for_services() {
    log_info "等待服务就绪..."
    
    # 等待MongoDB就绪
    log_info "等待MongoDB就绪..."
    until [ "$USE_DOCKER_COMPOSE_PLUGIN" = true ] && docker compose exec -T mongodb mongosh --quiet --eval "db.serverStatus()" &> /dev/null || [ "$USE_DOCKER_COMPOSE_PLUGIN" = false ] && docker-compose exec -T mongodb mongosh --quiet --eval "db.serverStatus()" &> /dev/null; do
        log_info "MongoDB还未就绪，等待5秒..."
        sleep 5
    done
    log_info "MongoDB已就绪"
    
    # 等待API服务就绪
    log_info "等待API服务就绪..."
    until curl -s http://localhost:5000/api/v2/system/health &> /dev/null; do
        log_info "API服务还未就绪，等待5秒..."
        sleep 5
    done
    log_info "API服务已就绪"
    
    # 等待n8n就绪
    log_info "等待n8n服务就绪..."
    until curl -s http://localhost:5678 &> /dev/null; do
        log_info "n8n服务还未就绪，等待5秒..."
        sleep 5
    done
    log_info "n8n服务已就绪"
    
    log_info "所有服务已就绪!"
}

# 初始化n8n工作流
setup_n8n_workflows() {
    log_info "初始化n8n工作流..."
    
    # 运行n8n设置脚本
    node n8n_workflow/run_n8n_setup.js
    
    log_info "n8n工作流初始化完成!"
}

# 显示部署信息
show_deployment_info() {
    log_info "\n=== AI创意大脑部署完成! ==="
    log_info "您可以通过以下地址访问各个服务:"
    log_info "前端界面: http://localhost:3000"
    log_info "API服务: http://localhost:5000"
    log_info "n8n工作流: http://localhost:5678"
    log_info "\n初始登录凭据:"
    log_info "用户名: admin@example.com"
    log_info "密码: admin123"
    log_info "\n请务必在首次登录后修改默认密码!"
}

# 主函数
main() {
    log_info "开始部署AI创意大脑..."
    
    check_prerequisites
    setup_environment
    start_services
    wait_for_services
    setup_n8n_workflows
    show_deployment_info
    
    log_info "部署脚本执行完成!"
}

# 执行主函数
main