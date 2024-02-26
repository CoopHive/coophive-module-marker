# Dev

## Bacalhau

```
cid="QmUvN8GQ3ZLZLspaxpMVHGdpAAFbJ2SHRYxwQJUsyA1RiX"

bacalhau docker run --download \
  --timeout 3600 \
  --wait-timeout-secs 3600 \
  --gpu 1 \
  --cpu 3 \
  --memory '5Gb' \
  --input https://gateway.lighthouse.storage/ipfs/$cid \
  laciferin/marker:v1.0.1 -- /inputs/$cid /outputs/data.md --parallel_factor 1 --max_pages 10

```

```
b describe $jobId --json | jq .Job
```
