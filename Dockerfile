FROM ghcr.io/actions/actions-runner:2.329.0

RUN sudo apt update -y && \
  sudo apt install -y curl make bash jq

# Install Node.js 22 and npm 10
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
  sudo apt-get install -y nodejs && \
  sudo npm install -g npm@10

# Install Docker Buildx
RUN BUILDX_VERSION=$(curl -s "https://api.github.com/repos/docker/buildx/releases/latest" | jq -r .tag_name) && \
  curl -L "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" -o docker-buildx && \
  chmod a+x docker-buildx && \
  sudo mkdir -p ~/.docker/cli-plugins && \
  sudo mv docker-buildx ~/.docker/cli-plugins/
