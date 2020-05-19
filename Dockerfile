FROM node:10.16.3 AS builder

ARG app_key=EUM-AAB-AUA
ARG adrum_http=http://cdn.appdynamics.com
ARG adrum_https=https://cdn.appdynamics.com
ARG beacon_http=http://4513nosshcontrolle-wbbrumspa-avak3ulj.srv.ravcloud.com:7001
ARG beacon_https=https://4513nosshcontrolle-wbbrumspa-avak3ulj.srv.ravcloud.com:7002 

RUN npm config set user 0 && npm config set unsafe-perm true
RUN npm cache clean --force
RUN npm install -g @oracle/ojet-cli
RUN npm install -g @oracle/oraclejet-tooling
RUN mkdir -p /root/FixItFast
ADD app /root/FixItFast

WORKDIR /root/FixItFast

RUN sed -i "s|##APP_KEY##|${app_key}|g" ./src/index.html
RUN sed -i "s|##ADRUM_HTTP##|${adrum_http}|g" ./src/index.html
RUN sed -i "s|##ADRUM_HTTPS##|${adrum_https}|g" ./src/index.html
RUN sed -i "s|##BEACON_HTTP##|${beacon_http}|g" ./src/index.html
RUN sed -i "s|##BEACON_HTTPS##|${beacon_https}|g" ./src/index.html

RUN ojet add sass
RUN ojet build web --theme=fif:ios --release

FROM httpd:2.4
COPY --from=builder /root/FixItFast/web /usr/local/apache2/htdocs


