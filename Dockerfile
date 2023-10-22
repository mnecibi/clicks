FROM hexpm/elixir:1.15.4-erlang-26.0.2-alpine-3.18.2 as build

RUN apk add --update --no-cache npm make g++ git ca-certificates
RUN update-ca-certificates --fresh

RUN apk --update add libstdc++ curl ca-certificates

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /build

COPY mix.exs mix.lock ./

ENV MIX_ENV=prod \
    LANG=C.UTF-8

#Install dependencies and build Release
RUN mix deps.get --only prod

# Compile assets
RUN mix compile

COPY lib lib
COPY priv priv
COPY config config
COPY assets assets
RUN mix setup

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