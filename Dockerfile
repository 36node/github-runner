FROM ghcr.io/actions/actions-runner:2.338.2

RUN sudo apt update -y && \
  sudo apt install -y curl make bash jq

# Install Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
  sudo apt-get install -y nodejs

# Install pnpm globally and disable Corepack (avoid Corepack downloading pnpm on every CI run)
RUN sudo corepack disable && \
  sudo npm install -g pnpm@10.28.1 && \
  sudo mkdir -p /home/runner/.npm /home/runner/.config /home/runner/.cache && \
  sudo chown -R runner:runner /home/runner/.npm /home/runner/.config /home/runner/.cache

# Install Playwright system dependencies (for Chromium)
# 只装 OS 级依赖（libglib, libnss, libatk 等），不装浏览器二进制
# 浏览器二进制由各项目 CI 中 `playwright install chromium` 按版本安装
RUN npx -y playwright install-deps chromium

# Install MinIO Client (for CI cache)
# dl.min.io 已停止分发社区版 mc（返回 410），改用 GitHub release 固定版本并校验 sha256
ARG MC_VERSION=RELEASE.2025-08-13T08-35-41Z
ARG MC_SHA256=01f866e9c5f9b87c2b09116fa5d7c06695b106242d829a8bb32990c00312e891
RUN curl -fsSL "https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.linux-amd64.${MC_VERSION}" -o mc && \
  echo "${MC_SHA256}  mc" | sha256sum -c - && \
  chmod a+x mc && \
  sudo mv mc /usr/local/bin/

# Install Docker Buildx and setup builder
RUN BUILDX_VERSION=$(curl -s "https://api.github.com/repos/docker/buildx/releases/latest" | jq -r .tag_name) && \
  curl -L "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" -o docker-buildx && \
  chmod a+x docker-buildx && \
  mkdir -p /home/runner/.docker/cli-plugins && \
  mv docker-buildx /home/runner/.docker/cli-plugins/ && \
  chown -R runner:runner /home/runner/.docker && \
  chmod -R 755 /home/runner/.docker
