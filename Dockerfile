FROM ghcr.io/prefix-dev/pixi:0.47.0-noble-cuda-12.8.1 AS build

# Install build tools first (rarely changes)
RUN apt-get -y update && apt-get install -y gcc g++

WORKDIR /app

# Copy dependency files first (for better caching)
COPY pixi.toml pixi.lock ./

# Install dependencies (this layer will be cached unless dependencies change)
RUN pixi install

# Copy source code last (changes frequently)
COPY . .

# Create the shell-hook bash script to activate the environment
RUN pixi shell-hook > /shell-hook.sh

# extend the shell-hook script to run the command passed to the container
RUN echo 'exec "$@"' >> /shell-hook.sh

# Production base with build tools (cached separately)
FROM ghcr.io/prefix-dev/pixi:0.47.0-noble-cuda-12.8.1 AS production-base

# Install build tools needed for Triton compilation (rarely changes)
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Set CC environment variable for Triton
ENV CC=gcc

# Final production stage
FROM production-base AS production

# Copy application and dependencies (changes frequently)
COPY --from=build /app /app
COPY --from=build /shell-hook.sh /shell-hook.sh

WORKDIR /app

# set the entrypoint to the shell-hook script (activate the environment and run the command)
ENTRYPOINT ["/bin/bash", "/shell-hook.sh"]

CMD ["python", "-m", "saliency.handler", "--rp_serve_api"]
