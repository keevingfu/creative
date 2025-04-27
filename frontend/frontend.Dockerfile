FROM node:16-alpine

WORKDIR /app

COPY ./frontend/ /app/

RUN npm install

EXPOSE 3000

CMD ["node", "server.js"]
