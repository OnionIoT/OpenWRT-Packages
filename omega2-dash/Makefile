# Copyright (C) 2019 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-dash-base
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/omega2-dash-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 Dash base packages and configuration
	DEPENDS:=+kmod-fb +kmod-fbtft-support +kmod-fbtft-ili9341
endef

define Package/omega2-dash-base/description
Omega2 Dash base packages and configuration
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef


define Package/omega2-dash-base/install
	$(INSTALL_DIR) $(1)/etc/modules.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/08-fbtft-device $(1)/etc/modules.d/08-fbtft-device
endef

$(eval $(call BuildPackage,omega2-dash-base))
