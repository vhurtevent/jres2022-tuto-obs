FROM ubuntu:20.04

RUN apt-get update      \
    && DEBIAN_FRONTEND=noninteractive apt-get --yes --no-install-recommends install \
        ansible         \
        asciinema       \
        curl            \
        git             \
        fzf             \
        golang          \
        httpie          \
        python3-pip     \
        s3cmd           \
        sudo            \
        tmux            \
        unzip           \
        vim             \
        wget            \
        zsh             \
    && apt-get clean    \
    && rm -fr /var/lib/apt/lists/* 

## Installation des CLI OpenStack
RUN pip install python-openstackclient python-octaviaclient

## Installation de Terraform
RUN wget -L "hhttps://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_amd64.zip" -O /tmp/terraform_1.1.3_linux_amd64.zip  \
    && unzip /tmp/terraform_1.1.3_linux_amd64.zip -d /usr/local/bin/                                                                \
    && rm -f /tmp/terraform_1.1.3_linux_amd64.zip

## Installation des CLI AWS
RUN wget -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O /tmp/awscli-exe-linux-x86_64.zip    \
    &&  unzip /tmp/awscli-exe-linux-x86_64.zip -d /tmp/                                                     \
    && /tmp/aws/install -i /usr/local/aws-cli -b /usr/local/bin                                             \
    && rm -fr /tmp/awscli-exe-linux-x86_64.zip /tmp/aws

## Installation de kubectl
RUN wget -L "https://dl.k8s.io/release/v1.23.5/bin/linux/amd64/kubectl" -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

## Installation de Helm
RUN curl "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" | bash

## Installation de Kubie
RUN wget -L "https://github.com/sbstp/kubie/releases/download/v0.16.0/kubie-linux-amd64" -O /usr/local/bin/kubie  \
    && chmod +x /usr/local/bin/kubie

## Installation de Krew
RUN set -x; cd "$(mktemp -d)"                                                                               \
    && OS="$(uname | tr '[:upper:]' '[:lower:]')"                                                           \
    && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"  \
    && KREW="krew-${OS}_${ARCH}"                                                                            \
    && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"        \
    && tar zxvf "${KREW}.tar.gz"                                                                            \
    && ./"${KREW}" install krew

## Installation de Oh My Zsh
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
## Installation du plugin kube-aliases
RUN git clone https://github.com/Dbz/kube-aliases.git ~/.oh-my-zsh/custom/plugins/kube-aliases
## Installation du plugin zsh-completions
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

ADD config/zshrc /root/.zshrc
ADD config/p10k.zsh /root/.p10k.zsh
ADD config/tmux.conf /root/.tmux.conf
ADD config/kubie.yaml /root/.kube/kubie.yaml
RUN mkdir /root/.aws

# Running ZSH
CMD ["zsh"]