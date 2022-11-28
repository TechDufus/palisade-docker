FROM node:latest

RUN apt update
RUN apt install -y git

ENV NODE_OPTIONS=--openssl-legacy-provider

WORKDIR /app

RUN git clone https://github.com/compound-finance/palisade.git

WORKDIR /app/palisade
COPY production.json config/env/production.json
COPY development.json config/env/development.json

RUN yarn install --lock-file --ignore-platform
RUN yarn add -W caniuse-lite --ignore-platform
RUN npm install caniuse-lite -g
RUN npx --yes update-browserslist-db; exit 0
RUN npm install -g create-elm-app
RUN yarn run i18n
RUN yarn run build-css
RUN yarn run build

CMD ["yarn", "start"]
