
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-repo-keys
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/OpenWRT-Repo.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

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

define Package/$(PKG_NAME)/install
	mkdir -p $(1)/etc/opkg/keys
	$(CP) $(PKG_BUILD_DIR)/keys/onion-key.pub $(1)/etc/opkg/keys/`$(STAGING_DIR_HOST)/bin/usign -F -p $(PKG_BUILD_DIR)/keys/onion-key.pub`
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

