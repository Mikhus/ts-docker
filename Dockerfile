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

ENV PATH /opt/app/node_modules/.bin:$PATH

RUN mkdir -p /opt/app

WORKDIR /opt/app

COPY package*.json ./
RUN npm set progress=false ; npm i --unsafe-perm --production

COPY . .
RUN npm run build

############### 2. RELEASE STAGE ###############
FROM alpine:latest AS release

RUN apk update && apk add --no-cache libstdc++ && rm -rf /var/cache/apk/*

ARG APP_NAME
ENV APP_NAME $APP_NAME

COPY --from=build /opt/app/${APP_NAME} /bin

CMD $APP_NAME
