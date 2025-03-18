FROM node:22-alpine AS base

WORKDIR /app

RUN npm install -g turbo

COPY ./apps/frontend ./apps/frontend
COPY ./packages ./packages
COPY package.json .
COPY turbo.json .

RUN npm install

RUN npx turbo run generate
CMD npx turbo run dev