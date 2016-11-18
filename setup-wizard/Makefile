
# Copyright (C) 2015 Onion Corporation
# 
# Author: Boken Lin  <bl@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=setup-wizard
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=omega2
PKG_SOURCE_URL:=https://github.com/OnionIoT/setup-wizard.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Web interface to setup the Omega for the first time
	DEPENDS:=+rpcd +onion-ubus +wifimanager +oupgrade
endef


define Package/$(PKG_NAME)/description
Script to facilitate wifi setup and connection on the Omega
endef

define Package/$(PKG_NAME)/install
	# installing acl file
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/acl.d/* $(1)/usr/share/rpcd/acl.d/
	# installing www
	$(INSTALL_DIR) $(1)/www/setup-wizard
	$(CP) -r $(PKG_BUILD_DIR)/www/* $(1)/www/setup-wizard/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

