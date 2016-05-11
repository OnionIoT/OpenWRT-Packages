
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=transmission-console-app
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/transmission-console-app.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion Console App for the Transmission BitTorrent Client Web Interface
	DEPENDS:=+Onion-Console +transmission-daemon +transmission-web
endef


define Package/$(PKG_NAME)/description
Onion Console App for the Transmission BitTorrent Client Web Interface
endef

define Package/$(PKG_NAME)/install
	# install the app
	$(INSTALL_DIR) $(1)/www/apps/onion-transmission-client/
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-transmission-client/* $(1)/www/apps/onion-transmission-client/.
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

