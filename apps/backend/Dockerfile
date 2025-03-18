FROM node:22-alpine AS base

FROM base AS builder
RUN apk update
RUN apk add --no-cache libc6-compat
# Set working directory
WORKDIR /app

RUN npm install -g turbo
COPY . .

# Generate a partial monorepo with a pruned lockfile for a target workspace.
# RUN npx turbo run generate
RUN turbo prune backend --docker

# Add lockfile and package.json's of isolated subworkspace
FROM base AS installer
RUN apk update
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Build the project
COPY --from=builder /app/out/full/ .
COPY --from=builder /app/apps/backend/.env /app/apps/backend/.env
RUN npm install
RUN npm run build

FROM base AS runner
WORKDIR /app

# Don't run production as root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nestjs
USER nestjs

COPY --from=installer --chown=nestjs:nodejs /app .

WORKDIR /app/apps/backend

CMD npm run start