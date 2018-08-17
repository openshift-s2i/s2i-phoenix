FROM openshift/base-centos7

ARG ERLANG_VERSION=21.0
ARG ELIXIR_VERSION=1.7.2
ARG NODE_VERSION=8.11.2
ARG NPM_VERSION=6.2.0
ENV ERLANG_VERSION ${ERLANG_VERSION}
ENV ELIXIR_VERSION ${ELIXIR_VERSION}
ENV NODE_VERSION ${NODE_VERSION}
ENV NPM_VERSION ${NPM_VERSION}

LABEL io.k8s.description="Platform for building and running a phoenix app" \
      io.k8s.display-name="build-phoenix" \
      io.openshift.expose-services="4000:http" \
      io.openshift.tags="builder,elixir,phoenix" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      name="primemodule/s2i-phoenix" \
      maintainer="Marcin Wieprzkowicz <marcin.wieprzkowicz@gmail.com>" \
      version="$ELIXIR_VERSION"

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

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

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
  && git clone -b v${ELIXIR_VERSION} https://github.com/elixir-lang/elixir.git \
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
RUN set -x \
  && cd /opt/ \
  && curl -LO https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz \
  && tar --strip-components 1 -xf node-v${NODE_VERSION}-linux-x64.tar.xz -C /usr/local \
  && rm -rf node-v${NODE_VERSION}-linux-x64.tar.xz

ENV LANG en_US.UTF-8

# Copy the S2I scripts from the image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER 1001

# Expose the default port
EXPOSE 4000

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
