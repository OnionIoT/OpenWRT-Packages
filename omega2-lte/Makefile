# Copyright (C) 2019 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-lte-base
PKG_VERSION:=1.0.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/quectel-cm.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/omega2-lte-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Base system
	TITLE:=Omega2 LTE base packages and configuration
	DEPENDS:=+usb-modeswitch +kmod-mii +kmod-usb-net +kmod-usb-wdm +kmod-usb-net-qmi-wwan +ogps
endef

define Package/omega2-lte-base/description
Omega2 LTE base packages and configuration
endef


TARGET_CFLAGS += $(FPIC) 

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)"
endef

define Package/omega2-lte-base/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/quectel-CM $(1)/usr/bin/lted
	$(INSTALL_BIN) ./files/lted-run.sh  $(1)/usr/bin/lted-run
	$(INSTALL_BIN) ./files/init.d/lted.sh  $(1)/etc/init.d/lted
	$(INSTALL_BIN) ./files/omega2-lte.sh  $(1)/usr/bin/o2lte
endef

$(eval $(call BuildPackage,omega2-lte-base))
