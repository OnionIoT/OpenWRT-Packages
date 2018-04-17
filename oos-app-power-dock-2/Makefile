#
# Copyright (C) 2018 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-power-dock-2
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/OnionIoT/OOS-App-Power-Dock-2.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/oos-app-power-dock-2
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=OnionOS App for logging battery level with the Power Dock 2
	DEPENDS:=+power-dock2
endef


define Package/oos-app-power-dock-2/description
OnionOS App for logging battery level with the Power Dock 2
endef

define Package/oos-app-power-dock-2/install
	# install the scripts
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/etc/init.d/power-dock-2 $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/getBatteryLevels.sh $(1)/usr/bin/getBatteryLevels
	# copy the web site files
	$(INSTALL_DIR) $(1)/www/apps/power-dock-2-app
	$(CP) -r $(PKG_BUILD_DIR)/omega/www/* $(1)/www/apps/power-dock-2-app/
endef


# calls to build each package
$(eval $(call BuildPackage,oos-app-power-dock-2))
