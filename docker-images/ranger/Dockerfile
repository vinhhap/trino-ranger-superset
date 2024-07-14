######################################################################
# Ranger Base image...
######################################################################
FROM ubuntu:22.04 AS ranger-base

# Install tzdata, Python, Java, python-requests
RUN apt-get update -y && \
    apt-get install curl -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata vim\
    python3 python3-pip openjdk-17-jdk bc iputils-ping ssh pdsh xmlstarlet && \
    pip3 install apache-ranger && \
    pip3 install requests

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV RANGER_DIST=/home/ranger/dist
ENV RANGER_SCRIPTS=/home/ranger/scripts
ENV RANGER_HOME=/opt/ranger
ENV PATH=/usr/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN update-java-alternatives --set /usr/lib/jvm/java-1.17.0-openjdk-amd64

# setup groups, users, directories
RUN groupadd ranger && \
    useradd -g ranger -ms /bin/bash ranger && \
    useradd -g ranger -ms /bin/bash rangeradmin && \
    useradd -g ranger -ms /bin/bash rangerusersync && \
    useradd -g ranger -ms /bin/bash rangertagsync && \
    useradd -g ranger -ms /bin/bash rangerkms && \
    groupadd hadoop && \
    useradd -g hadoop -ms /bin/bash hdfs && \
    useradd -g hadoop -ms /bin/bash yarn && \
    useradd -g hadoop -ms /bin/bash hive && \
    useradd -g hadoop -ms /bin/bash hbase && \
    useradd -g hadoop -ms /bin/bash kafka && \
    groupadd knox && \
    useradd -g knox -ms /bin/bash knox && \
    mkdir -p /home/ranger/dist && \
    mkdir -p /home/ranger/scripts && \
    chown -R ranger:ranger /home/ranger && \
    mkdir -p /opt/ranger && \
    chown -R ranger:ranger /opt/ranger

ENTRYPOINT [ "/bin/bash" ]

######################################################################
# Ranger-Admin image...
######################################################################
FROM ranger-base AS ranger

ARG RANGER_VERSION=3.0.0-SNAPSHOT

COPY ./scripts/ranger.sh                                         ${RANGER_SCRIPTS}/
COPY ./scripts/ranger-admin-install.properties ${RANGER_SCRIPTS}/ranger-admin-install.properties
COPY ./scripts/create-ranger-services.py                         ${RANGER_SCRIPTS}/

RUN echo ${RANGER_VERSION} >> /home/ranger/dist/version
RUN curl -s -f -L -o /home/ranger/dist/ranger-${RANGER_VERSION}-admin.tar.gz https://github.com/vinhhap/trino-ranger-superset/releases/download/trino-ranger-superset-v1.0/ranger-${RANGER_VERSION}-admin.tar.gz

RUN tar xvfz /home/ranger/dist/ranger-${RANGER_VERSION}-admin.tar.gz --directory=${RANGER_HOME} \
    && ln -s ${RANGER_HOME}/ranger-${RANGER_VERSION}-admin ${RANGER_HOME}/admin \
    && rm -f /home/ranger/dist/ranger-${RANGER_VERSION}-admin.tar.gz \
    && cp -f ${RANGER_SCRIPTS}/ranger-admin-install.properties ${RANGER_HOME}/admin/install.properties \
    && mkdir -p /var/run/ranger \
    && mkdir -p /var/log/ranger \
    && chown -R ranger:ranger ${RANGER_HOME}/admin/ ${RANGER_SCRIPTS}/ /var/run/ranger/ /var/log/ranger/ \
    && mkdir -p /usr/share/java/

RUN curl -s -f -L -o /usr/share/java/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.16.jre7/postgresql-42.2.16.jre7.jar  && \
    curl -s -f -L -o /usr/share/java/mysql-connector.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.20/mysql-connector-java-8.0.20.jar && \
    curl -s -f -L -o ${RANGER_HOME}/admin/ews/webapp/WEB-INF/lib/log4jdbc-1.2.jar https://repo1.maven.org/maven2/com/googlecode/log4jdbc/log4jdbc/1.2/log4jdbc-1.2.jar

USER ranger

ENTRYPOINT [ "/home/ranger/scripts/ranger.sh" ]