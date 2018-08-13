FROM erlang:21.0.4-slim
LABEL maintainer="piotr.justyna@gmail.com"

# installing:
# - curl
# - unzip
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y unzip

# installing rebar3
ENV REBAR3_VERSION="3.6.1"
RUN set -xe \
	&& REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
	&& REBAR3_DOWNLOAD_SHA256="40b3c85440f3235c7b149578d0211bdf57d1c66390f888bb771704f8abc71033" \
	&& mkdir -p /usr/src/rebar3-src \
	&& curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
	&& echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
	&& tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
	&& rm rebar3-src.tar.gz \
	&& cd /usr/src/rebar3-src \
	&& HOME=$PWD ./bootstrap \
	&& install -v ./rebar3 /usr/local/bin/ \
    && rm -rf /usr/src/rebar3-src

# pulling foa
RUN mkdir -p /usr/src/foa-src \
    && curl -fSL -o foa-master.zip "https://github.com/PiotrJustyna/foa/archive/master.zip" \
    && unzip foa-master.zip -d /usr/src/foa-src \
    && rm foa-master.zip \
    && cd /usr/src/foa-src/foa-master \
    && rm -rf ./feedback \
    && mkdir feedback \
    && rebar3 edoc