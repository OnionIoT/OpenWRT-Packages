
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-st7735-driver
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/onion-st7735-driver.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# library packages
define Package/libonionst7735
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library for TFT ST7735 Driver
	DEPENDS:=+liboniondebug +libonionspi +libugpio
endef

define Package/libonionst7725/description
Library for TFT ST7735 Driver
endef

# application package
define Package/st7735-test
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Tool to test TFT ST7735 Driver
	DEPENDS:=+liboniondebug +libonionst7735
endef

define Package/st7735-test/description
Tool to test TFT ST7735 Driver
endef

# python module package
define Package/pyOnionSt7735
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to implement driver for TFT ST7735 
	DEPENDS:=+python-base +liboniondebug +libonionspi +libonionst7735
endef

define Package/pyOnionSt7735/description
Python module to implement driver for TFT ST7735
endef

PYTHON_VERSION = "2.7"
TARGET_LIB += -loniondebug -lonionspi -lonionst7735 -lugpio
TARGET_CFLAGS += $(FPIC)
TARGET_PYINC += "-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION)"

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)" \
	PYINC="$(TARGET_PYINC)"

#	PYVER="$(PYTHON_VERSION)"
endef

define Build/InstallDev
	mkdir -p $(STAGING_DIR)/usr/include $(STAGING_DIR)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/include/onion-st7735-driver.h $(STAGING_DIR)/usr/include/
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionst7735.so $(STAGING_DIR)/usr/lib/
endef

define Package/libonionst7735/install
	# install the static library object 
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionst7735.so $(1)/usr/lib/
endef

define Package/st7735-test/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/st7735-test $(1)/usr/bin/
endef

define Package/pyOnionSt7735/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION)
	$(CP)   $(PKG_BUILD_DIR)/lib/python/onionSt7735.so $(1)/usr/lib/python$(PYTHON_VERSION)
endef


$(eval $(call BuildPackage,libonionst7735))
$(eval $(call BuildPackage,st7735-test))
$(eval $(call BuildPackage,pyOnionSt7735))

