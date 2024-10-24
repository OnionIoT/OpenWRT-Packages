FROM onion/openwrt-builder:latest


# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory to /root
WORKDIR /root

# Update and install the required packages
RUN git clone https://github.com/OnionIoT/openwrt-sdk-wrapper.git && \
    cd openwrt-sdk-wrapper && \
    bash onion_buildenv setup_sdk && \
    bash onion_buildenv build_packages python3

WORKDIR /root/openwrt-sdk-wrapper


# Set the default command
CMD ["bash"]
