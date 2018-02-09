#
# Copyright (C) 2018 Onion Corporation
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=duktape
PKG_VERSION:=2.2.0
PKG_RELEASE:=1

PKG_SOURCE_URL=https://github.com/svaarala/duktape.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=a459cf3c9bd1779fc01b435d69302b742675a08f
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)


include $(INCLUDE_DIR)/package.mk


define Package/libduktape
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
  TITLE:=Duktape dynamic library
endef


TARGET_CFLAGS += $(FPIC) 

define Build/Prepare
	$(Build/Prepare/Default)
	$(INSTALL_DIR) $(PKG_BUILD_DIR)/output
	/usr/bin/python $(PKG_BUILD_DIR)/tools/configure.py --output-directory $(PKG_BUILD_DIR)/output --dll
endef

define Build/Compile
	#$(call Build/Compile/Default,)
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -shared -Wall -Werror -o $(PKG_BUILD_DIR)/output/duktape.so $(PKG_BUILD_DIR)/output/duktape.c
endef

define Package/libduktape/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/output/duktape.so $(1)/usr/lib/
endef


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/output/duktape.h $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/output/duk_config.h $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/output/duktape.so $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libduktape))
