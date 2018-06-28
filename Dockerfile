FROM ubuntu:xenial

MAINTAINER Alex

RUN bash
# apt-get init
RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
RUN apt-get update

# user settings
RUN useradd -m crypto
RUN apt-get install sudo
RUN echo 'crypto ALL=NOPASSWD: ALL' >> /etc/sudoers

# apt-get installs
RUN apt-get install -y\
	build-essential \
	libtool \
	autotools-dev \
	automake \
	pkg-config \
	libssl-dev \
	libevent-dev \
	bsdmainutils \
	python3 \
	libboost-system-dev \
	libboost-filesystem-dev \
	libboost-chrono-dev \
	libboost-program-options-dev \
	libboost-test-dev \
	libboost-thread-dev
RUN apt-get install -y python-pip
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y\
    libdb4.8-dev \
    libdb4.8++-dev
    # libminiupnpc-dev \

#pip install
RUN pip install --upgrade pip
RUN pip install virtualenv

# ports
# EXPOSE

# apt cache clear
USER root
RUN rm -rf /var/lib/apt/lists/*

# entrypoint
WORKDIR /usr/local/bin
ADD entrypoint.sh /usr/local/bin/
RUN chmod +x entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# env
ENV APP_NAME 'crypto-env'
ENV PYTHONIOENCODING 'utf8'

# final
USER crypto
WORKDIR /home/crypto