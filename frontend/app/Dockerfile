FROM node:14 as build
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY ./ /app/
RUN npm install -g @angular/cli@14.2.11
RUN npm install -g webpack@5.74.0
RUN npm link webpack

RUN npm run build --prod --configuration=prod


FROM nginx:1.23.3-alpine 

RUN touch /run/nginx.pid && chown -R 1000:1000 /run/nginx.pid

RUN chown -R 1000:1000 /var/cache/nginx

USER 1000

COPY --from=build /app/dist/letscodebyada-app /usr/share/nginx/html
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf

EXPOSE 5000
CMD ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]