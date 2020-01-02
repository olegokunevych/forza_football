FROM elixir:latest

RUN apt-get update -qq && apt-get install -y libpq-dev && apt-get install -y build-essential inotify-tools erlang-dev erlang-parsetools
RUN mix local.hex --force && mix local.rebar --force

WORKDIR /home/app