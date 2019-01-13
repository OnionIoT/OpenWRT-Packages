#
# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-sparkfun-qwiic
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/OnionIoT/oos-app-qwiic.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/oos-app-sparkfun-qwiic
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=Sparkfun Qwiic : Detect and interact with Sparkfun Qwiic devices
	DEPENDS:=+libonioni2c +libmosquitto
endef


define Package/oos-app-sparkfun-qwiic/description
Sparkfun Qwiic : Detect and interact with Sparkfun Qwiic devices
endef

define Package/oos-app-sparkfun-qwiic/install
	$(INSTALL_DIR) $(1)/www/apps/oos-app-sparkfun-qwiic $(1)/usr/bin $(1)/etc/init.d
	# copy the web site files
	$(CP) -r $(PKG_BUILD_DIR)/omega/www/* $(1)/www/apps/oos-app-sparkfun-qwiic/
	# install the program
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/src/sparkfun-qwiic $(1)/usr/bin/
	# install the init.d scripts
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/init.d/oos-qwiic-amg8833 $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/init.d/oos-qwiic-env $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/init.d/oos-qwiic-vl53l1x $(1)/etc/init.d/
endef


# calls to build each package
$(eval $(call BuildPackage,oos-app-sparkfun-qwiic))
