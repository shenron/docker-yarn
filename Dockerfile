FROM node:10-alpine as build

ENV YARN_VERSION=1.12.3

RUN apk update \
  && apk add tzdata curl bash binutils tar \
  && rm -rf /var/cache/apk/* \
  && /bin/bash \
  && curl https://yarnpkg.com/install.sh --output install.sh \
  && bash ./install.sh --version ${YARN_VERSION}

FROM node:10-alpine

RUN apk update \
  && apk add \
    tzdata \
    git \
  && cp /usr/share/zoneinfo/America/New_York /etc/localtime

# flow-bin is broken by default with alpine
# https://github.com/sgerrand/alpine-pkg-glibc
RUN apk --no-cache add ca-certificates wget &&\
wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub &&\
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk &&\
apk add glibc-2.28-r0.apk

COPY --from=build /root/.yarn /home/node/.yarn

RUN chown -R node:node /home/node/.yarn

RUN mkdir -p /home/node/app
RUN chown -R node:node /home/node/app

USER node:node

ENV PATH="/home/node/.yarn/bin:${PATH}"

CMD yarn

WORKDIR /home/node/app
