# Copyright (C) 2021 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-base
PKG_VERSION:=1.0.0
PKG_RELEASE:=2


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/omega2-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family base packages and configuration
	DEPENDS:=+block-mount +blockd +ca-certificates +kmod-nls-cp437 +kmod-nls-iso8859-1 +kmod-nls-utf8 +kmod-sdhci +kmod-spi-dev +kmod-usb-storage +kmod-usb-storage-extras +odhcpd +wget
endef

define Package/omega2-base/description
Omega2 family base packages and configuration
endef

$(eval $(call BuildPackage,omega2-base))
