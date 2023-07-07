# Start from the code-server Debian base image
FROM codercom/code-server:latest

USER coder

ARG NODE_VER=16

# Apply VS Code settings
COPY src/settings.json .local/share/code-server/User/settings.json

# Use bash shell
# ENV SHELL=/bin/bash

# Use zsh shell
COPY src/dotfiles ./
ENV SHELL=/bin/zsh

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install curl wget net-tools neovim unzip -y
# RUN curl https://rclone.org/install.sh | sudo bash
# install NodeJS 14
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VER}.x | sudo bash
RUN sudo apt-get install -y nodejs

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
RUN code-server --install-extension \
  esbenp.prettier-vscode \
  formulahendry.auto-close-tag \
  formulahendry.auto-rename-tag \
  mgmcdermott.vscode-language-babel \
  michelemelluso.code-beautifier \
  aaron-bond.better-comments \
  formulahendry.code-runner \
  streetsidesoftware.code-spell-checker \
  dbaeumer.vscode-eslint \
  mhutchie.git-graph \
  eamodio.gitlens \
  wix.vscode-import-cost \
  yzhang.markdown-all-in-one \
  zhuangtongfa.material-theme \
  esbenp.prettier-vscode \
  yoavbls.pretty-ts-errors \
  richie5um2.vscode-sort-json \
  bradlc.vscode-tailwindcss \
  wayou.vscode-todo-highlight \
  Vue.vscode-typescript-vue-plugin \
  vscode-icons-team.vscode-icons \
  Vue.volar

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY src/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
RUN sudo chmod +x /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
