FROM codercom/code-server:latest

# 用 root 装你要的东西
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
# 拷贝原始 entrypoint 脚本，并在开头插入权限修复代码
RUN cp /usr/bin/entrypoint.sh /usr/bin/entrypoint-with-fix.sh && \
    sed -i '2i\
# ---- Fix /home/coder permissions ----\n\
if [ "$(stat -c "%u" /home/coder)" != "1000" ]; then\n\
  echo "[fix] Fixing permissions for /home/coder..."\n\
  chown -R coder:coder /home/coder\n\
fi\n\
# ---- End fix ----' /usr/bin/entrypoint-with-fix.sh && \
    chmod +x /usr/bin/entrypoint-with-fix.sh

# 直接用这个带修复功能的入口脚本
ENTRYPOINT ["/usr/bin/entrypoint-with-fix.sh"]
