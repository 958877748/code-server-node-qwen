FROM mcr.microsoft.com/devcontainers/universal:linux

# 安装 ttyd 等工具（镜像里已有 zsh、curl、git）
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends ttyd && \
    sudo rm -rf /var/lib/apt/lists/*

# 全局安装 claude-code
RUN sudo npm install -g @anthropic-ai/claude-code

# 默认 shell 已经是 zsh，保险起见再声明一次
ENV SHELL=/bin/zsh

# 暴露端口
EXPOSE 7681 8000

# 启动 ttyd
CMD ["sh", "-c", "ttyd -p 7681 -c \"admin:$TTYD_PWD\" --writable zsh"]
