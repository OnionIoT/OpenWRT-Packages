
# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-calculator
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
	TITLE:=Package for the onion-calculator console app
	DEPENDS:=+rpcd +onion-console-base
endef

define Package/$(PKG_NAME)/description
Package for the onion-calculator console app.
endef

define Package/$(PKG_NAME)/install
	# Create the directory for the onion-resistor-calculator
	$(INSTALL_DIR) $(1)/www/apps/onion-calculator
	# copy the onion-resistor-calculator app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-calculator/* $(1)/www/apps/onion-calculator/.
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
