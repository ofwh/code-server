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

# Set git safe directory
/usr/bin/git config --global --add safe.directory "*"
/usr/bin/git config --global pull.rebase true

# Install extensions
extensions="\
  formulahendry.auto-close-tag \
  formulahendry.auto-rename-tag \
  mgmcdermott.vscode-language-babel \
  aaron-bond.better-comments \
  formulahendry.code-runner \
  streetsidesoftware.code-spell-checker \
  dbaeumer.vscode-eslint \
  eamodio.gitlens \
  mhutchie.git-graph \
  donjayamanne.githistory \
  wix.vscode-import-cost \
  yzhang.markdown-all-in-one \
  esbenp.prettier-vscode \
  richie5um2.vscode-sort-json \
  bradlc.vscode-tailwindcss \
  zhuangtongfa.material-theme \
  PKief.material-icon-theme \
  Vue.volar \
  redhat.vscode-yaml \
  ms-azuretools.vscode-containers \
  usernamehw.errorlens \
  Prisma.prisma \
  yy0931.vscode-sqlite3-editor \
"

for ext in $extensions; do
  [ -n "$ext" ] && /usr/bin/code-server --install-extension "$ext"
done

# Start server
exec dumb-init /usr/bin/code-server "$@"
