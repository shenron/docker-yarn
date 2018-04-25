FROM node:8-alpine as build

ENV YARN_VERSION=1.6.0

RUN apk update \
  && apk add tzdata curl bash binutils tar \
  && rm -rf /var/cache/apk/* \
  && /bin/bash \
  && curl https://yarnpkg.com/install.sh --output install.sh \
  && bash ./install.sh --version ${YARN_VERSION}

FROM node:8-alpine

RUN apk update \
  && apk add tzdata \
  && cp /usr/share/zoneinfo/America/New_York /etc/localtime

USER node:node

COPY --from=build /root/.yarn /home/node/.yarn

ENV PATH="/home/node/.yarn/bin:${PATH}"

CMD yarn

WORKDIR /home/node/app
