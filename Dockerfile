FROM canopytax/alpine

ENV PYTHONPATH=./.pip:/app/.pip:.: \
    DOCKER=True    

RUN apk add --no-cache -u\
    postgresql-dev \ 
    musl-utils \
    musl-dev \
    jpeg-dev \
    gcc \
    make \
    ca-certificates \
    libffi-dev \
    python3-dev \
    python3 && \
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

# add dependencies for pdf2svg
RUN  apk add --no-cache -u \
        inkscape

ONBUILD COPY requirements.txt /app/
ONBUILD RUN python3 -m pip install -r /app/requirements.txt -t /app/.pip
ONBUILD COPY . /app/

WORKDIR /app
CMD ["dumb-init", "./startup.sh"]
