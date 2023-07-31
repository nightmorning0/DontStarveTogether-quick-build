FROM archlinux:latest AS builder
RUN pacman -Sy
RUN pacman -S --noconfirm base-devel git
RUN useradd -m steam 
RUN echo "steam ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/steam
USER steam
RUN git clone https://aur.archlinux.org/steamcmd.git
WORKDIR /home/steam/steamcmd
RUN makepkg -si --noconfirm
RUN tar -zxf steamcmd_linux.tar.gz
COPY scripts/install.sh /home/steam/steamcmd/install.sh
RUN sudo chmod +x install.sh && ./install.sh

FROM archlinux:latest AS server
COPY --from=builder /home/steam/steamapps /root
COPY scripts/start.sh /bin/start 
RUN pacman -Sy && pacman -S --noconfirm libcurl-gnutls screen && chmod +x /bin/start && mkdir -p .klei/DoNotStarveTogether/
EXPOSE 10999/udp
