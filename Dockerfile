FROM codercom/code-server:latest

USER root
RUN apt update && apt install -y build-essential nano curl \
    && rm -rf /var/lib/apt/lists/*

USER coder
RUN curl -L https://git.io/n-install | bash -s -- -y lts latest

SHELL ["/bin/bash", "-c"]
RUN PATH+=":$HOME/n/bin" && \
    curl -o- -L https://yarnpkg.com/install.sh | bash

RUN PATH+=":$HOME/n/bin" && \
    npm install -g @qwen-code/qwen-code@latest

RUN git config --global credential.helper cache && git config --global core.editor "nano"

USER root
# 直接生成一个新 entrypoint 脚本
RUN cat <<'EOF' > /usr/bin/entrypoint-with-fix.sh
#!/usr/bin/bash
set -e
# 修复权限
if [ "$(stat -c "%u" /home/coder)" != "1000" ]; then
  echo "[fix] Fixing permissions for /home/coder..."
  chown -R coder:coder /home/coder
fi
# 调用原始入口逻辑
exec /usr/bin/entrypoint.sh "$@"
EOF

RUN chmod +x /usr/bin/entrypoint-with-fix.sh

ENTRYPOINT ["/usr/bin/entrypoint-with-fix.sh"]
