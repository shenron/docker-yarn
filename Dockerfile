FROM node:8-alpine as build

RUN apk update \
  && apk add curl bash binutils tar \
  && rm -rf /var/cache/apk/* \
  && /bin/bash \
  && touch ~/.bashrc \
  && curl -o- -L https://yarnpkg.com/install.sh | bash

FROM node:8-alpine

COPY --from=build /opt/yarn* /opt

COPY --from=build /usr/local/bin/yarn /usr/local/bin/yarn

WORKDIR /home/node/app
