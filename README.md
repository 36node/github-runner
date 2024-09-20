# github-runner

这是 36node 团队通用 github runner

## build 指令

```sh
docker buildx build --platform=linux/amd64 --push -t harbor.36node.com/common/actions-runner:latest .
```

## 包含以下软件

- curl
- go v1.20
- make
- nodejs v20
- pnpm v9

## customize

- 如果是通用的需求，可以给本工程发 PR。
- 如果有特殊的需要，可以从这个镜像或者原始镜像开始重新写一个。