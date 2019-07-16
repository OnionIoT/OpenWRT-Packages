
# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-script
PKG_VERSION:=0.3
PKG_RELEASE:=6


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/Onion-Scripts.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Command to help with Onion product automation
	DEPENDS:=+wget +bc
endef


define Package/$(PKG_NAME)/description
Command to help with Onion product automation
endef

define Package/ethernet-mode
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Program to help automate production-time ethernet configuration
	DEPENDS:=onion-script
endef


define Package/ethernet-mode/description
Program to help automate production-time ethernet configuration
endef

#define Package/$(PKG_NAME)/Build/Compile
#	$(MAKE) -C $(PKG_BUILD_DIR)
#endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/onion.sh $(1)/usr/bin/onion
endef

define Package/ethernet-mode/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ethernet-mode.sh $(1)/etc/init.d/ethernet-mode
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,ethernet-mode))
