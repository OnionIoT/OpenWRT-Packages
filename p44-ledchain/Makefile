# Copyright (C) 2017-2021 Lukas Zeller <luz@plan44.ch>
# See LICENSE for more information.
#
# Completely rewritten, but made compatible with and partially based on code snippets from
# ws2812-draiveris bitbanging driver for AR9931 SoC by Žilvinas Valinskas, Saulius Lukšė, Jürgen Weigert
#
# References: http://www.adafruit.com/datasheets/WS2812.pdf
# References: https://cdn-shop.adafruit.com/product-files/1138/SK6812+LED+datasheet+.pdf
#
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

# name
PKG_NAME:=p44-ledchain
# version of what we are downloading
PKG_VERSION:=6
# version of this makefile
PKG_RELEASE:=9

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

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=p44-ledchain driver for WS28xx/SK68xx
	DEPENDS:=+kmod-p44-ledchain
endef

define Package/$(PKG_NAME)/description
Implements p44-ledchain kernel driver for WS28xx and SK68xx type serial LED chains for MT7688
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

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/modules.d
	$(INSTALL_BIN) ./files/p44-ledchain-module $(1)/etc/modules.d/91-p44-ledchain
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
