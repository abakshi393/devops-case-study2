#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Starting Docker build and push process..."

# Take commit hash from Jenkins pipeline
if [ -z "${1:-}" ]; then
  echo "[ERROR] Commit hash not provided!"
  exit 1
fi

COMMIT_HASH=$1
IMAGE="atharvab3/myapp:${COMMIT_HASH}"

# Build the Docker image
echo "[INFO] Building Docker image: $IMAGE"
docker build -t "$IMAGE" -t "atharvab3/myapp:latest" .

# Log in to Docker Hub
echo "[INFO] Logging into Docker Hub..."
echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin

# Push images
echo "[INFO] Pushing Docker images to Docker Hub..."
docker push "$IMAGE"
docker push "atharvab3/myapp:latest"

echo "[INFO] Docker build and push completed successfully."
