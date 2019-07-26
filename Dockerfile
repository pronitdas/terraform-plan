FROM node:10-alpine

RUN mkdir -p /home/web-app/ && chown -R node:node /home/web-app/

WORKDIR /home/web-app/

COPY code/backend ./
COPY code/frontend ./

USER node

WORKDIR /home/web-app/frontend

RUN yarn
RUN yarn start
EXPOSE 80

WORKDIR /home/web-app/backend

RUN yarn
RUN yarn dev
EXPOSE 3030













