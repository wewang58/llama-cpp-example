#!/usr/bin/env bash
podman build quay.io/$QUAY_USER/mistral:$IMAGE_TAG .

# Running container
podman run -d \
  --name mistral-service \
  -p 8080:8080 \
  --security-opt=no-new-privileges \
  --read-only \
  --tmpfs /tmp \
  quay.io/$QUAY_USER/mistral:$IMAGE_TAG

# Check logs
podman logs -f mistral-service

