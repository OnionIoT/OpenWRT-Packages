#
# Copyright (C) 2018 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-editor
PKG_VERSION:=0.0.1
PKG_RELEASE:=2


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/Codiad/Codiad.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/oos-app-editor
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=OnionOS Editor App
	DEPENDS:=+php7 +php7-mod-session +php7-fastcgi +php7-mod-json +php7-mod-curl +php7-mod-xml +php7-mod-simplexml +php7-mod-mbstring +php7-mod-openssl +php7-mod-zip
endef


define Package/oos-app-editor/description
OnionOS Editor App
endef

define Build/Compile
        $(CP) ./files/Makefile $(PKG_BUILD_DIR)/makefile
endef

define Package/oos-app-editor/install
	# copy the web site files
	$(INSTALL_DIR) $(1)/www/apps/editor
	$(CP) -r $(PKG_BUILD_DIR)/components/ $(1)/www/apps/editor/components/
	$(CP) -r $(PKG_BUILD_DIR)/data/ $(1)/www/apps/editor/data/
	$(CP) -r $(PKG_BUILD_DIR)/js/ $(1)/www/apps/editor/js/
	$(CP) -r $(PKG_BUILD_DIR)/languages/ $(1)/www/apps/editor/languages/
	$(CP) -r $(PKG_BUILD_DIR)/lib/ $(1)/www/apps/editor/lib/
	$(CP) -r $(PKG_BUILD_DIR)/plugins/ $(1)/www/apps/editor/plugins/
	$(CP) -r $(PKG_BUILD_DIR)/themes/ $(1)/www/apps/editor/themes/
	$(CP) -r $(PKG_BUILD_DIR)/workspace/ $(1)/www/apps/editor/workspace/
	$(CP) $(PKG_BUILD_DIR)/*.php $(1)/www/apps/editor/
	$(CP) $(PKG_BUILD_DIR)/*.json $(1)/www/apps/editor/
	$(CP) $(PKG_BUILD_DIR)/*.xml $(1)/www/apps/editor/
endef

define Package/oos-app-editor/postinst
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	uci add_list uhttpd.main.interpreter='.php=/usr/bin/php-fcgi'
	uci set uhttpd.main.index_page='index.php'
	uci commit uhttpd
	/etc/init.d/uhttpd restart
fi
exit 0
endef

# calls to build each package
$(eval $(call BuildPackage,oos-app-editor))
