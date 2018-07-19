FROM alpine:latest

RUN apk add --no-cache \
     git \
     gmp \
     make \
     libstdc++ \
     openblas \
     python3 \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools

RUN apk add --no-cache --virtual=.build-deps \
     binutils \
     file \
     g++ \
     gfortran \
     gmp-dev \
     musl-dev \
     openblas-dev \
     python3-dev \
    && ln -s locale.h /usr/include/xlocale.h \
    && pip3 install \
     numpy \
     pandas \
    && find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + \
    && find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; \
    && rm -r \
     /root/.cache \
     /usr/include/xlocale.h \
    && apk del .build-deps
