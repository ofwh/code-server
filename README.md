# Code-Server

自用的 Code Server 镜像

```sh
NODE_VER=16
docker build -t luoweihua7/code-server:node-v${NODE_VER} .
docker build -t luoweihua7/code-server:node-v${NODE_VER} --build-arg NODE_VER=${NODE_VER} .
```
