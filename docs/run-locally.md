# Running Zipherscan locally

Defaults point at the ZSA testnet: API `https://cipherscan-api.test-zsa.org`, node RPC `https://rpc.test-zsa.org`. Node 22.14+.

## Frontend only

```bash
npm ci
npm run dev    # http://localhost:3000, uses the hosted ZSA API
```

## Full stack (Postgres + API + web)

```bash
git clone https://github.com/Kenbak/cipherscan-rust.git ../cipherscan-rust
git -C ../cipherscan-rust checkout 0edc9619   # newer commits fail in migrate
cp .env.docker.example .env.docker
docker compose --env-file .env.docker up -d --build
```

Web on `:3000`, API on `:3001`. The database starts empty: `/health` and `/api/mempool` work, indexed data needs the indexer, which runs only next to a synced ZSA zebrad (see [ECR.md](../ECR.md)).

To use your own zebrad, set `ZEBRA_RPC_URL=http://host.docker.internal:18232` in `.env.docker`.
