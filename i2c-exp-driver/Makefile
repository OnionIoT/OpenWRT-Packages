
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=i2c-exp-driver
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/i2c-exp-driver.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/liboniondebug
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library used to ease debug
endef

define Package/liboniondebug/description
Library used to ease debug
endef

define Package/libonioni2c
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library of I2C communication functions
	DEPENDS:=+liboniondebug
endef

define Package/libonioni2c/description
Library of I2C communication functions
endef

define Package/libonionmcp23008
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library of functions for MCP23008 chip
	DEPENDS:=+liboniondebug +libonioni2c
endef

define Package/libonionmcp23008/description
Library of functions for MCP23008 chips
endef

define Package/pwm-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Servo (PWM) Expansion
	DEPENDS:=+liboniondebug +libonioni2c
endef


define Package/pwm-exp/description
Driver for Servo (PWM) Expansion
endef


define Package/relay-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Relay Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionmcp23008
endef


define Package/relay-exp/description
Driver for Relay Expansion
endef


TARGET_CFLAGS += $(FPIC)
TARGET_LIBS += -l m

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIBS)"
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/include/onion-debug.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/liboniondebug.so $(1)/usr/lib/
	$(CP)   $(PKG_BUILD_DIR)/include/onion-i2c.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonioni2c.so $(1)/usr/lib/
	$(CP)   $(PKG_BUILD_DIR)/include/onion-mcp23008-driver.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonionmcp23008.so $(1)/usr/lib/
endef

define Package/liboniondebug/install
	# install the static library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) 	$(PKG_BUILD_DIR)/lib/liboniondebug.so $(1)/usr/lib/
endef

define Package/libonioni2c/install
	# install the static library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) 	$(PKG_BUILD_DIR)/lib/libonioni2c.so $(1)/usr/lib/
endef

define Package/libonionmcp23008/install
        # install the static library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) 	$(PKG_BUILD_DIR)/lib/libonionmcp23008.so $(1)/usr/lib/
endef

define Package/pwm-exp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/pwm-exp $(1)/usr/sbin/
endef

define Package/relay-exp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/relay-exp $(1)/usr/sbin/
endef


$(eval $(call BuildPackage,liboniondebug))
$(eval $(call BuildPackage,libonioni2c))
$(eval $(call BuildPackage,libonionmcp23008))
$(eval $(call BuildPackage,pwm-exp))
$(eval $(call BuildPackage,relay-exp))

