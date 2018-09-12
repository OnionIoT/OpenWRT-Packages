
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=wifisaint
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/wifisaint.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Network
	TITLE:=Cron service to create an AP wifi network if all networks are disabled
	DEPENDS:=+wifisetup
endef


define Package/$(PKG_NAME)/description
Cron service to create an AP wifi network if all networks are disabled
endef

#define Package/$(PKG_NAME)/Build/Compile
#	$(MAKE) -C $(PKG_BUILD_DIR)
#endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wifisaint $(1)/usr/bin/
	# creating cron entry
	$(INSTALL_DIR) $(1)/etc/crontabs
	touch $(1)/etc/crontabs/root
	cat $(PKG_BUILD_DIR)/cron/wifisaint.cron > $(1)/etc/crontabs/root
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

