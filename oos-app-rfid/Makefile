#
# Copyright (C) 2018 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-nfc-exp
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/OnionIoT/OOS-App-RFID.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/oos-app-nfc-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=OnionOS App for the NFC & RFID Expansion
	DEPENDS:=+nfc-exp
endef


define Package/oos-app-nfc-exp/description
OnionOS App for the NFC & RFID Expansion 
endef

define Package/oos-app-nfc-exp/install
	# install the scripts
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/rfid-scan.sh $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/etc/init.d/rfid-scan $(1)/etc/init.d/
	# copy the web site files
	$(INSTALL_DIR) $(1)/www/apps/nfc-rfid-exp
	$(CP) -r $(PKG_BUILD_DIR)/omega/www/* $(1)/www/apps/nfc-rfid-exp/
endef


# calls to build each package
$(eval $(call BuildPackage,oos-app-nfc-exp))
