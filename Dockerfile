FROM rust:1.92.0-slim-bookworm

LABEL "name"="Automate publishing Rust build artifacts for GitHub releases through GitHub Actions"
LABEL "version"="latest"
LABEL "repository"="http://github.com/BruskaTech/rust-build.action"
LABEL "maintainer"="Douile <25043847+Douile@users.noreply.github.com>"

RUN apt-get update

# Add regular dependencies
RUN apt-get install -y curl jq git build-essential bash zip tar xz-utils zstd

# Add windows dependencies
RUN apt-get install -y mingw-w64

# Add apple dependencies
RUN apt-get install -y clang cmake libxml2-dev libssl-dev musl-dev bsdmainutils
RUN git clone https://github.com/tpoechtrager/osxcross /opt/osxcross
RUN curl -Lo /opt/osxcross/tarballs/MacOSX10.10.sdk.tar.xz "https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz"
RUN ["/bin/bash", "-c", "cd /opt/osxcross && UNATTENDED=yes OSX_VERSION_MIN=10.8 ./build.sh"]

COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh
COPY common.sh /common.sh

RUN chmod 555 /entrypoint.sh /build.sh /common.sh

ENTRYPOINT ["/entrypoint.sh"]
