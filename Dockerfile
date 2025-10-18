# Use official Ubuntu 24.04 base image
FROM ubuntu:24.04

# Install prerequisites
# curl: to download ModusToolbox-linux-install.deb
# sudo: for post-install hook to install itb-launcher-service-setup.deb
# libglib2.0-0t64 libgl1 libegl1 libglx-mesa0 libopengl0 libdbus-1-3: Qt6 runtime dependencies
# libusb-1.0-0: OpenOCD, fw-loader, CapSense Tuner and DFU Host Tool dependency
# libfontconfig1: bin/platforms/libqoffscreen.so depends on libfontconfig.so.1 and libfreetype.so.6
# libxcb-shape0: bin/platforms/libqxcb.so depends on libxcb-shape.so.0
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt install -y curl sudo libglib2.0-0t64 libgl1 libegl1 libglx-mesa0 libopengl0 libdbus-1-3 libusb-1.0-0 libfontconfig1 libxcb-shape0 && apt clean

# Download and install Arm GNU Toolchain 14.2.1
RUN curl --fail --location --silent --show-error 'https://softwaretools-hosting.infineon.com/api/packages/com.ifx.tb.tool.mtbgccpackage/versions/14.2.1.265/artifacts/mtbgccpackage_14.2.1.265_Linux_x64.deb/download?noredirect' -o /tmp/mtbgccpackage_14.2.1.265_Linux_x64.deb \
 && apt install -y /tmp/mtbgccpackage_14.2.1.265_Linux_x64.deb \
 && rm /tmp/mtbgccpackage_14.2.1.265_Linux_x64.deb

# Download and install ModusToolbox Edge Protect Security Suite 1.6.1
RUN curl --fail --location --silent --show-error 'https://softwaretools-hosting.infineon.com/api/packages/com.ifx.tb.tool.modustoolboxedgeprotectsecuritysuite/versions/1.6.1.525/artifacts/modustoolboxedgeprotectsecuritysuite_1.6.1.525_Linux_x64.deb/download?noredirect' -o /tmp/modustoolboxedgeprotectsecuritysuite_1.6.1.525_Linux_x64.deb \
 && apt install -y /tmp/modustoolboxedgeprotectsecuritysuite_1.6.1.525_Linux_x64.deb \
 && rm /tmp/modustoolboxedgeprotectsecuritysuite_1.6.1.525_Linux_x64.deb

# Download and install ModusToolbox 3.6
RUN curl --fail --location --silent --show-error 'https://softwaretools-hosting.infineon.com/api/packages/com.ifx.tb.tool.modustoolbox/versions/3.6.0.17979/artifacts/modustoolbox_3.6.0.17979_Linux_x64.deb/download?noredirect' -o /tmp/modustoolbox_3.6.0.17979_Linux_x64.deb \
 && apt install -y /tmp/modustoolbox_3.6.0.17979_Linux_x64.deb \
 && rm /tmp/modustoolbox_3.6.0.17979_Linux_x64.deb

# Set environment variable required by ModusToolbox application makefiles
ENV CY_TOOLS_PATHS="/opt/Tools/ModusToolbox/tools_3.6"
# Set environment variable to avoid Qt warning
ENV XDG_RUNTIME_DIR="/tmp/runtime"
