ARG TRINO_VERSION=451
FROM trinodb/trino:${TRINO_VERSION}

USER root

ARG TRINO_PLUGIN_VERSION=3.0.0-SNAPSHOT

ENV PLUGIN_DIR=ranger-${TRINO_PLUGIN_VERSION}-trino-plugin
ENV IS_COORDINATOR=false

RUN mkdir -p /home/ranger/dist /opt/ranger/ranger-trino-plugin

RUN chown -R "root:root" /data/trino && \
    chown -R "root:root" /usr/bin/trino && \
    chown -R "root:root" /usr/lib/trino && \
    chown -R "root:root" /etc/trino

RUN microdnf install -y gzip

RUN echo $TRINO_PLUGIN_VERSION >> /home/ranger/dist/version
RUN curl -s -f -L -o /home/ranger/dist/${PLUGIN_DIR}.tar.gz https://github.com/vinhhap/trino-ranger-superset/releases/download/trino-ranger-superset-v1.0/ranger-${TRINO_PLUGIN_VERSION}-trino-plugin.tar.gz

RUN tar xvfz /home/ranger/dist/${PLUGIN_DIR}.tar.gz --directory=/tmp/ && \
    cp -R /tmp/${PLUGIN_DIR}/* /opt/ranger/ranger-trino-plugin && \
    rm /home/ranger/dist/${PLUGIN_DIR}.tar.gz && \
    rm -rf /tmp/${PLUGIN_DIR}/

RUN chown "root:root" /opt/ranger/ranger-trino-plugin/* 

COPY ./scripts/ranger-trino-plugin-install.properties /opt/ranger/ranger-trino-plugin/install.properties
COPY ./scripts/entrypoint-trino.sh /opt/ranger/ranger-trino-plugin/

RUN chmod +x /opt/ranger/ranger-trino-plugin/entrypoint-trino.sh && \
    chmod +x /opt/ranger/ranger-trino-plugin/enable-trino-plugin.sh

ENTRYPOINT [ "/bin/sh", "-c", "/opt/ranger/ranger-trino-plugin/entrypoint-trino.sh" ]