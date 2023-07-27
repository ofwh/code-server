# Start from the code-server Debian base image
FROM codercom/code-server:latest

USER root

# Set default version
ARG NODE_VER=18

# Apply VS Code settings
COPY src/settings.json /root/.local/share/code-server/User/settings.json

# Use bash shell
# ENV SHELL=/bin/bash

# Use zsh shell
COPY src/dotfiles /root/
ENV SHELL=/bin/zsh

# Install unzip + rclone (support for remote filesystem)
RUN apt-get update && apt-get install curl wget net-tools neovim unzip -y

# Install python2 for sass
RUN apt-get install python2.7 python-is-python2 -y

# RUN curl https://rclone.org/install.sh | sudo bash

# Install NodeJS
# RUN curl -sL https://deb.nodesource.com/setup_${NODE_VER}.x | sudo bash
# RUN sudo apt-get install -y nodejs

# Install nvm
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | \
    bash
RUN /bin/zsh -c "source $HOME/.nvm/nvm.sh \
    && nvm install 14 \
    && nvm install 16 \
    && nvm install 18 \
    && nvm alias default ${NODE_VER}"

# Fix permissions for code-server
# RUN chown -R root:root ~/.local

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
COPY src/entrypoint.sh /usr/bin/code-server-entrypoint.sh
RUN chmod +x /usr/bin/code-server-entrypoint.sh
ENTRYPOINT ["/usr/bin/code-server-entrypoint.sh"]
