FROM alpine:3.10

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.22.1.0"
ARG OVERLAY_ARCH="amd64"

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)$ "
ENV TAUTULLI_DOCKER=True
ENV HOME="/root"
ENV TERM="xterm"
ENV TZ=UTC

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
  autoconf \
  automake \
  curl \
  g++ \
  gcc \
  libffi-dev \
  linux-headers \
  make \
  openssl-dev \
  python2-dev \
  tar && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
  bash \
  coreutils \
  curl \
  git \
  libffi \
  openssl \
  py2-lxml \
  py2-pip \
  python2 \
  shadow \
  tar \
  tzdata \
  vnstat \
  wget && \
  echo "**** install pip packages ****" && \
  pip install --no-cache-dir -U \
  pip && \
  pip install --no-cache-dir -U \
  plexapi \
  pycryptodomex \
  pytz \
  tzlocal \
  Queue \
  pip-tools \
  CherryPy \
  Mako \
  arrow \
  portend \
  APScheduler \
  configobj \
  urllib3 \
  passlib \
  requests \
  pywin32 \
  infi.systray \
  oauthlib \
  xmltodict \
  websocket-client \
  geoip2 \
  pyjwt \
  logutils \
  maxminddb \
  cloudinary \
  facebook-sdk \
  python-twitter \
  ipwhois \
  IPy \
  bs4 \
  feedparser \
  httpagentparser \
  bleach \
  paho-mqtt \
  gntp \
  PyNMA \
  profilehooks \
  distro \
  pyopenssl && \
  echo "**** add s6 overlay ****" && \
  curl -o \
  /tmp/s6-overlay.tar.gz -L \
  "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
  tar xfz \
  /tmp/s6-overlay.tar.gz -C / && \
  echo "**** create abc user and make folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p \
  /app \
  /config \
  /defaults && \
  echo "**** cleanup ****" && \
  apk del --purge \
  build-dependencies && \
  rm -rf \
  /root/.cache \
  /tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/init"]

# ports and volumes
VOLUME /config /plex_logs
EXPOSE 8181
HEALTHCHECK  --start-period=90s CMD curl -ILfSs http://localhost:8181/status > /dev/null || curl -ILfkSs https://localhost:8181/status > /dev/null || exit 1
