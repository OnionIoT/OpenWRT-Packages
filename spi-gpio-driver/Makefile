
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=spi-gpio-driver
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/spi-gpio-driver.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# library packages
define Package/libonionspi
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library of SPI communication functions
	DEPENDS:=+liboniondebug
endef

define Package/libonionspi/description
Library of SPI communication functions
endef

# application package
define Package/spi-tool
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Tool to read and write using an SPI interface
	DEPENDS:=+liboniondebug +libonionspi
endef

define Package/spi-tool/description
Tool to read and write using an SPI interface
endef

# python module package
define Package/pyOnionSpi
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to implement communication via the SPI protocol
	DEPENDS:=+python-base +liboniondebug +libonionspi
endef

define Package/pyOnionSpi/description
Python module to implement communication via the SPI protocol
endef

PYTHON_VERSION = "2.7"
TARGET_LIB += -loniondebug -lonionspi
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
	mkdir -p $(1)/usr/include $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/include/onion-spi.h $(1)/usr/include/
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionspi.so $(1)/usr/lib/
endef

define Package/libonionspi/install
	# install the static library object 
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionspi.so $(1)/usr/lib/
endef

define Package/spi-tool/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/spi-tool $(1)/usr/bin/
endef

define Package/pyOnionSpi/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION)
	$(CP)   $(PKG_BUILD_DIR)/lib/python/onionSpi.so $(1)/usr/lib/python$(PYTHON_VERSION)
endef


$(eval $(call BuildPackage,libonionspi))
$(eval $(call BuildPackage,spi-tool))
$(eval $(call BuildPackage,pyOnionSpi))

