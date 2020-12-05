# Base Node image
FROM node:erbium AS base
WORKDIR /app

FROM base AS dependencies
COPY package*.json ./
RUN npm install

FROM dependencies AS build
WORKDIR /app
COPY src /app/src
COPY tsconfig*.json /app/
RUN npm run build

FROM node:erbium-alpine AS release
WORKDIR /app
COPY --from=dependencies  /app/package.json ./
RUN npm install --only=production
COPY --from=build /app/dist ./
EXPOSE 4000
CMD ["node", "main"]