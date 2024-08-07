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

PYPI_NAME:=gpio
# hash of source code zip file on pypi
PKG_HASH:=4d2de56cfde25fb1a6d71dbd60da59698cc9dabe9bcabf3548aa8e22ecf1cea3

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Garrett Berg, Phil Howard (phil@pimoroni.com)

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-gpio
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=provides gpio access via the standard linux sysfs interface
  URL:=https://github.com/vitiral/gpio
  DEPENDS:=+python3-light
endef

define Package/python3-gpio/description
This library provides gpio access via the standard linux sysfs interface

It is intended to mimick RPIO as much as possible for all features, while also supporting additional (and better named) functionality to the same methods.
endef

$(eval $(call Py3Package,python3-gpio))
$(eval $(call BuildPackage,python3-gpio))