
# Copyright (C) 2015 Onion Corporation
#
# Author: Zheng Han  <zh@onion.io>
# 
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-service
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/onion-service.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)


include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=network
	CATEGORY:=Network
	SUBMENU:=Onion
	TITLE:=Service for communicating with Onion Cloud
	DEPENDS:=+libubus
endef


define Package/$(PKG_NAME)/description
Service for communicating with Onion Cloud
endef

define Package/$(PKG_NAME)/Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) onion-service
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/bin/onion
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
