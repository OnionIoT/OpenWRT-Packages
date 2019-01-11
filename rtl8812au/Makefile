#
# Copyright (C) 2014-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtl8812au
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/greearb/rtl8812AU_8821AU_linux
PKG_SOURCE_DATE:=2018-11-16
PKG_SOURCE_VERSION:=661268fd174d4a74834c82d7d3987b0a560e6c57
PKG_MAINTAINER:=Ben Greear <greearb@candelatech.com>

PKG_BUILD_PARALLEL:=1

STAMP_CONFIGURED_DEPENDS := $(STAGING_DIR)/usr/include/mac80211-backport/backport/autoconf.h

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek 8812AU/8821AU USB WiFi driver
  DEPENDS:=+kmod-cfg80211 +kmod-usb-core +@DRIVER_11N_SUPPORT +@DRIVER_11AC_SUPPORT @!LINUX_3_18 @!LINUX_4_9
  FILES:=$(PKG_BUILD_DIR)/$(PKG_NAME).ko
  AUTOLOAD:=$(call AutoProbe,$(PKG_NAME))
  PROVIDES:=kmod-$(PKG_NAME)
endef

NOSTDINC_FLAGS = \
	-I$(PKG_BUILD_DIR) \
	-I$(PKG_BUILD_DIR)/include \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-include backport/backport.h

NOSTDINC_FLAGS+=-DCONFIG_IOCTL_CFG80211 -DRTW_USE_CFG80211_STA_EVENT -DBUILD_OPENWRT

define KernelPackage/$(PKG_NAME)/description
  Realtek 8812AU/8821AU USB WiFi driver for AC1200 (801.11ac) Wireless Dual-Band USB Adapter
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
		modules
endef

define KernelPackage/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/hotplug.d/usb
	$(INSTALL_BIN) ./files/wifi.hotplug $(1)/etc/hotplug.d/usb/30-wifi
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
