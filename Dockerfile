FROM ghcr.io/ptero-eggs/steamcmd:proton

USER root

# Install the tools needed to fetch and unpack GE-Proton at build time.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl tar \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/ge-proton \
    && curl -fL "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-9/GE-Proton11-9-x86_64.tar.gz" \
       -o /tmp/ge-proton.tar.gz \
    && tar -xzf /tmp/ge-proton.tar.gz --strip-components=1 -C /opt/ge-proton \
    && rm -f /tmp/ge-proton.tar.gz \
    && chmod +x /opt/ge-proton/proton

# The existing egg invokes "proton run ..."; put GE-Proton first in PATH.
ENV PATH="/opt/ge-proton:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV HOME=/home/container
WORKDIR /home/container

# Restore the unprivileged user expected by Pterodactyl.
USER container
