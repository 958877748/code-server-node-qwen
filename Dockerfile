
FROM mcr.microsoft.com/devcontainers/universal:linux

# 安装 code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh 

# 安装 ssh 服务、git、wget 等工具
RUN apt-get update && apt-get install -y git wget unzip

# 安装 Qwen-code 依赖（如果不需要可以删掉）
RUN npm install -g @qwen-code/qwen-code@latest

# 设置语言环境，命令行支持中文
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8

# 创建 code-server 配置文件（root 用户的配置路径）
RUN mkdir -p /root/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080\n\
auth: password\n\
password: myStrongPass123!\n\
cert: false" > /root/.config/code-server/config.yaml

# 暴露 code-server 访问端口
EXPOSE 8080

# 容器启动时执行 code-server（root + --allow-root）
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--allow-root"]
