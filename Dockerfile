FROM ghcr.io/actions/actions-runner:2.331.0

RUN sudo apt update -y && \
  sudo apt install -y curl make bash jq

# Install Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
  sudo apt-get install -y nodejs

# Install pnpm 10 using corepack (skip interactive prompts)
RUN sudo corepack enable && \
  sudo corepack prepare pnpm@10.20.0 --activate && \
  sudo mkdir -p /home/runner/.npm /home/runner/.config /home/runner/.cache && \
  sudo chown -R runner:runner /home/runner/.npm /home/runner/.config /home/runner/.cache && \
  # Trigger actual pnpm download without prompts
  COREPACK_ENABLE_DOWNLOAD_PROMPT=0 pnpm --version

# Install Playwright system dependencies (for Chromium)
# 只装 OS 级依赖（libglib, libnss, libatk 等），不装浏览器二进制
# 浏览器二进制由各项目 CI 中 `playwright install chromium` 按版本安装
RUN npx -y playwright install-deps chromium

# Install MinIO Client (for CI cache)
RUN curl -fsSL https://dl.min.io/client/mc/release/linux-amd64/mc -o mc && \
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
