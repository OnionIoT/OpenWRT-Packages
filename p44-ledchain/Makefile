# Copyright (C) 2017 Lukas Zeller <luz@plan44.ch> (RGBW support)
# See LICENSE for more information.
#
# Completely rewritten, but made compatible with and partially based on code snippets from
# ws2812-draiveris bitbanging driver for AR9931 SoC by Žilvinas Valinskas, Saulius Lukšė, Jürgen Weigert
#
# References: http://www.adafruit.com/datasheets/WS2812.pdf
# References: https://cdn-shop.adafruit.com/product-files/1138/SK6812+LED+datasheet+.pdf
#

## === example module load + test for 20 WS2812 LEDs connected to PWM1:
## insmod p44-ledchain pwm_channel=1 inverted=1
## echo -en '\x00\x00\x40' > /dev/p44ledchain

## === example module load + test for 20 SK6812 LEDs:
## insmod ws2812-draiveris pwm_channel=1 inverted=1 rgbw=1
## echo -en '\x00\x00\x40\x40' > /dev/p44ledchain

# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

# name
PKG_NAME:=p44-ledchain
# version of what we are downloading
PKG_VERSION:=1.2
# version of this makefile
PKG_RELEASE:=6

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)
PKG_CHECK_FORMAT_SECURITY:=0

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
	SUBMENU:=Other modules
	DEPENDS:=@(TARGET_ramips_mt76x8||TARGET_ramips_mt7688)
	TITLE:=p44-ledchain driver for WS28xx/SK68xx
	FILES:= $(PKG_BUILD_DIR)/p44-ledchain.ko
endef

define KernelPackage/$(PKG_NAME)/description
	This package contains the p44-ledchain kernel driver for WS28xx and SK68xx type serial LED chains
	for MT7688, which uses PWM unit to generate the WS28xx timing without blocking IRQs.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef


MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	SUBDIRS="$(PKG_BUILD_DIR)"

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
