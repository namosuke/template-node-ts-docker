#==================================================
FROM node:20-alpine AS base
WORKDIR /app

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

COPY package.json pnpm-lock.yaml ./
#==================================================
FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile
#==================================================
FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --dev --frozen-lockfile
COPY . .
RUN pnpm run build
#==================================================
FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app

COPY --from=prod-deps --chown=nonroot:nonroot /app/node_modules ./node_modules
COPY --from=build --chown=nonroot:nonroot /app/dist ./dist

USER nonroot

CMD ["dist/index.js"]