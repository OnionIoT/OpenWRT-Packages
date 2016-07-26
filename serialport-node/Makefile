# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
##OPENWRT PACKAGE MAKEFILE FOR  onoff Node

include $(TOPDIR)/rules.mk
PKG_NAME:=serialport-node
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/EmergingTechnologyAdvisors/node-serialport.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/serialport-node
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Serialport Package
	DEPENDS:= +libpthread +libstdcpp
endef


define Package/serialport-node/description
serialPort package built for mips. 
endef


TARGET_CFLAGS += $(FPIC)


define Build/Compile
	export CC=/home/rajiv/OpenWRT-Buildroot/openwrt/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-gcc;
	export CXX=/home/rajiv/OpenWRT-Buildroot/openwrt/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-g++;
	export STAGING_DIR=/home/rajiv/OpenWRT-Buildroot/openwrt/staging_dir/;
	cd $(PKG_BUILD_DIR);pwd;npm install --target_arch=mips;

endef

##Whats this do?
#define Build/InstallDev
#
#endef


define Package/serialport-node/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/Release/serialport.node $(1)/usr/bin/
endef

$(eval $(call BuildPackage,serialport-node))

