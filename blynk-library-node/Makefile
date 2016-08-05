# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
##OPENWRT PACKAGE MAKEFILE FOR  onoff Node

include $(TOPDIR)/rules.mk
PKG_NAME:=blynk-library-node
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/blynk-library-js.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/blynk-library-node
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=blynk-library
	DEPENDS:= +libpthread +libstdcpp
endef


define Package/blynk-library-node/description
Blynk library package built for mips. 
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

define Package/blynk-library-node/install
	$(INSTALL_DIR) ./tmp;
	$(CP) -r $(PKG_BUILD_DIR)/ ./tmp/; 
	$(INSTALL_DIR) $(1)/usr/bin;
	#$(CP) -r ./tmp/$(PKG_NAME) $(PKG_BUILD_DIR)/ipkg-ar71xx/$(PKG_NAME)/usr/bin;
	$(CP) -r ./tmp/$(PKG_NAME) $(1)/usr/bin;
	rm -rf ./tmp;
endef

$(eval $(call BuildPackage,blynk-library-node))

