#
# Copyright (C) 2018 Onion Corporation
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=url-enc-dec
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_SOURCE_URL=https://github.com/OnionIoT/url-enc-dec.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)


include $(INCLUDE_DIR)/package.mk


define Package/url-enc-dec
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Command line tools for URL encoding and decoding strings
	DEPENDS:=+libcurl
endef


TARGET_LIB += -lcurl
TARGET_CFLAGS += $(FPIC) 


define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)"
endef

define Package/url-enc-dec/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/bin/urlencode $(1)/usr/bin/
	$(CP) $(PKG_BUILD_DIR)/bin/urldecode $(1)/usr/bin/
endef


$(eval $(call BuildPackage,url-enc-dec))
