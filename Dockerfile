FROM docker.io/ubuntu:22.04 AS base

WORKDIR /archi

ARG TZ=UTC

# DL3015 ignored for suppress org.freedesktop.DBus.Error.ServiceUnknown
# hadolint ignore=DL3008,DL3015
# Added support for google cloud cli by following  https://cloud.google.com/sdk/docs/install
RUN set -eux; \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime; \
    echo "$TZ" > /etc/timezone; \
    apt-get update; \
    apt-get install -y \
      ca-certificates \
      libgtk2.0-cil \
      libswt-gtk-4-jni \
      dbus-x11 \
      xvfb \
      curl \
      wget \
      git \
      openssh-client \
      unzip \
      apt-transport-https \ 
      gnupg; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \ 
      tee -a /etc/apt/sources.list.d/google-cloud-sdk.list ; \
    apt-get update; \
    apt-get install -y \
      google-cloud-cli; \      
    apt-get clean; \
    update-ca-certificates; \
    rm -rf /var/lib/apt/lists/*;

# Install fonts - Segoe UI
RUN set -eux; \
    mkdir -p /usr/share/fonts/truetype/segoeui && \
    cd /usr/share/fonts/truetype/segoeui && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/segoeui.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/segoeuib.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/segoeuii.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/segoeuiz.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/segoeuil.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguili.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/segoeuisl.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguisli.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguisb.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguisbi.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguibl.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguibli.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguiemj.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguisym.ttf && \
    wget https://github.com/mrbvrz/segoe-ui-linux/raw/master/font/seguihis.ttf && \
    fc-cache -fv




FROM base AS archi
ARG ARCHI_VERSION=5.4.3

# Download & extract Archimate tool
RUN set -eux; \
    curl -#Lo archi.tgz \
      "https://www.archimatetool.com/downloads/archi/$ARCHI_VERSION/Archi-Linux64-$ARCHI_VERSION.tgz"; \
    tar zxf archi.tgz -C /opt/; \
    rm archi.tgz; \
    chmod +x /opt/Archi/Archi; \
    mkdir -p /root/.archi/dropins /archi/report /archi/project

FROM archi AS coarchi
ARG COARCHI_VERSION=0.9.2

# Download & extract Archimate coArchi plugin
RUN set -eux; \
    curl -#Lo coarchi.zip --request POST \
      "https://www.archimatetool.com/downloads/coarchi/coArchi_$COARCHI_VERSION.archiplugin"; \
    unzip coarchi.zip -d /root/.archi/dropins/ && \
    rm coarchi.zip

FROM coarchi 

#COPY dist/*.jar /root/.archi/dropins/
COPY entrypoint.sh /opt/Archi/

ENTRYPOINT [ "/opt/Archi/entrypoint.sh" ]
