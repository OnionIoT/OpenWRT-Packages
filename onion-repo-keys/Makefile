
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-repo-keys
PKG_VERSION:=22.03.2
PKG_RELEASE:=1

#PKG_FILE_DEPENDS:=$(PLATFORM_DIR)/ $(GENERIC_PLATFORM_DIR)/base-files/
PKG_BUILD_DEPENDS:=opkg/host usign/host
PKG_LICENSE:=GPL-2.0

PKG_CONFIG_DEPENDS := CONFIG_SIGNED_PACKAGES

include $(INCLUDE_DIR)/package.mk


define Package/onion-repo-keys
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Signature keys required for Onion Package Repo
	DEPENDS:=+SIGNED_PACKAGES:usign
endef


define Package/$(PKG_NAME)/description
Signature keys required for Onion Package Repo
endef

## to do: add functionality to generate key files if they do not exist
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile

endef

define Package/$(PKG_NAME)/install
	mkdir -p $(1)/etc/opkg/keys
	# $(CP) ./files/onion-key.pub $(1)/etc/opkg/keys/`$(STAGING_DIR_HOST)/bin/usign -F -p ./files/onion-key.pub`
	# $(CP) ./files/omega2-repo.pub $(1)/etc/opkg/keys/`$(STAGING_DIR_HOST)/bin/usign -F -p ./files/omega2-repo.pub`
	$(CP) ./files/openwrt21.pub $(1)/etc/opkg/keys/`$(STAGING_DIR_HOST)/bin/usign -F -p ./files/openwrt21.pub`
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

