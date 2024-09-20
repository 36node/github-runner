FROM ghcr.io/actions/actions-runner:latest

RUN sudo apt update -y && \
  sudo apt install -y curl make && \
  # Install Go
  curl -fsSL https://golang.org/dl/go1.20.9.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf - && \
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && \
  source ~/.bashrc && \
  # Install Node.js (using NodeSource official script for nodejs 20)
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
  sudo apt install -y nodejs && \
  # Install pnpm version 9
  npm install -g pnpm@9 && \
  # Verify installations
  go version && \
  make --version && \
  node -v && \
  npm -v && \
  pnpm -v