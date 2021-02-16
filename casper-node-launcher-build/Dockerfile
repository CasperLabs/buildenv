# Container for debian packaging CasperLabs
# bionic = 18.04
FROM ubuntu:bionic

RUN apt-get update \
    && apt-get install -y curl gnupg gcc git ca-certificates \
              pkg-config libssl-dev jq gettext-base python3.6 python3-pip

# toml for publish script
RUN pip3 install toml

# install cmake
RUN curl -Ls https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3-Linux-x86_64.tar.gz | tar -C /usr/local --strip-components=1 -xz

RUN curl -f -L https://static.rust-lang.org/rustup.sh -O \
    && sh rustup.sh -y
ENV PATH="$PATH:/root/.cargo/bin"

RUN rustup toolchain install stable \
    && rustup update \
    && cargo +stable install cargo-deb \
    && cargo +stable install cargo-audit
