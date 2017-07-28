FROM node:8.2

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies and tools
RUN apt-get update; \
    apt-get install -y apt-utils apt-transport-https; \
    apt-get install -y curl wget; \
    apt-get install -y libnss-mdns avahi-discover libavahi-compat-libdnssd-dev libkrb5-dev; \
    apt-get install -y nano vim mc

# Install latest Homebridge
# -------------------------------------------------------------------------
# You can force a specific version by setting HOMEBRIDGE_VERSION
# See https://github.com/marcoraddatz/homebridge-docker#homebridge_version
RUN npm config set registry http://registry.npmjs.org; \
    npm install -g node-gyp; \
    npm install -g homebridge --unsafe-perm; \
    npm install -g homebridge-openremote --unsafe-perm; \
    npm install homebridge-server@latest -g --unsafe-perm; \
    npm install -g homebridge-vera --unsafe-perm; \
    npm install polling-to-event --unsafe-perm; \
    npm install debug --unsafe-perm; \
    npm install create-hash --unsafe-perm; \
    npm install request --unsafe-perm; \
    npm install request-promise --unsafe-perm; \
    npm install node-persist --unsafe-perm; \
    npm install hap-nodejs --unsafe-perm; \
    npm install prompt --unsafe-perm; \
    npm install async --unsafe-perm 
    
# Final settings
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf

USER root
RUN mkdir -p /var/run/dbus

ADD image/run.sh /root/run.sh

# Run container
EXPOSE 5353 51826 8080 8765
CMD ["/root/run.sh"]
