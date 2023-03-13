# Build
FROM plugfox/flutter:stable AS build

WORKDIR /

COPY . .

RUN [ "flutter", "pub", "get" ]
RUN [ "flutter", "build", "web" ]

# Run
FROM caddy:2-alpine

WORKDIR /app

COPY --from=build /build/web .

CMD [ "caddy", "file-server" ]