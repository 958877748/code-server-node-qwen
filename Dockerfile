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
RUN printf '#!/bin/bash\nset -e\n\
echo "[fix] Checking /home/coder permissions..."\n\
if [ "$(stat -c "%u" /home/coder)" != "1000" ]; then\n\
  echo "[fix] Fixing permissions for /home/coder..."\n\
  chown -R coder:coder /home/coder\n\
fi\n\
exec /usr/bin/entrypoint.sh "$@"\n' \
> /usr/local/bin/fix-perms-entrypoint.sh \
    && chmod +x /usr/local/bin/fix-perms-entrypoint.sh \
    && ls -l /usr/local/bin/fix-perms-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/fix-perms-entrypoint.sh"]
