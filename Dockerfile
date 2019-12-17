FROM ubuntu:18.04

ENV RISCV=/opt/riscv
ENV PATH=$RISCV/bin:$PATH
WORKDIR $RISCV

RUN apt-get update
RUN apt-get install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential \
  bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
RUN apt-get install -y git
RUN git clone https://github.com/riscv/riscv-gnu-toolchain
WORKDIR $RISCV/riscv-gnu-toolchain
RUN git submodule update --init --recursive
RUN ./configure --prefix=/opt/riscv --with-arch=rv32im --with-abi=ilp32 --enable-multilib
RUN make -j4

RUN apt-get update && apt-get install -y gosu
WORKDIR /usr/local/bin
COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh
WORKDIR /work
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
