FROM elixir:latest

RUN apt-get update && \
    apt-get install -y postgresql-client

# RUN mkdir /app
# COPY . /app
# WORKDIR /app

# RUN mix local.hex --force
# RUN mix deps.get
# RUN mix local.rebar --force
# RUN mix do compile

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mkdir /app

COPY . /app
WORKDIR /app

RUN mix do deps.clean ranch, deps.get, deps.compile

CMD ["/app/entrypoint.sh"]
