# Copyright (C) 2019 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-base
PKG_VERSION:=1.0.1
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/omega2-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family base packages and configuration
	#DEPENDS:=
endef

define Package/omega2-base/description
Omega2 family base packages and configuration
endef

define Package/omega2-usb-autorun
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family USB autorun package
	#DEPENDS:=
endef

define Package/omega2-usb-autorun/description
Omega2 family USB autorun package
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef


define Package/omega2-base/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/omega2selfreport.sh  $(1)/usr/bin/omega2selfreport
endef

define Package/omega2-usb-autorun/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/hotplug.d/usb/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/hotplug.d/usb/20-autorun.sh $(1)/etc/hotplug.d/usb/20-autorun
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/usbAutorun.sh  $(1)/usr/bin/usbAutorun
endef

$(eval $(call BuildPackage,omega2-base))
$(eval $(call BuildPackage,omega2-usb-autorun))