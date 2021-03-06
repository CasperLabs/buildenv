# Container for building CasperLabs
# bionic = 18.04
FROM ubuntu:bionic

RUN apt update

RUN apt install -y apt-transport-https \
                    ca-certificates curl gnupg \
                    lsb-release software-properties-common \
                    rpm equivs gcc

RUN apt update

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN echo 'deb https://dl.bintray.com/sbt/debian /' >/etc/apt/sources.list.d/sbt.list

RUN APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key adv \
                --keyserver hkp://keyserver.ubuntu.com \
                --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

RUN apt update

# install docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN curl -f -L https://static.rust-lang.org/rustup.sh -O
RUN sh rustup.sh -y
ENV PATH="$PATH:/root/.cargo/bin"

RUN echo export RUST_TOOLCHAIN=$(curl -s https://raw.githubusercontent.com/CasperLabs/casper-node/master/rust-toolchain) >> ~/.rust_env

RUN . ~/.rust_env; rustup toolchain install "${RUST_TOOLCHAIN}"
RUN . ~/.rust_env; rustup toolchain install stable
RUN rustup update
RUN . ~/.rust_env; cargo +${RUST_TOOLCHAIN} install cargo-rpm
RUN . ~/.rust_env; cargo +${RUST_TOOLCHAIN} install cargo-deb

# utilities for debugging
# build dependencies
# integration tests
# packaging
RUN apt -y install \
              curl moreutils netcat-openbsd nmap openssh-server psmisc screen socat tmux wget \
              java-common jflex openjdk-11-jdk-headless openjdk-8-jdk-headless sbt=1.\* \
              protobuf-compiler libprotobuf-dev \
              python3.7 libpython3.7-dev python3-pip python3.8 libpython3.8-dev \
              docker-ce rpm fakeroot lintian nodejs rsync locales libssl-dev pkg-config jq \
              gettext-base

RUN apt clean

# install cmake
run curl -Ls https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3-Linux-x86_64.tar.gz | tar -C /usr/local --strip-components=1 -xz

# add link checker plugins to npm
RUN npm install --global remark-cli remark-validate-links remark-lint-no-dead-urls "assemblyscript@0.9.1"

# add yarn to npm
RUN npm install --global yarn
# install lerna by yarn
RUN yarn global add lerna

# p2p-test-tool.py
RUN pip3 install argparse docker pexpect requests
# integration-testing/
RUN pip3 install docker delayed_assert pipenv pytest typing_extensions grpcio grpcio_tools protobuf in-place ed25519 pyblake2 lz4

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen

ENV LC_ALL en_US.UTF-8

ADD bintray/ /opt/bintray/
