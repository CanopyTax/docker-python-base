FROM canopytax/alpine

RUN apk add --update \
    postgresql-dev \ 
    gcc \
    ca-certificates \
    libffi-dev \
    python3-dev \
    musl-dev \
    linux-headers \
    python3 && \
    python3 -m ensurepip && \
    python3 -m pip install dumb-init pip gunicorn invoke && \
    rm -rf /var/cache/apk/*

ONBUILD COPY requirements.txt /app/
ONBUILD RUN python3 -m pip install -r /app/requirements.txt
ONBUILD COPY . /app/

WORKDIR /app
CMD ["dumb-init", "./startup.sh"]
