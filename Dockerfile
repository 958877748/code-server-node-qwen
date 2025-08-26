FROM mcr.microsoft.com/devcontainers/universal:linux

# 使用 apt 安装所需软件（非交互模式）
RUN apt-get update && \
    apt-get install -y --no-install-recommends zsh curl git ttyd && \
    rm -rf /var/lib/apt/lists/*

# 安装 oh-my-zsh（非交互模式）
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 全局安装 claude-code
RUN npm install -g @anthropic-ai/claude-code

# 设置默认 shell 为 zsh
ENV SHELL=/bin/zsh

# 暴露端口
EXPOSE 7681 8000

# 启动 ttyd 并运行 zsh
CMD ["ttyd", "-p", "7681", "--writable", "zsh"]
