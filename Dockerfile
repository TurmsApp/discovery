FROM elixir:1.15-slim AS build

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix do deps.get, deps.compile

COPY . .

RUN mix release

FROM alpine:3.18 AS app

COPY --from=build /app/_build/prod/rel/iris ./

ENV MIX_ENV=prod

EXPOSE 4000

CMD ["bin/iris", "start"]
