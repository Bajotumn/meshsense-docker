FROM ubuntu:jammy
VOLUME [ "/root/.local/share/meshsense" ]
LABEL maintainer="bajotumn@gmail.com"
LABEL repository="https://hub.docker.com/r/bajotumn/meshsense"
LABEL description="Docker image for running MeshSense"
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app
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

COPY meshsense /app
ENV HEADLESS=1
ENV PORT=5920

CMD ["./meshsense", "--headless", "--disable-gpu", "--in-process-gpu", "--disable-software-rasterizer", "--no-sandbox"]