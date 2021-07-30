FROM centos:centos8

# Required to not have issues with cmake.
# cmake: symbol lookup error: cmake: undefined symbol: archive_write_add_filter_zstd
RUN dnf update -y

# install RPM build tools and assets
# install common build tools (autotools, compilers, parsers etc)
RUN yum -y install \
        rpm-build \
        systemd-rpm-macros \
        autoconf \
        bison \
        flex \
        gcc \
        gcc-c++ \
        libtool \
        make \
        which \
        cmake \
        git \
        openssl-devel \
    && yum clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*


RUN curl -f -L https://static.rust-lang.org/rustup.sh -O \
    && sh rustup.sh -y
ENV PATH="$PATH:/root/.cargo/bin"

RUN echo export RUST_TOOLCHAIN=$(curl -s https://raw.githubusercontent.com/casper-network/casper-node/release-1.3.1/rust-toolchain) >> ~/.rust_env \
    && . ~/.rust_env; rustup toolchain install "${RUST_TOOLCHAIN}" \
    && . ~/.rust_env; rustup toolchain install stable \
    && rustup update \
    && . ~/.rust_env; cargo +${RUST_TOOLCHAIN} install cargo-rpm

RUN BRANCH="1.0.20" \
    && git clone --branch ${BRANCH} https://github.com/WebAssembly/wabt.git "wabt-${BRANCH}" \
    && cd "wabt-${BRANCH}" \
    && git submodule update --init \
    && cd - \
    && cmake -S "wabt-${BRANCH}" -B "wabt-${BRANCH}/build" \
    && cmake --build "wabt-${BRANCH}/build" --parallel 8 \
    && cmake --install "wabt-${BRANCH}/build" --prefix /usr --strip -v \
    && rm -rf "wabt-${BRANCH}"
