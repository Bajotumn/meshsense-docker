FROM ubuntu:jammy AS build
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN curl -sSL https://affirmatech.com/download/meshsense/meshsense-x86_64.AppImage -o meshsense.AppImage && \
    chmod +x meshsense.AppImage && \
    ./meshsense.AppImage --appimage-extract && \
    mv squashfs-root /meshsense

FROM ubuntu:jammy
VOLUME [ "/root/.local/share/meshsense" ]
LABEL maintainer="bajotumn@gmail.com"
LABEL repository="https://hub.docker.com/r/bajotumn/meshsense"
LABEL description="Docker image for running MeshSense"
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app
COPY --from=build /meshsense /app
RUN apt-get update && apt-get install -y \
    libnss3 \
    libasound2 \
    golang-gir-gobject-2.0-dev \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libgdk-pixbuf-2.0-0 \
    libgtk-3-0 \
    libgbm1 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*
ENV HEADLESS=1
ENV PORT=5920

CMD ["./meshsense", "--headless", "--disable-gpu", "--in-process-gpu", "--disable-software-rasterizer", "--no-sandbox"]