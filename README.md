# Zipherscan

A block explorer for [Zebra](https://github.com/QED-it/zebra) with ZSA (Zcash Shielded Assets, NU7 / v6 transactions), maintained by [QED-it](https://qed-it.com). It is a fork of [CipherScan](https://github.com/Kenbak/cipherscan).

Live on the ZSA testnet: [cipherscan.test-zsa.org](https://cipherscan.test-zsa.org), API at `https://cipherscan-api.test-zsa.org`, node RPC at `https://rpc.test-zsa.org`.

## Run

```bash
npm ci
npm run dev   # http://localhost:3000, reads the ZSA testnet API
```

Full stack (Postgres + API + web) runs from `docker-compose.yml`. See [docs/run-locally.md](docs/run-locally.md).

## Docs

- [docs/run-locally.md](docs/run-locally.md): running locally, pointing at your own ZSA zebrad
- [ECR.md](ECR.md): building and pushing the testnet images

## Branches

`zsa1` is the main line and tracks upstream `main`. Open PRs against it.

## License

MIT, see [LICENSE](LICENSE).
