FROM codercom/code-server:latest

USER root
# 安装依赖
RUN apt update && apt install -y build-essential nano curl \
    && rm -rf /var/lib/apt/lists/*

USER coder
# 安装 n
RUN curl -L https://git.io/n-install | bash -s -- -y lts latest

SHELL ["/bin/bash", "-c"]

# 安装 yarn
RUN PATH+=":$HOME/n/bin" && \
    curl -o- -L https://yarnpkg.com/install.sh | bash

# 安装 qwen-code
RUN PATH+=":$HOME/n/bin" && \
    npm install -g @qwen-code/qwen-code@latest

# Git 配置
RUN git config --global credential.helper cache && git config --global core.editor "nano"

USER root
# 修权限 + 启动的入口脚本
RUN printf '#!/bin/bash\n\
set -e\n\
echo "[fix] Checking /home/coder permissions..."\n\
if [ "$(stat -c "%u" /home/coder)" != "1000" ]; then\n\
  echo "[fix] Fixing permissions for /home/coder..."\n\
  chown -R coder:coder /home/coder\n\
fi\n\
echo "[fix] Starting code-server as coder..."\n\
exec sudo -E -u coder /usr/bin/entrypoint.sh "$@"\n' \
> /usr/local/bin/fix-perms-entrypoint.sh \
    && chmod +x /usr/local/bin/fix-perms-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/fix-perms-entrypoint.sh"]
