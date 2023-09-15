# Code-Server

自用的 Code Server 镜像，每日构建

---

# 使用

Docker 镜像启动参数以 [coder/code-server](https://github.com/coder/code-server) 为准。

启动脚本示例（特别注意替换密码 `YOUR_PASSWORD_HERE`，如果不需要请删除对应环境参数）

```sh
mkdir -p /data/workspace
mkdir -p /data/docker/vscode/.config
chmod 777 -R /data/docker/vscode
chmod 777 -R /data/workspace

docker run -d \
 --restart always \
 --name vscode \
 --privileged \
 -v /data/workspace:/root/workspace:rw \
 -v /data/docker/vscode:/root/.config:rw \
 -v $HOME/.ssh:/root/.ssh \
 -v $HOME/.gitdir:/root/.gitdir \
 -e PASSWORD=YOUR_PASSWORD_HERE \
 -e TZ=Asia/Shanghai \
 -e PUID=$(id -u ${USER}) \
 -e PGID=$(id -g ${USER}) \
 luoweihua7/code-server:latest \
 /root/workspace \
 --bind-addr 0.0.0.0:8080
```

部分本地参数说明

> 仓库代码： `/data/workspace`<br>
> 配置映射：`/data/docker/vscode`<br>
> SSH密钥：`$HOME/.ssh`<br>
> GIT配置：`$HOME/.gitdir`


GIT公共配置放置在镜像的 `/root/.gitconfig` 文件中，使用的文件为 [.gitconfig](./src/dotfiles/.gitconfig)<br>
使用 **includeIf** 引用 `/root/.gitdir/github.gitconfig` 以解决每次更新镜像后都需要重复配置 name/email 的问题

---

# 手动构建

```sh
docker build -t luoweihua7/code-server:latest .
```

也可以指定默认的Node版本

```sh
NODE_VER=16
docker build --progress=plain -t luoweihua7/code-server:node-v${NODE_VER} --build-arg NODE_VER=${NODE_VER} .
```