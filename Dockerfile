# Temporary container for building BNFC
FROM haskell:8 as bnfc-build
ARG BNFC_COMMIT=ce7fe1fd08d9d808c14ff626c321218c5b73e38b
WORKDIR /var/tmp/bnfc
COPY build-bnfc /tmp/
RUN /tmp/build-bnfc

# Container for building RChain
# bionic = 18.04
FROM ubuntu:bionic
COPY --from=bnfc-build /var/tmp/bnfc/_build/bnfc /usr/local/bin/
COPY init-buildenv /tmp/
RUN /tmp/init-buildenv
COPY smtp.rchain.me.crt /usr/local/share/ca-certificates
RUN update-ca-certificates
RUN apt install rsync
RUN apt install locales && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen
ENV LC_ALL en_US.UTF-8
