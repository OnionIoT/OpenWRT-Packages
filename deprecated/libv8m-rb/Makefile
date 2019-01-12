
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=libv8m-rb
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/v8m-rb.git -b dm-dev-mipsbe
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Port of Google v8 Javascript engine to MIPS architecture
endef


define Package/$(PKG_NAME)/description
Port of Google v8 Javascript engine to MIPS architecture
endef

define Build/Configure
	# running configure
	svn checkout --force http://gyp.googlecode.com/svn/trunk $(PKG_BUILD_DIR)/build/gyp \
		--revision 1282
endef

define Build/Compile
	# running compile
	$(call Build/Compile/Default, \
		werror="no" \
		mips.release \
		library="shared" \
		snapshot="off")
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/out/mips.release/lib.target/libv8.so $(1)/usr/lib
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

