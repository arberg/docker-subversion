ARG BASE_IMAGE=debian:stable-slim
FROM ${BASE_IMAGE}

# We have to re-import ARG-value after FROM, for LABEL below. But its DRY.
ARG BASE_IMAGE

ARG BUILD_CONTEXT_DIR="unknown"
ARG BUILD_DATE="unknown"
ARG BUILD_HOST="unknown"
ARG SVN_VERSION="unknown"
ARG OS_NAME="unknown"
ARG OS_VERSION="unknown"
ARG OS_CODENAME="unknown"

LABEL local.base_image="$BASE_IMAGE"
LABEL local.build_context_dir="$BUILD_CONTEXT_DIR"
LABEL local.build_host="$BUILD_HOST"
LABEL local.os_name="$OS_NAME"
LABEL local.os_version="$OS_VERSION"
LABEL local.os_codename="$OS_CODENAME"
LABEL org.opencontainers.image.created="$BUILD_DATE"
LABEL org.opencontainers.image.version="$SVN_VERSION"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      subversion \
      sasl2-bin \
 && rm -rf /var/lib/apt/lists/*

COPY app/.bash_aliases /root

EXPOSE 3690
VOLUME ["/svn"]

CMD ["svnserve", "-d", "--foreground", "-r", "/svn", "--listen-port", "3690", "--log-file", "/var/log/svn.log"]