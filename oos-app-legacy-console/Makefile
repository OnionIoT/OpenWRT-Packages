#
# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-legacy-console
PKG_VERSION:=0.1.4
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk


define Package/oos-app-legacy-console
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=Legacy Console : The first generation Onion Console
	DEPENDS:=+onion-console-base
endef


define Package/$(PKG_NAME)/description
Legacy Console : The first generation Onion Console
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile

endef

define Package/$(PKG_NAME)/install
# install the scripts
$(INSTALL_DIR) $(1)/www/apps/oos-app-legacy-console
# copy the web site files
$(CP) ./files/app.json $(1)/www/apps/oos-app-legacy-console/
$(CP) ./files/icon.svg $(1)/www/apps/oos-app-legacy-console/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
