FROM canopytax/alpine

ENV PYTHONPATH=./.pip:/app/.pip:.: \
    DOCKER=True    

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --no-cache -u\
    postgresql-dev \ 
    musl-utils \
    musl-dev \
    jpeg-dev \
    freetype-dev \
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

ONBUILD COPY requirements.txt /app/
ONBUILD RUN python3 -m pip install -r /app/requirements.txt -t /app/.pip
ONBUILD COPY . /app/

WORKDIR /app
CMD ["dumb-init", "./startup.sh"]
