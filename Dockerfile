FROM node:20-alpine3.18 AS base

ARG PORT
ARG HOST
ENV PORT $PORT
ENV HOST $HOST

ENV DIR /app
WORKDIR $DIR

FROM base AS build

RUN apk update && apk add --no-cache dumb-init=1.2.5-r2

COPY package*.json .
RUN npm ci && \
    rm -f .npmrc

COPY tsconfig*.json .
COPY .swcrc .
COPY src src

RUN npm run build && \
    npm prune --production

FROM base AS production

ENV NODE_ENV=production
ENV USER=node

COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build $DIR/node_modules node_modules
COPY --from=build $DIR/dist dist

USER $USER
EXPOSE $PORT
CMD ["dumb-init", "node", "dist/main.js"]
