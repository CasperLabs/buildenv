# Container for building CasperLabs
# bionic = 18.04
FROM ubuntu:bionic
COPY init-buildenv /tmp/
RUN /tmp/init-buildenv
RUN apt install rsync
RUN apt install locales && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen
ENV LC_ALL en_US.UTF-8
ENV PATH "$PATH:/root/.cargo/bin"
