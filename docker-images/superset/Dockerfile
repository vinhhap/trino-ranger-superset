ARG TAG=4.0.2

FROM apache/superset:${TAG}

USER root

COPY ./requirements.txt /app/

RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt

USER superset