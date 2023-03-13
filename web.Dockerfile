FROM caddy:2-alpine

WORKDIR /app

COPY /build/web /app

CMD [ "caddy", "file-server" ]