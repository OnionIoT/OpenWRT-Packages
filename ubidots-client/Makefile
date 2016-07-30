
# Copyright (C) 2016 Onion Corporation
# 
# Author: Zheng Han  <zh@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=ubidots-client
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/ubidots-client.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk


# application package
define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Network
	TITLE:=Client for sending data points to Ubidots cloud
	DEPENDS:=+libcurl +libjson-c 
endef

define Package/$(PKG_NAME)/description
Client for sending date points to Ubidots cloud
endef


TARGET_LIB += -lcurl -ljson-c 
TARGET_CFLAGS += $(FPIC)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)"
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/ubidots $(1)/usr/bin/
endef



$(eval $(call BuildPackage,$(PKG_NAME)))

