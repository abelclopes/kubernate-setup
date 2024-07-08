# Use uma imagem base do Ubuntu 22.04
FROM ubuntu:22.04

# Defina o mantenedor
LABEL maintainer="abellopes@gmail.com"

# Desabilitar prompts interativos durante a instalação dos pacotes
ENV DEBIAN_FRONTEND=noninteractive

# Atualizar os pacotes e instalar dependências
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Adicionar chave GPG do Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Adicionar repositório Docker
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Instalar Docker
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Adicionar chave GPG do Kubernetes
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Adicionar repositório Kubernetes
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Atualizar pacotes novamente para incluir o repositório do Kubernetes
RUN apt-get update

# Instalar kubelet, kubeadm e kubectl
RUN apt-get install -y kubelet kubeadm kubectl

# Segurar as versões instaladas
RUN apt-mark hold kubelet kubeadm kubectl

# Desabilitar swap (necessário para Kubernetes)
RUN swapoff -a

# Definir o ponto de entrada
CMD ["bash"]
