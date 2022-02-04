# Copyright (C) 2021 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-base
PKG_VERSION:=0.4.0
PKG_RELEASE:=302


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/omega2-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family base packages and configuration
	DEPENDS:=+block-mount +blockd +ca-certificates +kmod-nls-cp437 +kmod-nls-iso8859-1 +kmod-nls-utf8 +kmod-sdhci +kmod-spi-dev +kmod-usb-storage +kmod-usb-storage-extras +wget
endef

define Package/omega2-base/description
Omega2 family base packages and configuration
endef

define Package/omega2-base-files
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family base configuration files
	#DEPENDS:=
endef

define Package/omega2-base-files/description
Omega2 family base configuration files
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef


define Package/omega2-base/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/omega2selfreport.sh  $(1)/usr/bin/omega2selfreport
endef

define Package/omega2-base-files/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/12_onion_defaults $(1)/etc/uci-defaults/12_onion_defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/13_hostname $(1)/etc/uci-defaults/13_hostname
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/14_banner $(1)/etc/uci-defaults/14_banner
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/15_network $(1)/etc/uci-defaults/15_network
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/16_block_mount $(1)/etc/uci-defaults/16_block_mount
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/98_opkg $(1)/etc/uci-defaults/98_opkg
endef

$(eval $(call BuildPackage,omega2-base))
$(eval $(call BuildPackage,omega2-base-files))
