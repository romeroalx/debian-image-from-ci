FROM debian:11

ARG GITHUB_DEFAULT_WS_FOLDER=/home/runner/work/pdns

# Reusable layer for base update
RUN apt-get update && apt-get -y dist-upgrade && apt-get clean

# Install basic SW and deugging tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    sudo git curl gnupg software-properties-common wget \
    ca-certificates apt-utils build-essential vim \
    iproute2 net-tools iputils-* ifupdown cmake acl \
    npm time mariadb-client postgresql-client jq

# Add LLVM repository
RUN add-apt-repository 'deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-12 main'
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
RUN apt-get update

# Run as user "runner", uid 1001, gid 122. Make this user a passwordless sudoer
RUN groupadd -g 122 runner
RUN useradd -u 1001 -ms /bin/bash -g runner runner
RUN echo "runner ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
USER runner

# Commented. not preserved on docker
# RUN sudo setfacl -m default:user::rwx /opt

# Clone repo an execute basic configuration. Do not delete folder
RUN mkdir -p ${GITHUB_DEFAULT_WS_FOLDER}
WORKDIR ${GITHUB_DEFAULT_WS_FOLDER}
RUN git clone https://github.com/PowerDNS/pdns.git

# Install required packages
WORKDIR ${GITHUB_DEFAULT_WS_FOLDER}/pdns
RUN build-scripts/gh-actions-setup-inv
RUN inv apt-fresh
RUN inv install-clang
RUN inv install-auth-build-deps
RUN inv install-rec-build-deps
RUN inv install-dnsdist-build-deps

# Copy permissions for /opt and node_modules like Github runner VMs
RUN sudo mkdir -p /usr/local/lib/node_modules
RUN sudo chmod 777 /opt /usr/local/bin /usr/share /usr/local/lib/node_modules
RUN sudo chmod 777 -R /opt/pdns-auth


WORKDIR /home/runner
