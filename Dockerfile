from fedora
LABEL authors="support@i88.ca"
RUN dnf update -y
RUN dnf install libxcrypt-compat git gcc -y
RUN dnf groupinstall 'Development Tools' -y
#Because Linuxbrew asks not to run as root
RUN useradd -s /bin/bash i88ca
RUN usermod -aG wheel i88ca
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo 'Set disable_coredump false' >> /etc/sudo.conf
USER i88ca
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
RUN echo "PATH=$PATH:/home/linuxbrew/.linuxbrew/bin/" >> ~/.bash_profile
RUN test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN cd /home/linuxbrew/.linuxbrew/bin/
RUN /home/linuxbrew/.linuxbrew/bin/brew install gcc

RUN /home/linuxbrew/.linuxbrew/bin/brew tap aws/tap
RUN /home/linuxbrew/.linuxbrew/bin/brew install aws-sam-cli
RUN /home/linuxbrew/.linuxbrew/bin/patchelf --version
RUN /home/linuxbrew/.linuxbrew/bin/sam --version
WORKDIR ~
CMD bash
