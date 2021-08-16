# Container for debian packaging CasperLabs
# bionic = 18.04
FROM ubuntu:bionic

RUN apt-get update \
    && apt-get install -y curl gnupg gcc git ca-certificates \
              protobuf-compiler libprotobuf-dev unzip \
              pkg-config libssl-dev jq gettext-base python3.6 python3-pip

# toml for publish script
RUN pip3 install toml PyGithub semantic_version

# install cmake
RUN curl -Ls https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3-Linux-x86_64.tar.gz | tar -C /usr/local --strip-components=1 -xz

# Install node.js, npm, and assemblyscript
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get -y install nodejs \
    && npm install --global npm install -g markdown-link-check remark-cli remark-validate-links remark-lint-no-dead-urls "assemblyscript@0.9.1"

RUN curl -f -L https://static.rust-lang.org/rustup.sh -O \
    && sh rustup.sh -y
ENV PATH="$PATH:/root/.cargo/bin"

RUN echo export RUST_TOOLCHAIN=$(curl -s https://raw.githubusercontent.com/CasperLabs/casper-node/master/rust-toolchain) >> ~/.rust_env \
    && . ~/.rust_env; rustup toolchain install "${RUST_TOOLCHAIN}" \
    && . ~/.rust_env; rustup toolchain install stable \
    && rustup update \
    && . ~/.rust_env; cargo +${RUST_TOOLCHAIN} install cargo-deb

RUN git clone https://github.com/CasperLabs/casper-node.git ~/casper-node \
    && cd ~/casper-node \
    && make setup \
    && ~/.cargo/bin/cargo fetch \
    && rm -rf ~/casper-node

RUN BRANCH="1.0.20" \
    && git clone --branch ${BRANCH} https://github.com/WebAssembly/wabt.git "wabt-${BRANCH}" \
    && cd "wabt-${BRANCH}" \
    && git submodule update --init \
    && cd - \
    && cmake -S "wabt-${BRANCH}" -B "wabt-${BRANCH}/build" \
    && cmake --build "wabt-${BRANCH}/build" --parallel 8 \
    && cmake --install "wabt-${BRANCH}/build" --prefix /usr --strip -v \
    && rm -rf "wabt-${BRANCH}"

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install
