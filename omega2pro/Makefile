# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-pro
PKG_VERSION:=1.0.3
PKG_RELEASE:=1


#PKG_SOURCE_PROTO:=git
#PKG_SOURCE_VERSION:=HEAD
#PKG_SOURCE_URL:=https://github.com/OnionIoT/omega2-pro.git
#PKG_SOURCE_SUBDIR:=$(PKG_NAME)
#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# python module package
define Package/omega2-pro-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Omega2 Pro base packages and configuration
	DEPENDS:=+fdisk +e2fsprogs +block-mount +swap-utils +tar @TARGET_DEVICE_ramips_mt76x8_DEVICE_omega2pro
endef

define Package/omega2-pro/description
Omega2 Pro base packages and configuration
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef


define Package/omega2-pro-base/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/o2-pro-init.sh  $(1)/usr/bin/o2-pro-init
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/initd.sh $(1)/etc/init.d/o2-pro-init
endef

$(eval $(call BuildPackage,omega2-pro-base))
