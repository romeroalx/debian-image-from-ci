FROM debian:11

# Reusable layer for base update
RUN apt-get update && apt-get -y dist-upgrade && apt-get clean

# # Install sudo to mimic Github CI behaviour
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install sudo git curl gnupg software-properties-common wget ca-certificates
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils build-essential vim iproute2 net-tools iputils-* ifupdown cmake
# 
# # Add LLVM repository
# RUN add-apt-repository 'deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-12 main'
# RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
# RUN apt-get update
# 
# # Run as user "ubuntu". Make this user a passwordless sudoer
# RUN useradd -ms /bin/bash pdns
# RUN echo "pdns ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# USER pdns
# WORKDIR /home/pdns
# 
# # Clone repo an execute basic configuration
# RUN git clone https://github.com/PowerDNS/pdns.git
# 
# WORKDIR /home/pdns/pdns
# RUN build-scripts/gh-actions-setup-inv
# RUN inv apt-fresh
# RUN inv install-clang
# RUN inv install-auth-build-deps
# RUN inv install-rec-build-deps
# RUN inv install-dnsdist-build-deps
# 
# # Cleanup directory
# RUN cd .. && rm -rf pdns
