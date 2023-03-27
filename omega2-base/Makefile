# Copyright (C) 2021 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-base
PKG_VERSION:=22.03.2
PKG_RELEASE:=102


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/omega2-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family base packages and configuration
	DEPENDS:=\
		+ca-certificates +wget \
		+block-mount +blockd +fdisk +e2fsprogs +kmod-mmc +kmod-usb-storage \
		+kmod-fs-vfat +kmod-fs-ext4 +kmod-nls-cp437 +kmod-nls-iso8859-1 +kmod-nls-utf8 \
		+kmod-sdhci +kmod-spi-dev \
		+kmod-i2c-mt7628 +i2c-tools
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

define Package/omega2-usb-autorun
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family USB autorun package
	#DEPENDS:=
endef

define Package/omega2-usb-autorun/description
Omega2 family USB autorun package
endef

define Package/omega2-base-passwd
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 family password configuration
	#DEPENDS:=
endef

define Package/omega2-base-passwd/description
Omega2 family base configuration for default password files
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef

define Package/omega2-base/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/omega2selfreport.sh  $(1)/usr/bin/omega2selfreport
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/lib/ramips.sh $(1)/lib/ramips.sh
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/gpio-lookup $(1)/usr/bin/gpio-lookup
endef

define Package/omega2-base-files/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/12_onion_defaults $(1)/etc/uci-defaults/12_onion_defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/13_hostname $(1)/etc/uci-defaults/13_hostname
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/14_banner $(1)/etc/uci-defaults/14_banner
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/15_network $(1)/etc/uci-defaults/15_network
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/16_block_mount $(1)/etc/uci-defaults/16_block_mount
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/20_onion_sysupgrade $(1)/etc/uci-defaults/20_onion_sysupgrade
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/uci-defaults/98_opkg $(1)/etc/uci-defaults/98_opkg
endef

define Package/omega2-usb-autorun/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/hotplug.d/usb/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/hotplug.d/usb/20-autorun.sh $(1)/etc/hotplug.d/usb/20-autorun
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/usbAutorun.sh  $(1)/usr/bin/usbAutorun
endef

define Package/omega2-base-passwd/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/passwd $(1)/etc/passwd
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/shadow $(1)/etc/shadow
endef

$(eval $(call BuildPackage,omega2-base))
$(eval $(call BuildPackage,omega2-base-files))
$(eval $(call BuildPackage,omega2-base-passwd))
$(eval $(call BuildPackage,omega2-usb-autorun))
