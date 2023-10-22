FROM hexpm/elixir:1.15.4-erlang-26.0.2-alpine-3.18.2 as build

RUN apk add --update --no-cache npm make g++ git ca-certificates
RUN update-ca-certificates --fresh

RUN apk --update add libstdc++ curl ca-certificates

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /build



ENV MIX_ENV=prod \
    LANG=C.UTF-8
# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv

COPY lib lib

COPY assets assets

# compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

#=================
# deployment Stage
#=================
FROM alpine:3.18

ENV LANG=C.UTF-8
ENV HOME=/opt/app

RUN apk add --no-cache \
    ncurses-libs \
    zlib \
    libgcc \
    libstdc++ \
    openssl \
    ca-certificates && \
    update-ca-certificates --fresh && \
    mkdir -p ${HOME} && \
    chown -R nobody: ${HOME} && \
    apk --no-cache upgrade

WORKDIR ${HOME}

#Set environment variables and expose port
EXPOSE 4000
USER nobody

COPY --chown=nobody:nobody --from=build /build/_build/prod/rel/cluster_test .

#Set default entrypoint and command
ENTRYPOINT ["/opt/app/bin/cluster_test"]
CMD ["start"]