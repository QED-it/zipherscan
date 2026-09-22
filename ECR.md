# Building the ZSA testnet images

The explorer runs on the ZSA testnet box from two images in ECR. Nothing builds
them automatically — build and push by hand, then pin the new tag in
`testnet-single-node-deploy/ec2/docker-compose.yml` in the `QED-it/zebra` repo
and run the `Zebra EC2 Ops` workflow with `deploy-files`.

| Service | ECR repository |
| --- | --- |
| `api` | `496038263219.dkr.ecr.eu-central-1.amazonaws.com/dev-zipherscan-api` |
| `web` | `496038263219.dkr.ecr.eu-central-1.amazonaws.com/dev-zipherscan-web` |

```sh
REG=496038263219.dkr.ecr.eu-central-1.amazonaws.com
SHA=$(git rev-parse --short HEAD)
aws ecr get-login-password --region eu-central-1 \
  | docker login --username AWS --password-stdin $REG
```

## api

Build from the **repository root**, not `server/api` — the Dockerfile copies
`server/lib/` and `server/signals/`, which are outside that directory. The
`context: ./server/api` in `docker-compose.yml` is wrong for this reason.

```sh
docker buildx build --platform linux/amd64 -f server/api/Dockerfile . \
  --build-arg GIT_COMMIT="$SHA" \
  -t $REG/dev-zipherscan-api:$SHA --push
```

## web

`NEXT_PUBLIC_*` values are compiled into the browser bundle, so the API URL is a
**build arg** — setting it at runtime in compose has no effect. Without it the
bundle falls back to `DEFAULT_API_URLS` in `lib/api-config.ts`, which points at
upstream's `api.testnet.cipherscan.app`.

```sh
docker buildx build --platform linux/amd64 -f Dockerfile . \
  --build-arg GIT_COMMIT="$SHA" \
  --build-arg NEXT_PUBLIC_NETWORK=testnet \
  --build-arg NEXT_PUBLIC_API_URL=https://cipherscan-api.test-zsa.org \
  -t $REG/dev-zipherscan-web:${SHA}-zsa --push
```

The `-zsa` suffix marks it as built for this deployment: the same commit built
with a different `NEXT_PUBLIC_API_URL` is a different image.

## Notes

`--platform linux/amd64` is required — the box is x86_64. Building on an arm64
Mac works through emulation but is slow.

The instance role `zebra-testnet-instance` must list both repositories in its
`pull-zebra-ecr-image` policy, or the box cannot pull them.
