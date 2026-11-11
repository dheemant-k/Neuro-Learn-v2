# syntax=docker/dockerfile:1
# NeuroLearn web app — Vite build → nginx, which also proxies /api to the backend.

FROM node:22-alpine AS build
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
# Same-origin by default (nginx proxies /api). For a separate API host, pass
# --build-arg VITE_API_BASE=https://api.example.com/api (baked in at build time).
ARG VITE_API_BASE=/api
ENV VITE_API_BASE=$VITE_API_BASE
RUN npm run build

FROM nginx:1.27-alpine
# nginx's entrypoint fills ${API_UPSTREAM} into the template at start-up.
ENV API_UPSTREAM=http://backend:8080
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /src/dist /usr/share/nginx/html
EXPOSE 80
