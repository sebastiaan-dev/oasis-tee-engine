FROM debian:bookworm

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      libssl3 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY rofl/target/release/rofl .

ENTRYPOINT ["./rofl"]
