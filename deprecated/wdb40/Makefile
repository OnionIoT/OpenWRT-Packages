
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=wdb40
PKG_VERSION:=0.2
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/wdb40.git
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
	TITLE:=Wireless network management utility
	DEPENDS:=$(CXX_DEPENDS) +libiwinfo +libuci +libubus +libblobmsg-json
endef

define Package/$(PKG_NAME)/description
Wireless network management utility
endef


TARGET_LIB += -liwinfo -luci -lubus -lubox -lblobmsg_json
TARGET_CXXFLAGS += $(FPIC)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CXX="$(TARGET_CXX)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)" \
	DEVICE_TYPE="$(CONFIG_TARGET_BOARD)"
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the C++ binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/wdb40tool $(1)/usr/bin/
	# install the scripts
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/wdb40.sh $(1)/usr/bin/wdb40
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/wdb40setup.sh $(1)/usr/bin/wifisetup
	# install the init.d script
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init.d/wdb40d.sh $(1)/etc/init.d/wdb40d
endef



$(eval $(call BuildPackage,$(PKG_NAME)))

