# ISC License
#
# Copyright (c) 2019-present, Mykhailo Stadnyk <mikhus@gmail.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
############### 1. BUILD STAGE ###############
FROM node:lts-alpine AS build

RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY package*.json ./
RUN npm set progress=false ; npm i -g pkg && npm i --unsafe-perm

COPY . .
RUN npm run build

############### 2. COMPRESS STAGE ##############
FROM mikhus/alpine-gzexe:latest AS compress

ARG APP_NAME
ENV APP_NAME $APP_NAME

COPY --from=build /opt/app/${APP_NAME} /opt

RUN gzexe /opt/${APP_NAME}

############### 3. RELEASE STAGE ###############
FROM alpine:latest AS release

ARG APP_NAME
ENV APP_NAME $APP_NAME
ENV USER=docker
ENV UID=1111
ENV GID=1111

RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER" && \
    apk update && apk add --no-cache libstdc++ && \
    rm -rf /var/cache/apk/*

USER docker

COPY --from=compress /opt/${APP_NAME} /bin
COPY --from=compress /bin/gzip /bin
COPY --from=compress /bin/gzexe /bin

CMD $APP_NAME
