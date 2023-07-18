#!/bin/sh
set -eu

# We do this first to ensure sudo works below when renaming the user.
# Otherwise the current container UID may not exist in the passwd database.
eval "$(fixuid -q)"

if [ "${DOCKER_USER-}" ]; then
  USER="$DOCKER_USER"
  if [ "$DOCKER_USER" != "$(whoami)" ]; then
    echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
    # Unfortunately we cannot change $HOME as we cannot move any bind mounts
    # nor can we bind mount $HOME into a new home as that requires a privileged container.
    sudo usermod --login "$DOCKER_USER" coder
    sudo groupmod -n "$DOCKER_USER" coder

    sudo sed -i "/coder/d" /etc/sudoers.d/nopasswd
  fi
fi

# Allow users to have scripts run on container startup to prepare workspace.
# https://github.com/coder/code-server/issues/5177
if [ -d "${ENTRYPOINTD}" ]; then
  find "${ENTRYPOINTD}" -type f -executable -print -exec {} \;
fi

# # Custom extensions
# /usr/bin/code-server --install-extension esbenp.prettier-vscode
# /usr/bin/code-server --install-extension formulahendry.auto-close-tag
# /usr/bin/code-server --install-extension formulahendry.auto-rename-tag
# /usr/bin/code-server --install-extension mgmcdermott.vscode-language-babel
# /usr/bin/code-server --install-extension michelemelluso.code-beautifier
# /usr/bin/code-server --install-extension aaron-bond.better-comments
# /usr/bin/code-server --install-extension formulahendry.code-runner
# /usr/bin/code-server --install-extension streetsidesoftware.code-spell-checker
# /usr/bin/code-server --install-extension dbaeumer.vscode-eslint
# /usr/bin/code-server --install-extension mhutchie.git-graph
# /usr/bin/code-server --install-extension eamodio.gitlens
# /usr/bin/code-server --install-extension wix.vscode-import-cost
# /usr/bin/code-server --install-extension yzhang.markdown-all-in-one
# /usr/bin/code-server --install-extension zhuangtongfa.material-theme
# /usr/bin/code-server --install-extension esbenp.prettier-vscode
# /usr/bin/code-server --install-extension yoavbls.pretty-ts-errors
# /usr/bin/code-server --install-extension richie5um2.vscode-sort-json
# /usr/bin/code-server --install-extension bradlc.vscode-tailwindcss
# /usr/bin/code-server --install-extension wayou.vscode-todo-highlight
# /usr/bin/code-server --install-extension Vue.vscode-typescript-vue-plugin
# /usr/bin/code-server --install-extension vscode-icons-team.vscode-icons
# /usr/bin/code-server --install-extension Vue.volar

exec dumb-init /usr/bin/code-server "$@" --disable-telemetry