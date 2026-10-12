FROM ubuntu:noble

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    vim \
    gdb-multiarch \
    gcc-arm-linux-gnueabihf \
    binutils-arm-linux-gnueabihf \
    libc6-dev-armhf-cross \
    gcc-arm-linux-gnueabi \
    qemu-user \
    qemu-system-arm \
    make \
    git \
    ca-certificates \
    strace \
    ltrace \
    zsh \
    xxd \
    curl \
    tree \
    python3 \
    unzip \
    build-essential \
    python3-virtualenv \
    strace \
    software-properties-common \
    binutils-arm-linux-gnueabihf \
    && rm -rf /var/lib/apt/lists/*
    

RUN mkdir -p /lib/arm/2.27/lib/ /usr/lib/arm-linux-gnueabihf/
RUN ln -s /usr/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 /lib/arm/2.27/lib/ld-linux.so.3
RUN ln -s /usr/arm-linux-gnueabihf/lib/libc.so.6  /usr/lib/arm-linux-gnueabihf/libc.so.6
RUN ln -s /usr/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

WORKDIR /software
RUN python3 -m virtualenv venv/ && . ./venv/bin/activate && python3 -m pip install --upgrade unicorn udbserver pwntools ropper
RUN echo "source /software/venv/bin/activate" >> /root/.bashrc
RUN echo "source /software/venv/bin/activate" >> /root/.zshrc

WORKDIR /workspace

EXPOSE 1234
