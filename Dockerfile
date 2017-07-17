FROM canopytax/python-base:latest

ENV VER_PDFTK=2.02

RUN apk add --no-cache -u\
    unzip \
    fastjar \ 
    gcc-java \ 
    g++ \
    wget && \
    wget --no-check-certificate http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-${VER_PDFTK}-src.zip && \
    unzip pdftk-${VER_PDFTK}-src.zip && \
    (cd pdftk-${VER_PDFTK}-dist/pdftk && make -f Makefile.Redhat && make -f Makefile.Redhat install) && \
    rm -rf pdftk-${VER_PDFTK}-dist pdftk-${VER_PDFTK}-src.zip && \
