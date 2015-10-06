
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=Onion-Console
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/Onion-Console.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Web-based virtual desktop for the Omega
	DEPENDS:=+rpcd +onion-sh-lib
endef


define Package/$(PKG_NAME)/description
Web-based virtual desktop for the Omega
endef

define Package/$(PKG_NAME)/install
	# install the acl permissions file
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/acl.d/onion-console.json $(1)/usr/share/rpcd/acl.d/onion-console.json
	# install the rpcd script
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rpcd/onion-console.sh $(1)/usr/libexec/rpcd/onion-console
	# copy the web site files
	$(INSTALL_DIR) $(1)/www
	cp -r $(PKG_BUILD_DIR)/www/* $(1)/www/.
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

