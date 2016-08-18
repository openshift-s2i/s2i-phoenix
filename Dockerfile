FROM openshift/base-centos7

ENV ERLANG_VERSION 18.3
ENV ELIXIR_VERSION 1.3.1
ENV NODE_VERSION v6.3.0
ENV NPM_VERSION 3.6.0

LABEL io.k8s.description="Platform for building and running a phoenix app" \
      io.k8s.display-name="build-phoenix" \
      io.openshift.expose-services="4000:http" \
      io.openshift.tags="builder,elixir,phoenix"

# Install Erlang
RUN set -x \
  && yum install -y --setopt=tsflags=nodocs \
    autoconf \
    epel-release \
    gcc \
    gcc-c++ \
    git \
    glibc-devel \
    java-1.8.0-openjdk-devel \
    make \
    ncurses-devel \
    openssl-devel \
    wxBase \
  && curl -LO http://erlang.org/download/otp_src_18.3.tar.gz \
  && tar xf otp_src_18.3.tar.gz \
  && rm -rf otp_src_18.3.tar.gz \
  && cd otp_src_18.3 \
  && export ERL_TOP=`pwd` \
  && ./configure \
  && make \
  && make release_tests \
  && make install \
  && yum remove -y \
    autoconf \
    epel-release \
    gcc \
    gcc-c++ \
    git \
    glibc-devel \
    java-1.8.0-openjdk-devel \
    make \
    ncurses-devel \
    openssl-devel \
    wxBase \
  && yum clean all -y \
  && cd .. \
  && rm -rf otp_src_18.3

# Install Elixir
RUN set -x \
  && yum install -y --setopt=tsflags=nodocs \
    autoconf \
    epel-release \
    gcc \
    gcc-c++ \
    git \
    glibc-devel \
    make \
    ncurses-devel \
    openssl-devel \
    wxBase \
  && git clone -b v1.3.1 https://github.com/elixir-lang/elixir.git \
  && cd elixir \
  && export LANG=en_US.utf8 \
  && make clean test \
  && make install \
  && yum remove -y \
    autoconf \
    epel-release \
    gcc-c++ \
    java-1.8.0-openjdk-devel \
    ncurses-devel \
    openssl-devel \
    wxBase \
  && yum clean all -y \
  && cd .. \
  && rm -rf elixir

# Install node/npm
RUN cd /opt/ \
  && curl -LO https://nodejs.org/dist/v6.3.0/node-v6.3.0-linux-x64.tar.xz \
  && tar xf node-v6.3.0-linux-x64.tar.xz \
  && rm -rf node-v6.3.0-linux-x64.tar.xz

ENV LANG en_US.UTF-8

COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 4000

CMD ["/usr/libexec/s2i/usage"]
