# Container for debian packaging CasperLabs
# focal = 20.04
FROM ubuntu:focal

# DEBIAN_FRONTEND required for tzdata dependency install
RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" \
        apt-get install -y \
              curl gnupg gcc git \
              protobuf-compiler libprotobuf-dev unzip \
              pkg-config libssl-dev jq gettext-base \
              python3.7 python3-pip lsof clang locales \
              net-tools cmake \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# toml for publish script
RUN pip3 install toml tomlkit supervisor psutil requests

# Install node.js, npm, and assemblyscript
# Downgrading npm to 8.5.5
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get -y install nodejs \
    && npm install --global remark-cli "assemblyscript@0.17.14" "npm@8.5.5"

ENV PATH="$PATH:/root/.cargo/bin"
RUN curl -f -L https://static.rust-lang.org/rustup.sh -O \
    && sh rustup.sh -y \
    && rustup update \
    && rustup toolchain install stable \
    && cargo install cargo-deb \
    && cargo install cargo-audit \
    && cargo install cargo-rpm \
    && cargo install --git https://github.com/paritytech/cachepot --branch master

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