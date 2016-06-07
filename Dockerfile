FROM canopytax/alpine

ENV PYTHONPATH=/app/.pip

RUN apk add --update \
    postgresql-dev gcc python3-dev musl-dev \
    python3 && \
    python3 -m ensurepip && \
    rm -rf /var/cache/apk/*

ONBUILD COPY requirements.txt /app/
ONBUILD RUN python3 -m pip install -r /app/requirements.txt -t /app/.pip
ONBUILD COPY . /app/

WORKDIR /app
CMD ["sh", "startup.sh"]
