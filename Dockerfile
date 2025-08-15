
FROM codercom/code-server:latest

RUN echo "Dockerfile   ===========>   start   set /home/coder/data to coder"
USER root
RUN chown -R coder:coder /home/coder/data
USER coder
RUN echo "Dockerfile   ===========>   end"

RUN sudo apt update
RUN sudo apt install -y build-essential nano

# Install "n", the node.js version manager
RUN curl -L https://git.io/n-install | bash -s -- -y lts

# This is needed for the PATH line to work
SHELL ["/bin/bash", "-c"]

# Install yarn, which is an alternative to npm
RUN PATH+=":$HOME/n/bin" && \
    curl -o- -L https://yarnpkg.com/install.sh | bash

# Install qwen-code globally
RUN PATH+=":$HOME/n/bin" && \
    npm install -g @qwen-code/qwen-code@latest

# Cache your git password for 15 minutes, so you don't have to enter it for every push
RUN git config --global credential.helper cache && git config --global core.editor "nano"
