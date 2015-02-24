FROM mcreations/openwrt-x64

MAINTAINER Kambiz Darabi <darabi@m-creations.net>

ENV OPSCENTER_VERSION 5.1.0

ENV OPSC_HOME /opt/opscenter
ENV OPSCENTER_CONF $OPSC_HOME/conf

ADD image/root /

# Download and extract DataStax OPSCenter, and install python for the tools
# Note that we remove the embedded twisted in favor of the openwrt package
# which has the same version and .so files which are compiled for uclibc
RUN mkdir -p ${OPSCENTER_CONF} && \
  wget --progress=dot:giga http://downloads.datastax.com/community/opscenter-${OPSCENTER_VERSION}.tar.gz && \
  tar xzf opscenter-${OPSCENTER_VERSION}.tar.gz -C /tmp && \
  rm opscenter-${OPSCENTER_VERSION}.tar.gz && \
  mv /tmp/opscenter*/* ${OPSC_HOME} && \
  rm -rf ${OPSC_HOME}/lib/py-debian && \
  rm -rf ${OPSC_HOME}/lib/py-osx && \
  rm -rf ${OPSC_HOME}/lib/py-redhat && \
  rm -rf ${OPSC_HOME}/lib/py-win32 && \
  rm -rf ${OPSC_HOME}/lib/py-unpure/twisted && \
  rm -rf ${OPSC_HOME}/lib/py-unpure/zope && \
  opkg update && \
  opkg install python twisted twisted-web twisted-runner twisted-names twisted-mail twisted-lore twisted-conch && \
  rm /tmp/opkg-lists/* && \
  echo "export PATH=$PATH:$OPSC_HOME/bin" >> /etc/profile

# Expose ports
EXPOSE 8888

CMD ["/start-opscenter"]
