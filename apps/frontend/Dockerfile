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
RUN turbo prune frontend --docker

# Add lockfile and package.json's of isolated subworkspace
FROM base AS installer
RUN apk update
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Build the project
COPY --from=builder /app/out/full/ .
COPY --from=builder /app/apps/frontend/.env /app/apps/frontend/.env
RUN npm install
RUN npm run build

FROM base AS runner
WORKDIR /app

# Don't run production as root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
# COPY --from=installer --chown=nextjs:nodejs /app/apps/frontend/.next/standalone ./
# COPY --from=installer --chown=nextjs:nodejs /app/apps/frontend/.next/static ./apps/frontend/.next/static
# COPY --from=installer --chown=nextjs:nodejs /app/apps/frontend/public ./apps/frontend/public

COPY --from=installer --chown=nextjs:nodejs /app .

WORKDIR /app/apps/frontend

CMD npm run start