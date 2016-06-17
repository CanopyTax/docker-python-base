FROM canopytax/alpine

ENV PYTHONPATH=/app/.pip

RUN apk add --update \
    postgresql-dev \ 
    gcc \
    libffi-dev \
    python3-dev \
    musl-dev \
    linux-headers \
    python3 && \
    python3 -m ensurepip && \
    python3 -m pip install dumb-init && \
    python3 -m pip install gunicorn && \
    rm -rf /var/cache/apk/*

ONBUILD COPY requirements.txt /app/
ONBUILD RUN python3 -m pip install -r /app/requirements.txt -t /app/.pip
ONBUILD COPY . /app/

WORKDIR /app
CMD ["dumb-init", "./startup.sh"]
