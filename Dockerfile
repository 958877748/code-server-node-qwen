FROM mcr.microsoft.com/devcontainers/universal:linux

# 安装 code-server 和插件 cline
RUN curl -fsSL https://code-server.dev/install.sh | sh

# 安装常用工具
RUN apt-get update && apt-get install -y git wget unzip


# 安装 Claude Code
RUN npm install -g @anthropic-ai/claude-code

# 安装 Claude Code Router
RUN npm install -g @musistudio/claude-code-router

# 安装 Qwen-code
# RUN npm install -g @qwen-code/qwen-code@latest

# 设置语言环境
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8

# 创建 code-server 配置（root 用户路径）
RUN mkdir -p /root/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080\n\
auth: password\n\
password: ${PASSWORD}\n\
cert: false" > /root/.config/code-server/config.yaml

# 暴露端口
EXPOSE 8080
EXPOSE 9000

# 启动 code-server（现在不用 --allow-root）
CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]
