# Copyright (C) 2017 IBM Corporation
# 
# Author: John Walicki <walicki@us.ibm.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
##OPENWRT PACKAGE MAKEFILE FOR node-red-contrib-ibm-watson-iot Node

include $(TOPDIR)/rules.mk
PKG_NAME:=node-red-contrib-ibm-watson-iot
PKG_VERSION:=0.2.8
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/ibm-watson-iot/node-red-contrib-ibm-watson-iot.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/node-red-contrib-ibm-watson-iot
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Node-RED
	TITLE:=node-red-contrib-ibm-watson-iot Package
	DEPENDS:= +libc +libpthread +libstdcpp
endef


define Package/node-red-contrib-ibm-watson-iot/description
node-red-contrib-ibm-watson-iot package built for MIPS
endef


TARGET_CFLAGS += $(FPIC)

define Build/Compile
	$(CP) ./files/makefile $(PKG_BUILD_DIR)/makefile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)"
endef

##Whats this do?
#define Build/InstallDev
#
#endef

define Package/node-red-contrib-ibm-watson-iot/install
	$(INSTALL_DIR) ./tmp;
	$(CP) -r $(PKG_BUILD_DIR)/ ./tmp/; 
	$(INSTALL_DIR) $(1)/usr/bin;
	$(CP) -r ./tmp/$(PKG_NAME) $(1)/usr/bin;
	rm -rf ./tmp;
endef

$(eval $(call BuildPackage,node-red-contrib-ibm-watson-iot))
