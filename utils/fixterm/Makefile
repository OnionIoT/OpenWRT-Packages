#
# Copyright (C) 2015 Onion Corporation
# 
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=fixterm
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT-Packages/FixTerm.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)


include $(INCLUDE_DIR)/package.mk

define Package/fixterm
	SECTION:=utils
	CATEGORY:=Utilities
	SUBMENU:=Onion
	TITLE:=FixTerm
endef


define Package/fixterm/description
Terminal window size detection over serial connections
endef

define Package/fixterm/Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) $(PKG_NAME)
endef

define Package/fixterm/install
	$(INSTALL_DIR) $(1)/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fixterm $(1)/bin/fixterm
endef

$(eval $(call BuildPackage,fixterm))
