FROM ghcr.io/actions/actions-runner:2.329.0

RUN sudo apt update -y && \
  sudo apt install -y curl make bash jq

# Install Node.js 22 and npm 10
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
  sudo apt-get install -y nodejs && \
  sudo npm install -g npm@10
