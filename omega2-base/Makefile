# Copyright (C) 2019 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-base
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


#PKG_SOURCE_PROTO:=git
#PKG_SOURCE_VERSION:=HEAD
#PKG_SOURCE_URL:=https://github.com/OnionIoT/omega2-pro.git
#PKG_SOURCE_SUBDIR:=$(PKG_NAME)
#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# python module package
define Package/omega2-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family base packages and configuration
	#DEPENDS:=
endef

define Package/omega2-pro/description
Omega2 family base packages and configuration
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef


define Package/omega2-base/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/hotplug.d/usb/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/hotplug.d/usb/20-autorun.sh $(1)/etc/hotplug.d/usb/20-autorun
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/usbAutorun.sh  $(1)/usr/bin/usbAutorun
endef

$(eval $(call BuildPackage,omega2-base))
