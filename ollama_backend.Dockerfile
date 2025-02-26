FROM ubuntu:24.04 AS ollama_backend

RUN apt update && apt upgrade -y
RUN apt install -y \
    curl
RUN curl -fsSL https://ollama.com/install.sh | sh

ENTRYPOINT ["ollama"]
CMD ["serve"]
