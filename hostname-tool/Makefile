# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
PKG_NAME:=hostname-tool
PKG_VERSION:=0.4
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/omega2-hostname-tool.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Network
	TITLE:=Tool to properly set the Omega2's Hostname to the last 4 digits of its MAC address
	DEPENDS:=
endef

define Package/$(PKG_NAME)/description
Tool to properly set the Omega2's Hostname to the last 4 digits of its MAC address
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/updateHostname $(1)/usr/bin/updateHostname
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init.d/updateHostname $(1)/etc/init.d/updateHostname
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
