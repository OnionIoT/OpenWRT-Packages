
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=fast-gpio
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/fast-gpio.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Tool to enable GPIO access and software PWM support
	DEPENDS:=$(CXX_DEPENDS)
endef


define Package/$(PKG_NAME)/description
Tool to enable GPIO access and PWM support
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/$(PKG_NAME) $(1)/usr/sbin/
	# copy script
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/expled.sh $(1)/usr/bin/expled
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

