# Copyright (C) 2019 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-nodered
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


#PKG_SOURCE_PROTO:=git
#PKG_SOURCE_VERSION:=HEAD
#PKG_SOURCE_URL:=https://github.com/OnionIoT/oos-app-nodered.git
#PKG_SOURCE_SUBDIR:=$(PKG_NAME)
#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# python module package
define Package/oos-app-nodered
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=Node-Red : Node-Red Graphical Programming interface [Omega2 Pro]
	DEPENDS:=+onion-node-red
endef

define Package/oos-app-nodered/description
Node-Red : Node-Red Graphical Programming interface [Omega2 Pro]
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef


define Package/oos-app-nodered/install
	$(INSTALL_DIR) $(1)/www/apps/oos-app-nodered
	$(CP) $(PKG_BUILD_DIR)/app.json $(1)/www/apps/oos-app-nodered/
	$(CP) $(PKG_BUILD_DIR)/icon.svg $(1)/www/apps/oos-app-nodered/
endef

$(eval $(call BuildPackage,oos-app-nodered))
