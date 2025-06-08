FROM debian:bullseye-slim

WORKDIR /app


COPY rofl/target/release/rofl .

ENTRYPOINT ["./rofl"]
