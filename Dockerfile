FROM mcr.microsoft.com/devcontainers/universal:linux



ENV ANTHROPIC_BASE_URL=https://api-inference.modelscope.cn
ENV ANTHROPIC_MODEL=Qwen/Qwen3-Coder-480B-A35B-Instruct
ENV ANTHROPIC_SMALL_FAST_MODEL=Qwen/Qwen3-Coder-30B-A3B-Instruct
# ANTHROPIC_AUTH_TOKEN 需要在运行容器时传入

# 克隆项目
RUN git clone https://github.com/siteboon/claudecodeui.git

# 设置工作目录
WORKDIR /claudecodeui

# 复制删除脚本到容器中
COPY RemoveSonnetModel.js ./

# 进入项目目录并删除Sonnet模型代码
RUN node RemoveSonnetModel.js

# 安装依赖
RUN npm ci

# 构建生产版本
RUN npm run build

RUN sudo npm install -g @anthropic-ai/claude-code

EXPOSE 3001 8000

ENV NODE_ENV=production

# 启动应用（启动server）
CMD ["npm", "run", "server"]
