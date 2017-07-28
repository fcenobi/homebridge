FROM node:7.10

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies and tools
RUN apt-get update; \
    apt-get install -y apt-utils apt-transport-https; \
    apt-get install -y curl wget; \
    apt-get install -y libnss-mdns avahi-discover libavahi-compat-libdnssd-dev libkrb5-dev; \
    apt-get install -y nano vim

# Install latest Homebridge
# -------------------------------------------------------------------------
# You can force a specific version by setting HOMEBRIDGE_VERSION
# See https://github.com/marcoraddatz/homebridge-docker#homebridge_version
RUN npm install -g homebridge --unsafe-perm
RUN npm install -g homebridge-openremote --unsafe-perm
RUN npm install homebridge-server@latest -g --unsafe-perm
RUN npm install -g homebridge-vera --unsafe-perm

# Final settings
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf

USER root
RUN mkdir -p /var/run/dbus

ADD image/run.sh /root/run.sh
ADD samples/config.json /root/.homebridge/config.json
ADD samples/.env /root/.homebridge/.env
ADD samples/install.sh /root/.homebridge/install.sh
ADD samples/package.json /root/.homebridge/package.json

# Run container
EXPOSE 5353 51826 8080 8765
CMD ["/root/run.sh"]
