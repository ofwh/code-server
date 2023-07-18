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

# Install python2 for sass
RUN sudo apt-get install python2.7 python-is-python2 -y

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
# RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension formulahendry.auto-close-tag
RUN code-server --install-extension formulahendry.auto-rename-tag
RUN code-server --install-extension mgmcdermott.vscode-language-babel
RUN code-server --install-extension michelemelluso.code-beautifier
RUN code-server --install-extension aaron-bond.better-comments
RUN code-server --install-extension formulahendry.code-runner
RUN code-server --install-extension streetsidesoftware.code-spell-checker
RUN code-server --install-extension dbaeumer.vscode-eslint
RUN code-server --install-extension mhutchie.git-graph
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension wix.vscode-import-cost
RUN code-server --install-extension yzhang.markdown-all-in-one
RUN code-server --install-extension zhuangtongfa.material-theme
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension yoavbls.pretty-ts-errors
RUN code-server --install-extension richie5um2.vscode-sort-json
RUN code-server --install-extension bradlc.vscode-tailwindcss
RUN code-server --install-extension wayou.vscode-todo-highlight
RUN code-server --install-extension Vue.vscode-typescript-vue-plugin
RUN code-server --install-extension vscode-icons-team.vscode-icons
RUN code-server --install-extension Vue.volar

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
