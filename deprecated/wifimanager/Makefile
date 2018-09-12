
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=wifimanager
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=omega2
PKG_SOURCE_URL:=https://github.com/OnionIoT/wifi-manager.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Network
	TITLE:=Script for wifi connection and configuration manager
	DEPENDS:=+rpcd +rpcd-mod-iwinfo
endef


define Package/$(PKG_NAME)/description
Script for wifi connection and configuration manager
endef

#define Package/$(PKG_NAME)/Build/Compile
#	$(MAKE) -C $(PKG_BUILD_DIR)
#endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/wifi-manager.sh $(1)/usr/bin/wifimanager
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/wifi-setup.sh $(1)/usr/bin/wifisetup
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init.d/wifimanager $(1)/etc/init.d/wifimanager
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

