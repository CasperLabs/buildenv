FROM node:12.5.0-stretch-slim

RUN apt-get update && apt-get install -y --no-install-recommends git make && \
    curl -sSL https://get.docker.com/ | sh && \
    npm install --global npm@latest \ 
    npm install --global yarn && \
    yarn global add lerna
