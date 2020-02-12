# Container for building CasperLabs
# bionic = 18.04
FROM ubuntu:bionic

RUN apt update

RUN apt install -y apt-transport-https \
                    ca-certificates curl gnupg \
                    lsb-release software-properties-common \
                    rpm equivs gcc

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

RUN echo export RUST_TOOLCHAIN=$(curl -s https://raw.githubusercontent.com/CasperLabs/CasperLabs/dev/execution-engine/rust-toolchain) >> ~/.rust_env

RUN . ~/.rust_env; rustup toolchain install "${RUST_TOOLCHAIN}"
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
              protobuf-compiler libprotobuf-dev cmake python3 python3-pip \
              docker-ce rpm fakeroot lintian nodejs rsync locales

RUN apt clean

# add link checker plugins to npm
RUN npm install --global remark-cli remark-validate-links remark-lint-no-dead-urls "assemblyscript@0.9.1"

# p2p-test-tool.py
RUN pip3 install argparse docker pexpect requests
# integration-testing/
RUN pip3 install docker pytest delayed_assert

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen

COPY cl_dependencies.sh /tmp/

RUN /tmp/cl_dependencies.sh

ENV LC_ALL en_US.UTF-8

ADD bintray/ /opt/bintray/
