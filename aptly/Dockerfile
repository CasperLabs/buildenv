FROM ubuntu:18.04
#GPG needed to add key
RUN apt-get update -qq && apt-get install -y \
    gnupg2 curl jq unzip less;

RUN echo "deb http://repo.aptly.info/ squeeze main" | tee -a /etc/apt/sources.list.d/aptly.list

RUN curl -O https://www.aptly.info/pubkey.txt && apt-key add pubkey.txt && rm pubkey.txt

RUN apt-get update -qq && apt-get install -y \
    aptly;

RUN aptly repo create -distribution=bionic -component=main release

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip && ./aws/install

ADD run.sh /bin/

RUN chmod +x /bin/run.sh

ENTRYPOINT /bin/run.sh
