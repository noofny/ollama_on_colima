# Ollama on Colima via Docker

Run containerized Ollama on macOS using [Colima](https://github.com/abiosoft/colima) (short for Containers on Lima) via [Docker](https://www.docker.com/). This is an alternative to using Docker Desktop, which avoids the cons of Docker's bloat, forced updates, evolving license model & other nonsense, whilst enjoying the benefits of open source, simplicity and better performance.

The included Docker stack runs official [Ubuntu 24.04](https://hub.docker.com/_/ubuntu) with official [Ollama installation for Linux](https://ollama.com/download/linux).

## Requirements

- A Mac running any generation of Apple Silicone (M1, M2, M3, M4).
- [Homebrew](https://brew.sh/)

## Setup

Install Colima.

```shell
brew install colima
```

Install Docker and Docker Compose.

```shell
brew install docker docker-compose
```

Configure Docker Compose as a plugin.

```shell
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```

Install Buildx for building some docker containers and configure as a plugin.

```shell
brew install docker-Buildx
ln -sfn $(brew --prefix)/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
```

Start Colima Using Defaults.

```shell
colima start
...
INFO[0000] starting colima
INFO[0000] creating and starting ...                     context=vm
INFO[0041] provisioning ...                              context=docker
INFO[0041] restarting VM to complete setup ...           context=docker
INFO[0041] stopping ...                                  context=vm
INFO[0048] starting ...                                  context=vm
INFO[0068] starting ...                                  context=docker
INFO[0073] waiting for startup to complete ...           context=docker
INFO[0074] done
...
```

Test a container.

```shell
docker run hello-world
...
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

Start Colima Using Custom Resources.

```shell
colima stop
...
colima start --cpu 8 --memory 32 --disk 100
...
```

Build & run this Docker Stack.

```shell
cd <where you cloned this repo>
docker compose up -d
```

Connect to this Docker Stack & Run a Model.

Note: The first time you run a model it needs to download!
      This is also purged whenever you kill the container
      such as doing `docker compose down` or `docker rm`. 

```shell
docker exec -it ollama_backend /bin/bash
...
ollama run deepseek-r1:1.5b
... 
```

## Teardown

NOTE: You will lose all your history, containers, downloaded models and everything.

```shell
cd <where you cloned this repo>
docker compose down
docker rmi <image-id>
...
colima stop
...
colima delete
```

## Benchmark

### Machine Spec

Model: MacMini M4-Pro (2024)
14 CPU cores, 20 GPU cores, 16 NE cores
RAM: 64GB
macOS: 15.3.1

### Configuration

Colima Container: 8 cores, 32GB RAM, 100GB storage
Models: Official [deepseek-r1](https://ollama.com/library/deepseek-r1) models.
Prompt: `write me a story about egg`

### Results

                       Ollama on macOS           Ollama on Colima
                       (100% GPU-bound)          (100% CPU-bound)
--------------------------------------------------------------------
Deekseek-R1 1.5b            ~59.7 token/s            ~57.3 token/s 
Deekseek-R1 8b              ~18.8 token/s            ~18.6 token/s
Deekseek-R1 14b             ~11.9 token/s            ~11.5 token/s
Deekseek-R1 32b              ~6.1 token/s             ~5.9 token/s
--------------------------------------------------------------------

### Conclusion

Running Ollama virtualised on Ubuntu via Colima (CPU bound) is comparable to running it natively on macOS (GPU bound).

This result was unexpected and shows what the newer generation Apple Silicon can achieve.

Running Ollama containerised offers advantages such as less host configuration and added isolation/privacy.

## Related Links

- [Apple Silicon GPUs, Docker and Ollama: Pick two.](https://chariotsolutions.com/blog/post/apple-silicon-gpus-docker-and-ollama-pick-two/)
- [Official Ollama Docker Images](https://hub.docker.com/r/ollama/ollama)
- [Ollama Docker Compose Setup](https://github.com/valiantlynx/ollama-docker)
- [Use Colima to Run Docker Containers on macOS](https://smallsharpsoftwaretools.com/tutorials/use-colima-to-run-docker-containers-on-macos/)
- [Apple M2 Virtualisation using Colima and Docker Desktop](https://allthingscloud.eu/2023/09/14/apple-m2-virtualisation-using-colima-and-docker-desktop/)
- https://medium.com/@andreask_75652/gpu-accelerated-containers-for-m1-m2-m3-macs-237556e5fe0b
- https://medium.com/@guillem.riera/the-most-performant-docker-setup-on-macos-apple-silicon-m1-m2-m3-for-x64-amd64-compatibility-da5100e2557d

