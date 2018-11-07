
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=i2c-exp-driver
PKG_VERSION:=0.9
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/i2c-exp-driver.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# library packages
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

define Package/libonionpwmexp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library of functions to control the Onion PWM Expansion
	DEPENDS:=+liboniondebug +libonioni2c
endef

define Package/libonionpwmexp/description
Library of functions to control the PWM Expansion
endef

define Package/libonionrelayexp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library of functions to control the Onion Relay Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionmcp23008
endef

define Package/libonionrelayexp/description
Library of functions to control the Onion Relay Expansion
endef

define Package/libonionoledexp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library of functions to control the Onion OLED Expansion
	DEPENDS:=+liboniondebug +libonioni2c 
endef

define Package/libonionoledexp/description
Library of functions to control the Onion OLED Expansion
endef


# application packages
define Package/pwm-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Servo (PWM) Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionpwmexp
endef


define Package/pwm-exp/description
Driver for Servo (PWM) Expansion
endef


define Package/relay-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Relay Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionmcp23008 +libonionrelayexp
endef


define Package/relay-exp/description
Driver for Relay Expansion
endef


define Package/oled-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for OLED Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionoledexp
endef


define Package/oled-exp/description
Driver for OLED Expansion
endef


# ubus integration package
define Package/i2c-exp-ubus
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=I2C-based Expansion ubus integration 
	DEPENDS:=+rpcd +onion-sh-lib +pwm-exp +relay-exp
endef

define Package/i2c-exp-ubus/description
I2C-based Expansion ubus integration
endef	


# python module packages
define Package/pyOmegaExpansion
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Setup for OmegaExpansion Python Package
	DEPENDS:=+python-base
endef

define Package/pyOmegaExpansion/description
Setup for OmegaExpansion Python Package
endef

define Package/pyOnionI2C
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module with object that implements I2C transactions
	DEPENDS:=+liboniondebug +libonioni2c +python-base +pyOmegaExpansion
endef

define Package/pyOnionI2C/description
Python module with object that implements I2C transactions
endef

define Package/pyPwmExp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to control the Onion PWM Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionpwmexp +python-base +pyOmegaExpansion
endef

define Package/pyPwmExp/description
Python module to control the Onion PWM Expansion
endef

define Package/pyRelayExp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to control the Onion Relay Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionmcp23008 +libonionrelayexp +python-base +pyOmegaExpansion
endef

define Package/pyRelayExp/description
Python module to control the Onion Relay Expansion
endef

define Package/pyOledExp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to control the Onion OLED Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionoledexp +python-base +pyOmegaExpansion
endef

define Package/pyOledExp/description
Python module to control the Onion OLED Expansion
endef

define Package/python3-omega-expansion
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Setup for OmegaExpansion Python3 Package
	DEPENDS:=+python3-base
endef

define Package/python3-omega-expansion/description
Setup for OmegaExpansion Python3 Package
endef

define Package/python3-onion-i2c
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python3 module that implements I2C transactions
	DEPENDS:=+liboniondebug +libonioni2c +python3-base +python3-omega-expansion
endef

define Package/python3-onion-i2c/description
Python3 module that implements I2C transactions
endef

define Package/python3-pwm-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python3 module to control the Onion PWM Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionpwmexp +python3-base +python3-omega-expansion
endef

define Package/python3-pwm-exp/description
Python3 module to control the Onion PWM Expansion
endef

define Package/python3-relay-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python3 module to control the Onion Relay Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionmcp23008 +libonionrelayexp +python3-base +python3-omega-expansion
endef

define Package/python3-relay-exp/description
Python3 module to control the Onion Relay Expansion
endef

define Package/python3-oled-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python3 module to control the Onion OLED Expansion
	DEPENDS:=+liboniondebug +libonioni2c +libonionoledexp +python3-base +python3-omega-expansion
endef

define Package/python3-oled-exp/description
Python3 module to control the Onion OLED Expansion
endef

PYTHON_VERSION_2_7:=2.7
TARGET_PYINC_2_7 += "-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_2_7)/"
PYTHON_VERSION_3_6:=3.6
TARGET_PYINC_3_6 += "-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_3_6)/"
TARGET_CFLAGS += $(FPIC)
TARGET_LIBS += -l m

define Build/Compile
	$(MAKE) -B -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIBS)" \
	PYINC="$(TARGET_PYINC_2_7)" \
	PYTHON_VERSION="$(PYTHON_VERSION_2_7)"

	$(MAKE) -B -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIBS)" \
	PYINC="$(TARGET_PYINC_3_6)" \
	PYTHON_VERSION="$(PYTHON_VERSION_3_6)"
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/include/onion-debug.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/liboniondebug.so $(1)/usr/lib/
	$(CP)   $(PKG_BUILD_DIR)/include/onion-i2c.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonioni2c.so $(1)/usr/lib/
	$(CP)   $(PKG_BUILD_DIR)/include/onion-mcp23008-driver.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonionmcp23008.so $(1)/usr/lib/
	$(CP)   $(PKG_BUILD_DIR)/include/pwm-exp.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonionpwmexp.so $(1)/usr/lib/
	$(CP)   $(PKG_BUILD_DIR)/include/relay-exp.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonionrelayexp.so $(1)/usr/lib/
	$(CP)   $(PKG_BUILD_DIR)/include/oled-exp.h $(1)/usr/include/
	$(CP)	$(PKG_BUILD_DIR)/lib/libonionoledexp.so $(1)/usr/lib/
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

define Package/libonionpwmexp/install
	# install the static library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) 	$(PKG_BUILD_DIR)/lib/libonionpwmexp.so $(1)/usr/lib/
endef

define Package/libonionrelayexp/install
	# install the static library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) 	$(PKG_BUILD_DIR)/lib/libonionrelayexp.so $(1)/usr/lib/
endef

define Package/libonionoledexp/install
	# install the static library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) 	$(PKG_BUILD_DIR)/lib/libonionoledexp.so $(1)/usr/lib/
endef


define Package/pwm-exp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/pwm-exp $(1)/usr/sbin/
endef

define Package/relay-exp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/relay-exp $(1)/usr/sbin/
endef

define Package/oled-exp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/oled-exp $(1)/usr/sbin/
endef


define Package/i2c-exp-ubus/install
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rpcd/i2c-exp.sh $(1)/usr/libexec/rpcd/i2c_exp
endef



define Package/pyOmegaExpansion/install
	# setup the OmegaExpansion package
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
	touch $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion/__init__.py
endef

define Package/pyOnionI2C/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_2_7)/onionI2C.so $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
endef

define Package/pyPwmExp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_2_7)/pwmExp.so $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
	$(CP)	$(PKG_BUILD_DIR)/src/python/omegaMotors.py $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion/
endef

define Package/pyRelayExp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_2_7)/relayExp.so $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
endef

define Package/pyOledExp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_2_7)/oledExp.so $(1)/usr/lib/python$(PYTHON_VERSION_2_7)/OmegaExpansion
endef

define Package/python3-omega-expansion/install
	# setup the OmegaExpansion package
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
	touch $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion/__init__.py
endef

define Package/python3-onion-i2c/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_3_6)/onionI2C.so $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
endef

define Package/python3-pwm-exp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_3_6)/pwmExp.so $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
	$(CP)	$(PKG_BUILD_DIR)/src/python/omegaMotors.py $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion/
endef

define Package/python3-relay-exp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_3_6)/relayExp.so $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
endef

define Package/python3-oled-exp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
	$(CP)   $(PKG_BUILD_DIR)/lib/python$(PYTHON_VERSION_3_6)/oledExp.so $(1)/usr/lib/python$(PYTHON_VERSION_3_6)/OmegaExpansion
endef


$(eval $(call BuildPackage,liboniondebug))
$(eval $(call BuildPackage,libonioni2c))
$(eval $(call BuildPackage,libonionmcp23008))
$(eval $(call BuildPackage,libonionpwmexp))
$(eval $(call BuildPackage,libonionrelayexp))
$(eval $(call BuildPackage,libonionoledexp))
$(eval $(call BuildPackage,pwm-exp))
$(eval $(call BuildPackage,relay-exp))
$(eval $(call BuildPackage,oled-exp))
$(eval $(call BuildPackage,i2c-exp-ubus))
$(eval $(call BuildPackage,pyOmegaExpansion))
$(eval $(call BuildPackage,pyOnionI2C))
$(eval $(call BuildPackage,pyPwmExp))
$(eval $(call BuildPackage,pyRelayExp))
$(eval $(call BuildPackage,pyOledExp))
$(eval $(call BuildPackage,python3-omega-expansion))
$(eval $(call BuildPackage,python3-onion-i2c))
$(eval $(call BuildPackage,python3-pwm-exp))
$(eval $(call BuildPackage,python3-relay-exp))
$(eval $(call BuildPackage,python3-oled-exp))

