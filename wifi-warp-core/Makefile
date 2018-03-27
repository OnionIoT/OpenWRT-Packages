#
# Copyright (C) 2017 Onion Corporation
#
# All rights reserved.
#


include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=wifi-warp-core
PKG_VERSION:=0.0.3
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=http://git.openwrt.org/project/iwinfo.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=ade8b1b299cbd5748db1acf80dd3e9f567938371
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_LICENSE:=GPL-2.0

PKG_CONFIG_DEPENDS := \
	CONFIG_PACKAGE_kmod-brcm-wl \
	CONFIG_PACKAGE_kmod-brcm-wl-mini \
	CONFIG_PACKAGE_kmod-brcm-wl-mimo \
	CONFIG_PACKAGE_kmod-madwifi \
	CONFIG_PACKAGE_kmod-cfg80211

include $(INCLUDE_DIR)/package.mk

define Package/wifi-warp-core
  SECTION:=onion
  CATEGORY:=Onion
  SUBMENU:=WiFi
  TITLE:=Onion's Enhanced Omega2 MT7688 WiFi Driver
  DEPENDS:=@TARGET_ramips_mt7688 +wireless-tools +maccalc +libuci +coreutils-base64
  ABI_VERSION:=$(PKG_RELEASE)
endef

define Build/Configure
endef

IWINFO_BACKENDS := \
	$(if $(CONFIG_TARGET_ramips),rt) \

EXTRA_CFLAGS := \
	-I$(STAGING_DIR)/usr/include/libnl-tiny \
	-I$(STAGING_DIR)/usr/include \
	-D_GNU_SOURCE

MAKE_FLAGS += \
	FPIC="$(FPIC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	BACKENDS="$(IWINFO_BACKENDS)"

define Build/Compile
	$(call Build/Compile/Default,)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/iwinfo
	$(CP) $(PKG_BUILD_DIR)/include/iwinfo.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/include/iwinfo/* $(1)/usr/include/iwinfo/
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libiwinfo.so $(1)/usr/lib/libiwinfo.so
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/iwinfo.so $(1)/usr/lib/lua/iwinfo.so
endef

define Package/wifi-warp-core/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/lib/modules/$(LINUX_VERSION)/
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/iwinfo $(1)/usr/bin/iwinfo.rt
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libiwinfo.so $(1)/lib/libiwinfo.so
	$(INSTALL_DIR) $(1)/sbin/
	$(INSTALL_BIN) ./bin/ap_client $(1)/sbin/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./bin/wifi-setup.sh $(1)/usr/bin/wifisetup
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)/
	$(INSTALL_BIN) ./bin/mt_wifi.ko $(1)/lib/modules/$(LINUX_VERSION)/mt_wifi.ko
	$(INSTALL_DIR) $(1)/etc $(1)/etc/modules.d $(1)/etc/uci-defaults $(1)/etc/Wireless $(1)/etc/Wireless/mt7628 $(1)/lib $(1)/lib/netifd $(1)/lib/netifd/wireless $(1)/lib/wifi
	$(INSTALL_BIN) ./files/etc/modules.d/52-mt7628 $(1)/etc/modules.d/52-mt7628
	$(INSTALL_BIN) ./files/etc/uci-defaults/50-mt7688-iwinfo $(1)/etc/uci-defaults/50-mt7688-iwinfo
	$(INSTALL_BIN) ./files/etc/Wireless/mt7628/mt7628.dat $(1)/etc/Wireless/mt7628/mt7628.dat
	$(INSTALL_BIN) ./files/etc/Wireless/mt7628_tpl.dat $(1)/etc/Wireless/mt7628_tpl.dat
	$(INSTALL_BIN) ./files/lib/netifd/wireless/ralink.sh $(1)/lib/netifd/wireless/ralink.sh
	$(INSTALL_BIN) ./files/lib/wifi/ralink.sh $(1)/lib/wifi/ralink.sh
	$(INSTALL_BIN) ./files/sbin/aac $(1)/sbin/aac
	$(INSTALL_BIN) ./files/sbin/connect2ap $(1)/sbin/connect2ap
endef

$(eval $(call BuildPackage,wifi-warp-core))
