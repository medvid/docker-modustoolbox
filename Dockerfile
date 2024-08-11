# Use official Ubuntu 24.04 base image
FROM ubuntu:24.04

# Install prerequisites
# curl: to download ModusToolbox-linux-install.deb
# libglib2.0-0t64 libgl1 libegl1 libglx-mesa0 libopengl0 libdbus-1-3: Qt6 runtime dependencies
# libpcre3: fw-loader dependency
# libusb-1.0-0: OpenOCD, fw-loader, CapSense Tuner and DFU Host Tool dependency
# libfontconfig1: bin/platforms/libqoffscreen.so depends on libfontconfig.so.1 and libfreetype.so.6
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt install -y curl libglib2.0-0t64 libgl1 libegl1 libglx-mesa0 libopengl0 libdbus-1-3 libpcre3 libusb-1.0-0 libfontconfig1 && apt clean

# Download and install ModusToolbox 3.2
RUN curl --fail --location --silent --show-error 'https://itoolspriv.infineon.com/itbhs/api/packages/com.ifx.tb.tool.modustoolbox/Versions/3.2.0.16028-public/artifacts/ModusToolbox_3.2.0.16028-linux-install.deb/download?noredirect' -o /tmp/ModusToolbox_3.2.0.16028-linux-install.deb \
 && apt install -y /tmp/ModusToolbox_3.2.0.16028-linux-install.deb \
 && rm /tmp/ModusToolbox_3.2.0.16028-linux-install.deb

# Set environment variable required by ModusToolbox application makefiles
ENV CY_TOOLS_PATHS="/opt/Tools/ModusToolbox/tools_3.2"
# Set environment variable to avoid Qt warning
ENV XDG_RUNTIME_DIR="/tmp/runtime"
