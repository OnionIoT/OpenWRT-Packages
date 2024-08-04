# Copyright (C) 2024 Onion Corporation
#
# Author: Lazar Demin  <lazar@onioniot.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=python3-gpio
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/vitiral/gpio.git
PKG_SOURCE_VERSION:=fd8e954321abf2746057f7a4085ba47a5a552e60
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-gpio
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python3 module that provides gpio access via the standard linux sysfs interface
	DEPENDS:=+python3-base
endef

define Package/python3-gpio/description
	Python3 module that provides gpio access via the standard linux sysfs interface
endef

TARGET_CFLAGS += $(FPIC)
TARGET_LIBS += -l m

MAKE_FLAGS += \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIBS)" \
	PYTHON=$(PYTHON3) \
	PYINC="-I $(PYTHON3_INC_DIR)" \
	PYLIBS="-lpython$(PYTHON3_VERSION)" \
	PYTHON_VERSION=$(PYTHON3_VERSION) \
	$(PYTHON3_VARS)

define Build/Compile
	$(CP) ./files/* $(PKG_BUILD_DIR)/
	$(MAKE) -C $(PKG_BUILD_DIR) $(MAKE_FLAGS)
endef

define Package/python3-gpio/install
	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)/gpio
	$(CP) $(PKG_BUILD_DIR)/gpio/__init__.py $(1)$(PYTHON3_PKG_DIR)/gpio/__init__.py
endef

define Build/Install
	true
endef

$(eval $(call BuildPackage,python3-gpio))
