
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=console-install-tool
PKG_VERSION:=0.2
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/console-install-tool.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Script for managing console feature installations
	DEPENDS:=+rpcd +rpcd-mod-iwinfo
endef


define Package/$(PKG_NAME)/description
Script for managing console feature installations
endef

#define Package/$(PKG_NAME)/Build/Compile
#	$(MAKE) -C $(PKG_BUILD_DIR)
#endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/console_config.sh $(1)/usr/bin/console-install-tool
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init.d/console $(1)/etc/init.d/console
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
