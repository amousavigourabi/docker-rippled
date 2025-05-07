FROM ubuntu:noble

RUN export LANGUAGE=C.UTF-8; export LANG=C.UTF-8; export LC_ALL=C.UTF-8; export DEBIAN_FRONTEND=noninteractive

COPY bug-seeded-rippled/.build/rippled /opt/ripple/bin/rippled
COPY entrypoint /entrypoint.sh

RUN apt-get update -y && \
    apt-get install --reinstall ca-certificates -y && \
    apt-get install apt-transport-https wget gnupg -y && \
    rm -rf /var/lib/apt/lists/* && \
    export PATH=$PATH:/opt/ripple/bin/ && \
    chmod +x /entrypoint.sh && \
    echo '#!/bin/bash' > /usr/bin/server_info && echo '/entrypoint.sh server_info' >> /usr/bin/server_info && \
    chmod +x /usr/bin/server_info

RUN ln -s /opt/ripple/bin/rippled /usr/bin/rippled

EXPOSE 80 443 5005 6006 51235

ENTRYPOINT [ "/entrypoint.sh" ]
