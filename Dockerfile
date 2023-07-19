#
# Fiji + Java 8 Dockerfile
#

# Pull base JDK-8 image.
FROM openjdk:8

# Define maintainer.
LABEL maintainer="Erik Ferlanti <eferlanti@tacc.utexas.edu>"

# Update OS
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libxtst6 \
        x11-apps \
        xauth \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Define working directory.
WORKDIR /opt/fiji

# Install Fiji.
RUN wget -q https://downloads.imagej.net/fiji/latest/fiji-nojre.zip \
 && unzip fiji-nojre.zip \
 && rm fiji-nojre.zip

# Add fiji to the PATH
ENV PATH $PATH:/opt/fiji/Fiji.app

# Update URLs use https
RUN ImageJ-linux64 --headless --default-gc --update edit-update-site ImageJ https://update.imagej.net/
RUN ImageJ-linux64 --headless --default-gc --update edit-update-site Fiji https://update.fiji.sc/
RUN ImageJ-linux64 --headless --default-gc --update edit-update-site Java-8 https://sites.imagej.net/Java-8/

CMD [ "ImageJ-linux64", "--default-gc" ]
