FROM ubuntu:18.04

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.22.1.0"
ARG OVERLAY_ARCH="amd64"
ARG DEBIAN_FRONTEND=noninteractive
# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)$ "
ENV TAUTULLI_DOCKER=True
ENV HOME="/root"
ENV TERM="xterm"
ENV TZ=UTC

RUN \
  echo "**** install build packages ****" && \
  apt update && apt upgrade -y
RUN  apt-get install -y \
  g++ \
  gcc \
  libffi-dev \
  python3.8 \
  python3.8-dev \
  tar && \
  echo "**** install runtime packages ****" && \
  apt-get -y install \
  bash \
  python3-pip \
  coreutils \
  curl \
  git \
  openssl \
  tar \
  tzdata \
  vnstat \
  wget && \
  echo "**** install pip packages ****" && \
  pip3 install --no-cache-dir -U \
  pip && \
  pip3 install --no-cache-dir -U \
  plexapi \
  pycryptodomex \
  pytz \
  tzlocal \
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
  vnstat \
  wget && \
  echo "**** install pip packages ****" && \
  pip3 install --no-cache-dir -U \
  pip && \
  pip3 install --no-cache-dir -U \
  plexapi \
  pycryptodomex \
  pytz \
  tzlocal \
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
 # apt del --purge \
#  build-dependencies && \
  rm -rf \
  /root/.cache \
  /tmp/*

# add local files
COPY root/ /
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
 # apt del --purge \
#  build-dependencies && \
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

