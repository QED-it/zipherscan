# Indexer image (dev-zipherscan-indexer). Build context is a Kenbak/cipherscan-rust
# checkout, not this repo — see ECR.md.
FROM rust:1-bookworm@sha256:93ce27a88655056a51dbdd8f5f2d7ddc071c7b0070fb288a37b5a285fc83971e AS build
# rocksdb needs clang for bindgen, tonic-build needs protoc, reqwest needs OpenSSL.
RUN apt-get update && apt-get install -y --no-install-recommends \
      clang libclang-dev protobuf-compiler pkg-config libssl-dev \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates libssl3 \
 && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/target/release/cipherscan-indexer /usr/local/bin/cipherscan-indexer
ENTRYPOINT ["cipherscan-indexer"]
CMD ["live"]
