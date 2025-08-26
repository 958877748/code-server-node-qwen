FROM node:20.17.0-alpine

# 安装 zsh、curl、git 和 ttyd
RUN apk add --no-cache zsh curl git ttyd

# 安装 oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 全局安装 @anthropic-ai/claude-code
RUN npm install -g @anthropic-ai/claude-code

# 设置默认 shell 为 zsh
ENV SHELL=/bin/zsh

# 暴露 ttyd 默认端口
EXPOSE 7681 8000

# 启动 ttyd 并运行 zsh（添加 --writable 参数）
CMD ["ttyd", "-p", "7681", "--writable", "zsh"]
