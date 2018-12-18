#
# Copyright (C) 2014-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtl8812AU_8821AU_linux
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/greearb/rtl8812AU_8821AU_linux
PKG_SOURCE_DATE:=2018-11-16
PKG_SOURCE_VERSION:=661268fd174d4a74834c82d7d3987b0a560e6c57
PKG_MAINTAINER:=Ben Greear <greearb@candelatech.com>

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek 8812AU/8821AU USB WiFi driver
  DEPENDS+= @USB_SUPPORT +kmod-usb-core +kmod-mac80211 +@DRIVER_11N_SUPPORT
  FILES:= \
        $(PKG_BUILD_DIR)/rtl8812au.ko
  AUTOLOAD:=$(call AutoProbe,rtl8812au.ko)
endef

define KernelPackage/$(PKG_NAME)/description
  Realtek 8812AU/8821AU USB WiFi driver for AC1200 (801.11ac) Wireless Dual-Band USB Adapter
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		modules
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
