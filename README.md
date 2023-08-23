# Code-Server

自用的 Code Server 镜像

```sh
docker build -t luoweihua7/code-server:latest .
``

也可以指定默认的Node版本

```sh
NODE_VER=16
docker build --progress=plain -t luoweihua7/code-server:node-v${NODE_VER} --build-arg NODE_VER=${NODE_VER} .
```
