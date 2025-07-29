#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Starting Docker build and push process..."

# Get the latest commit hash for tagging
GIT_COMMIT=$(git rev-parse --short HEAD)
IMAGE="atharvab3/myapp:${GIT_COMMIT}"

# Build the Docker image
echo "[INFO] Building Docker image: $IMAGE"
docker build -t $IMAGE .

# Log in to Docker Hub (ensure DOCKERHUB_USER and DOCKERHUB_PASS are set as Jenkins credentials)
echo "[INFO] Logging into Docker Hub..."
echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin

# Push the image
echo "[INFO] Pushing Docker image to Docker Hub..."
docker push $IMAGE

# Optionally, tag as latest
docker tag $IMAGE atharvab3/myapp:latest
docker push atharvab3/myapp:latest

echo "[INFO] Docker build and push completed successfully."
