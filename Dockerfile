FROM ubuntu-upstart:latest

# MAINTAINER
MAINTAINER Alex

## USER SETTINGS
RUN useradd -m crypto
# RUN usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,netdev crypto
RUN usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev crypto

## AUTHENTICATION SETTINGS
RUN mkdir /home/crypto/.ssh -p
RUN touch /home/crypto/.ssh/authorized_keys
RUN echo '\
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoY6oQ7jkiFbmlVMgStQ/fCqQWjBsa0m/hmreC547CAS3q9zco570aufcCskdyfGfJJYBNQ5sWJJHvo8l4sk1hqdAW1+AkGERseRrnzerhOWEXfESjLAkypZ1Bxf7Sh78czkBsOiXO2i2gxXZlWG/6UPkUnqqaGVvQr6d3QjQ2w2lpoM8utUENKQqu3a6A2CiaGsG1qi5fbSpVfIFxuyaMN7XqsLzt5fCYLu6+3VIbWE5g+VHuZxvIF/PKddpJKx4RiG/Rf9wsJtUXxiUciYkGrh/8WqXIhvf7yiL8YufH1aPPlKsGMtCipSaZdL5mYQhbnPQOqxzKbJ/4Ips1K3df ALEX\
' > /home/crypto/.ssh/authorized_keys
RUN chown crypto.crypto /home/crypto/.ssh/authorized_keys
RUN chmod 600 /home/crypto/.ssh/authorized_keys
RUN chown crypto.crypto /home/crypto/.ssh -R
RUN chmod 700 /home/crypto/.ssh

## APT-GET CHECK
RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

## INSTALL DEFAULT PACKAGES
RUN apt-get install -y\
		build-essential \
		bsdmainutils \
		git-core \
		vim \
		libtool \
		autotools-dev \
		autoconf \
		pkg-config \
		libssl-dev

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y\
		libdb4.8-dev \
		libdb4.8++-dev \
		libboost-all-dev \
		libminiupnpc-dev \
		libevent-dev

## ENVIRONMENTS
ENV APP_NAME 'crypto-env'
ENV PYTHONIOENCODING 'utf8'

# Entry Point.
ADD ./entrypoint.sh /usr/local/bin/
WORKDIR /usr/local/bin
RUN chmod +x entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

RUN echo 'crypto ALL=NOPASSWD: ALL' >> /etc/sudoers

# EXPOSE
EXPOSE 22

## FINALY
USER crypto
WORKDIR /home/crypto


