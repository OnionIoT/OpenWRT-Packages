
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=arduino-dock
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/arduino-dock.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Tool to enable I2C flashing of HEX files
endef


define Package/$(PKG_NAME)/description
Tool to enable I2C flashing of HEX files
endef


define Package/$(PKG_NAME)/install
	# copy the other assorted files
	$(INSTALL_DIR) $(1)/usr/share/arduino-dock
	$(CP) $(PKG_BUILD_DIR)/conf/dock.conf $(1)/usr/share/arduino-dock/dock.conf
	$(CP) $(PKG_BUILD_DIR)/conf/avrdude/avrdude.conf $(1)/usr/share/arduino-dock/avrdude.conf
	$(CP) $(PKG_BUILD_DIR)/twibootloader/twiboot.hex $(1)/usr/share/arduino-dock/twibootloader.hex
	$(INSTALL_DIR) $(1)/etc/avahi/services
	$(CP) $(PKG_BUILD_DIR)/conf/avahi/arduino.service $(1)/etc/avahi/services/arduino.service
	# install scripts
	$(INSTALL_DIR) $(1)/usr/bin
	# twidude utility
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/twidude/bin/twidude $(1)/usr/bin/
	# sh library
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/arduino-dock-lib.sh $(1)/usr/share/arduino-dock/arduino-dock-lib.sh
	# run-avrdude script for Arduino IDE
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/run-avrdude.sh $(1)/usr/bin/run-avrdude
	# arduino dock setup script
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/arduino-dock.sh $(1)/usr/bin/arduino-dock
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

