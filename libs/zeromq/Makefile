# 
# Copyright (C) 2015 Onion Corporation
#
# Author: Boken Lin <bl@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=zeromq
PKG_VERSION:=4.1.2
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/zeromq/zeromq4-1/archive
PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)4-1-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

PKG_FIXUP:=libtool autoreconf
PKG_USE_MIPS16:=0
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/zeromq
    MAINTAINER:=victor@iso3103.net
    TITLE:=zeromq
    SECTION:=libs
    DEPENDS:=+libstdcpp +libpthread +librt +libsodium
    CATEGORY:=Libraries
    URL:=http://www.zeromq.org/
endef

define Package/zeromq/description
    The library provides light weight messaging services using an intelligent transport layer. 
    It can carry messages across inproc, IPC, TCP and multicast and is faster than TCP for 
    clustered products and supercomputing.
endef

define Build/Configure
	cd $(PKG_BUILD_DIR) && ./autogen.sh && ./configure
endef

define Build/InstallDev
	$(INSTALL_DIR) \
		$(1)/usr/lib 	\
		$(1)/usr/include \
		$(1)/usr/lib/pkgconfig
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/* \
		$(1)/usr/lib/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/include/* \
		$(1)/usr/include/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig \
		$(1)/usr/lib/
endef

define Package/zeromq/install
	$(INSTALL_DIR) $(1)/usr/lib 
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,zeromq))
