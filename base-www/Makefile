#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=base-www
PKG_VERSION:=0.2
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/base-www.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Files for website hosting on the Omega to ensure compatibility between Onion utilities
endef


define Package/$(PKG_NAME)/description
Files for website hosting on the Omega to ensure compatibility between Onion utilities
endef

define Package/$(PKG_NAME)/install
	# copy the web site files
	$(INSTALL_DIR) $(1)/www
	$(CP) -r $(PKG_BUILD_DIR)/www/* $(1)/www/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

