
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-ubus
PKG_VERSION:=0.3
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/onion-ubus.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Collection of Onion ubus tools
	DEPENDS:=+rpcd +iwinfo +oupgrade +libugpio
endef


define Package/$(PKG_NAME)/description
Collection of Onion ubus tools
endef


define Package/$(PKG_NAME)/install
	# create libexec dir for rpcd
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	# copy rpcd scripts
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rpcd/* $(1)/usr/libexec/rpcd/.
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

