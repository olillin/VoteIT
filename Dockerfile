ARG NODE_VERSION=24-alpine
LABEL org.opencontainers.image.authors="digIT"

FROM node:${NODE_VERSION}

# Install pnpm
RUN yarn global add pnpm

# Install dependencies using pnpm
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=pnpm-lock.yaml,target=pnpm-lock.yaml \
    --mount=type=bind,source=gulpfile.js,target=gulpfile.js \
    --mount=type=cache,target=/pnpm/store \
    pnpm install --prod --frozen-lockfile



# From here we load our application's code in, therefore the previous docker
# "layer" thats been cached will be used if possible
WORKDIR /opt/app
COPY . /opt/app

# Run the application as a non-root user.
RUN chown -R node:node /usr/src/app
USER node

EXPOSE 3000

CMD ["node", "app.js"]
