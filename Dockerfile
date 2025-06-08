FROM debian:bookworm

WORKDIR /app


COPY rofl/target/release/rofl .

ENTRYPOINT ["./rofl"]
