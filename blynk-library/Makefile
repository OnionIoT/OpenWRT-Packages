# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
##OPENWRT PACKAGE MAKEFILE FOR  onoff Node

include $(TOPDIR)/rules.mk
PKG_NAME:=blynk-library
PKG_VERSION:=0.4.5
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=7f31c38117047c215b3e46a2d85f6cf757d5588f
PKG_SOURCE_URL:=https://github.com/vshymanskyy/blynk-library-js.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/blynk-library
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=blynk-library
	DEPENDS:= +libpthread +libstdcpp +nodejs
endef


define Package/blynk-library/description
Blynk library package built for mips.Updated:No Node Dependencies 
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

define Package/blynk-library/install
	$(INSTALL_DIR) ./tmp;
	$(CP) -r $(PKG_BUILD_DIR)/ ./tmp/; 
	$(INSTALL_DIR) $(1)/usr/bin;
	#$(CP) -r ./tmp/$(PKG_NAME) $(PKG_BUILD_DIR)/ipkg-ar71xx/$(PKG_NAME)/usr/bin;
	$(CP) -r ./tmp/$(PKG_NAME) $(1)/usr/bin;
	rm -rf ./tmp;
endef

$(eval $(call BuildPackage,blynk-library))

