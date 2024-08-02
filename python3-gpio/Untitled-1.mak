#
# Copyright (C) 2024 Lazar Demin (lazar@onioniot.com)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-gpio
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PYPI_NAME:=gpio
PKG_HASH:=fd8e954321abf2746057f7a4085ba47a5a552e60

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Garrett Berg, Phil Howard (phil@pimoroni.com)

include ../pypi.mk
include $(INCLUDE_DIR)/package.mk
include ../python3-package.mk

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