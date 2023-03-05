# Use official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Install prerequisites
# curl: download ModusToolbox.tar.gz
# git: download ModusToolbox project
# make: build ModusToolbox projects
# libglib2.0-0: Qt Configurators depend on libglib-2.0.so.0
# libusb-1.0-0: OpenOCD, fw-loader, CapSense Tuner and DFU Host Tool depend in libusb-1.0.so.0
# libgl1-mesa-glx: Qt Configurators depend on libGLX.so.0
# libfontconfig1: bin/platforms/libqoffscreen.so depends on libfontconfig.so.1 and libfreetype.so.6
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y \
 && apt install -y curl git make libglib2.0-0 libusb-1.0-0 libgl1-mesa-glx libfontconfig1 \
 && apt clean

# Download and extract ModusToolbox 3.1
RUN curl --fail --location --silent --show-error 'https://itoolspriv.infineon.com/itbhs/api/packages/com.ifx.tb.tool.modustoolbox/Versions/3.1.0.12257-public/artifacts/ModusToolbox_3.1.0.12257-linux-install.tar.gz/download?noredirect' -o /tmp/ModusToolbox_3.1.0.12257-linux-install.tar.gz \
 && tar -C /opt -zxf /tmp/ModusToolbox_3.1.0.12257-linux-install.tar.gz \
 && rm /tmp/ModusToolbox_3.1.0.12257-linux-install.tar.gz

# Execute post-build scripts
# Note:  udev does not support containers, install_rules.sh not executed
RUN bash -e /opt/ModusToolbox/tools_3.1/modus-shell/postinstall
# && sudo bash -e /opt/ModusToolbox/tools_3.1/openocd/udev_rules/install_rules.sh \
# && sudo bash -e /opt/ModusToolbox/tools_3.1/driver_media/install_rules.sh \
# && sudo bash -e /opt/ModusToolbox/tools_3.1/fw-loader/udev_rules/install_rules.sh

# Set environment variable required by ModusToolbox application makefiles
ENV CY_TOOLS_PATHS="/opt/ModusToolbox/tools_3.1"
# Set environment variable to avoid Qt warning
ENV XDG_RUNTIME_DIR="/tmp"
