# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
##OPENWRT PACKAGE MAKEFILE FOR  onoff Node

include $(TOPDIR)/rules.mk
PKG_NAME:=onoff-node
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/fivdi/onoff.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/onoff-node
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Onoff Package
	DEPENDS:= +libc +libpthread +libstdcpp
endef


define Package/onoff-node/description
Onoff package built for mips. 
endef


TARGET_CFLAGS += $(FPIC)

define Build/Compile
	$(CP) ./files/makefile $(PKG_BUILD_DIR)/makefile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)"
endef

##Whats this do?
#define Build/InstallDev
#
#endef

define Package/onoff-node/install
	cp -r $(PKG_BUILD_DIR)/ /tmp/; 
	$(INSTALL_DIR) $(1)/usr/bin;
	cp -r /tmp/$(PKG_NAME) $(PKG_BUILD_DIR)/ipkg-ar71xx/$(PKG_NAME)/usr/bin;

endef

$(eval $(call BuildPackage,onoff-node))

