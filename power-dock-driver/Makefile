
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=power-dock-driver
PKG_VERSION:=0.0
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/power-dock.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# library packages
define Package/libonionpowerdock
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library of PowerDock Related Functions
	DEPENDS:=+liboniondebug + libugpio
endef

define Package/libonionpowerdock/description
Library of PowerDock Related Functions
endef


# application packages
define Package/PowerDock
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Power Dock Expansion
	DEPENDS:=+liboniondebug + libugpio
endef


define Package/PowerDock/description
Driver for Power Dock Expansion
endef





TARGET_CFLAGS += $(FPIC)
TARGET_LIBS += -l m

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIBS)" \
	PYINC="$(TARGET_PYINC)"
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/include/powerdock-exp.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonionpowerdock.so $(1)/usr/lib/

endef

define Package/libonionpowerdock/install
	# install the dynamic library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) 	$(PKG_BUILD_DIR)/lib/libonionpowerdock.so $(1)/usr/lib/
endef



$(eval $(call BuildPackage,libonionpowerdock))
