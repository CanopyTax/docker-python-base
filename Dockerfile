FROM python:3.5-alpine

ENV PYTHONPATH=./.pip:/app/.pip:.: \
    DOCKER=True \
    VER_PDFTK=2.02

RUN apk add --no-cache -u\
    bash \
    postgresql-dev \ 
    gcc \
    make \
    libffi-dev \
    musl-dev \
    musl-utils \
    jpeg-dev \
    freetype \
    freetype-dev \
    unzip \
    fastjar \ 
    gcc-java \ 
    g++ \
    wget && \
    wget --no-check-certificate http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-${VER_PDFTK}-src.zip && \
    unzip pdftk-${VER_PDFTK}-src.zip && \
    (cd pdftk-${VER_PDFTK}-dist/pdftk && make -f Makefile.Redhat && make -f Makefile.Redhat install) && \
    rm -rf pdftk-${VER_PDFTK}-dist pdftk-${VER_PDFTK}-src.zip && \
    python3 -m pip install -U \
        dumb-init \
        pip \
        gunicorn \
        "invoke==0.13.0"\
        alembic \
        pytest \
        pytest-cov \
        pylint \
        psycopg2 \
        flake8 

RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf
ONBUILD RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf
ONBUILD COPY requirements.txt /app/
ONBUILD RUN python3 -m pip install -r /app/requirements.txt -t /app/.pip
ONBUILD COPY . /app/

WORKDIR /app
CMD ["dumb-init", "./startup.sh"]
