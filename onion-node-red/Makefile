#Copyright (C) 2016 Onion Corporation
#
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
##OPENWRT PACKAGE MAKEFILE FOR  node-red

include $(TOPDIR)/rules.mk
PKG_NAME:= onion-node-red
PKG_VERSION:=1.2.9
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=v1.2.9
PKG_SOURCE_URL:=https://github.com/OnionIoT/node-red.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/onion-node-red
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Node-RED
	TITLE:=Flow-based development tool for visual programming
	DEPENDS:= +libc +libpthread +libstdcpp +node
endef


define Package/onion-node-red/description
Flow-based development tool for visual programming
endef


define Package/onion-node-red/install
	$(INSTALL_DIR) $(1)/usr/lib/node_modules/ $(1)/etc/init.d/
	$(CP) -r $(PKG_BUILD_DIR)/node_modules/node-red/ $(1)/usr/lib/node_modules/node-red/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init.d/nodered $(1)/etc/init.d/nodered
endef

$(eval $(call BuildPackage,onion-node-red))
