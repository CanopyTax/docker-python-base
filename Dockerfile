FROM canopytax/alpine

ENV PYTHONPATH=./.pip:/app/.pip:.: \
    DOCKER=True    

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --no-cache -u\
    postgresql-dev \ 
    musl-utils \
    musl-dev \
    jpeg-dev \
    gcc \
    make \
    ca-certificates \
    libffi-dev \
    python3-dev \
    python3@edge && \
    python3 -m ensurepip && \
    python3 -m pip install -U \
        dumb-init \
        pip \
        gunicorn \
        invoke \
        alembic \
        pytest \
        pytest-cov \
        pylint \
        psycopg2 \
        flake8

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \ 
    apk add --no-cache -u \
        curl \
        py-cairo \
        cairo-tools \
        cairo-dev \
        py-cairo-dev \
        poppler-dev && \
    apk --no-cache -u add $(apk search --no-cache -q ttf-) && \
    curl -0L https://github.com/dawbarton/pdf2svg/archive/v0.2.3.tar.gz > t.tgz && \
    tar -zxf t.tgz && \
    cd pdf2svg-0.2.3 && \
    ./configure --prefix=/usr/local && \
    make && make install && \
    cd /app

ONBUILD COPY requirements.txt /app/
ONBUILD RUN python3 -m pip install -r /app/requirements.txt -t /app/.pip
ONBUILD COPY . /app/

WORKDIR /app
CMD ["dumb-init", "./startup.sh"]
