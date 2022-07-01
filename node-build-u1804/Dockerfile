# Container for debian packaging CasperLabs
# bionic = 18.04
FROM ubuntu:bionic

# Installing ca-certificates and updating again as work around for nodejs certificate issue.
RUN apt-get update ; apt-get install ca-certificates ; \
    apt-get update \
    && apt-get install -y curl gnupg gcc git \
              protobuf-compiler libprotobuf-dev unzip \
              pkg-config libssl-dev jq gettext-base \
              python3.6 python3-pip lsof clang locales

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# toml for publish script
RUN pip3 install toml PyGithub semantic_version tomlkit

# install cmake
RUN curl -Ls https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3-Linux-x86_64.tar.gz | tar -C /usr/local --strip-components=1 -xz

# Install node.js, npm, and assemblyscript
# Downgrading npm to 8.5.5
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get -y install nodejs \
    && npm install --global markdown-link-check remark-cli remark-validate-links remark-lint-no-dead-urls "assemblyscript@0.17.14" \
    && npm install -g npm@8.5.5

RUN python3 -m pip install supervisor toml

ENV PATH="$PATH:/root/.cargo/bin"
RUN curl -f -L https://static.rust-lang.org/rustup.sh -O \
    && sh rustup.sh -y \
    && rustup update \
    && rustup toolchain install stable \
    && cargo install cargo-deb \
    && cargo install cargo-audit \
    && cargo install cargo-rpm \
    && cargo install cargo-criterion \
    && cargo install --git https://github.com/paritytech/cachepot --branch master

RUN git clone https://github.com/casper-network/casper-node.git ~/casper-node \
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
