
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-helper
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/onion-helper.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


# application package
define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=C-based ubus service to implement various features on OpenWRT
	DEPENDS:=+libubox +libubus +libcurl
endef

define Package/$(PKG_NAME)/description
C-based ubus service to implement various features on OpenWRT
endef


TARGET_LIB += -lubox -lubus -lcurl

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)"
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/etc/init.d
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/onion-helper $(1)/usr/sbin/
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/tester $(1)/usr/sbin/
	# install the init.d script
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init.d/onion-helper.sh $(1)/etc/init.d/onion-helper
endef



$(eval $(call BuildPackage,$(PKG_NAME)))

