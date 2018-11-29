FROM node:10-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . .
RUN yarn install
EXPOSE 3000
ENV PORT=3000
ENV PROD=true
CMD [ "yarn", "production" ]