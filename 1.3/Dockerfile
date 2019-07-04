FROM openshift/base-centos7

ARG ERLANG_VERSION=18.3
ARG ELIXIR_VERSION=1.3.3
ARG NODE_VERSION=6.7.0
ARG NPM_VERSION=3.10.3
ENV ERLANG_VERSION ${ERLANG_VERSION}
ENV ELIXIR_VERSION ${ELIXIR_VERSION}
ENV NODE_VERSION ${NODE_VERSION}
ENV NPM_VERSION ${NPM_VERSION}

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
  && curl -LO http://erlang.org/download/otp_src_${ERLANG_VERSION}.tar.gz \
  && tar xf otp_src_${ERLANG_VERSION}.tar.gz \
  && rm -rf otp_src_${ERLANG_VERSION}.tar.gz \
  && cd otp_src_${ERLANG_VERSION} \
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
  && rm -rf otp_src_${ERLANG_VERSION}

# Install Elixir
RUN set -x \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
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
  && git clone -b v${ELIXIR_VERSION} https://github.com/elixir-lang/elixir.git \
  && cd elixir \
  && export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
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
RUN set -x \
  && cd /opt/ \
  && curl -LO https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz \
  && tar --strip-components 1 -xf node-v${NODE_VERSION}-linux-x64.tar.xz -C /usr/local \
  && rm -rf node-v${NODE_VERSION}-linux-x64.tar.xz

ENV LANG en_US.UTF-8

COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 4000

CMD ["/usr/libexec/s2i/usage"]

ARG git_version
LABEL io.openshift.builder-version=${git_version}
