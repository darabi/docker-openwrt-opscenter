FROM mcreations/openwrt-x64

# Many thanks to the original author and maintainer of abh1nav/cassandra
# Abhinav Ajgaonkar <abhinav316@gmail.com>

MAINTAINER Kambiz Darabi <darabi@m-creations.net>

ENV OPSCENTER_VERSION 5.1.0

ENV OPSC_HOME /opt/opscenter
ENV OPSCENTER_CONF $OPSC_HOME/conf

ADD image/root /

# Download and extract DataStax OPSCenter, and install python for the tools
RUN mkdir -p ${OPSCENTER_CONF} && \
  wget --progress=dot:giga http://downloads.datastax.com/community/opscenter-${OPSCENTER_VERSION}.tar.gz && \
  tar xzf opscenter-${OPSCENTER_VERSION}.tar.gz -C /tmp && \
  rm opscenter-${OPSCENTER_VERSION}.tar.gz && \
  mv /tmp/opscenter*/* ${OPSC_HOME} && \
  opkg update && \
  opkg install python && \
  rm /tmp/opkg-lists/* && \
  echo "export PATH=$PATH:$OPSC_HOME/bin" >> /etc/profile

# Expose ports
EXPOSE 8888

CMD ["/start-opscenter"]
