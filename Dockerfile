# See versions here: https://hub.docker.com/_/ubuntu/
FROM debian:stable-slim

ARG BUILD_CONTEXT_DIR="unknown"
ARG BUILD_DATE="unknown"
ARG BUILD_HOST="unknown"
ARG SVN_VERSION="unknown"

LABEL local.build_context_dir="$BUILD_CONTEXT_DIR"
LABEL local.build_host="$BUILD_HOST"
LABEL local.svn_version="$SVN_VERSION"
LABEL org.opencontainers.image.created="$BUILD_DATE"
LABEL org.opencontainers.image.version="$SVN_VERSION"

RUN apt-get update && apt-get install -y \
    subversion \
    sasl2-bin

#RUN useradd svn

COPY app/.bash_aliases /root

EXPOSE 3690
VOLUME /svn

CMD ["svnserve", "-d", "--foreground", "-r", "/svn", "--listen-port", "3690", "--log-file", "/var/log/svn.log"]