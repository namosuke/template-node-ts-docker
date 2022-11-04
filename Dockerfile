FROM node:18-alpine3.16 as builder
ENV NODE_ENV development

WORKDIR /app

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini

COPY package.json yarn.lock ./
RUN yarn install --dev --frozen-lockfile
COPY . .
RUN yarn build
RUN yarn install --prod --frozen-lockfile

FROM gcr.io/distroless/nodejs:18
ENV NODE_ENV production

WORKDIR /app

COPY --from=builder --chown=nonroot:nonroot /tini /tini
COPY --from=builder --chown=nonroot:nonroot /app/node_modules ./node_modules
COPY --from=builder --chown=nonroot:nonroot /app/dist ./dist
COPY --chown=nonroot:nonroot . .

USER nonroot

ENTRYPOINT [ "/tini", "--", "/nodejs/bin/node" ]
CMD ["-r", "dotenv/config", "/app/dist/index.js"]