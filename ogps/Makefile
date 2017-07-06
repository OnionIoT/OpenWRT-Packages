#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ogps
PKG_VERSION:=2017-04-20
PKG_RELEASE=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/ogps.git
PKG_SOURCE_PROTO:=git

PKG_MAINTAINER:=Lazar Demin <lazar@onion.io>
PKG_LICENSE:=GPL-2.0+

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/ogps
  SECTION:=onion
  CATEGORY:=Onion
  SUBMENU:=Utilities
  TITLE:=OpenWrt GPS Daemon
  DEPENDS:=+libubox +libubus
endef

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include

ifneq ($(CONFIG_USE_GLIBC),)
  TARGET_CFLAGS += -D_DEFAULT_SOURCE
endif

define Package/ogps/conffiles
/etc/config/gps
endef

define Package/ogps/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ugps $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/ugps.init $(1)/etc/init.d/ugps
	$(INSTALL_CONF) ./files/gps.config $(1)/etc/config/gps
endef

$(eval $(call BuildPackage,ogps))
