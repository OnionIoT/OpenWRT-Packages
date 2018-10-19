#
# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-os
PKG_VERSION:=1.0.5
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/OnionIoT/Onion-Console.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# base console package
define Package/onion-os
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=OnionOS for headless IoT devices
	DEPENDS:=+shellinabox
endef


define Package/onion-os/description
OnionOS for headless IoT devices
endef

define Package/onion-os/install
	# install the acl permissions file and rpcd script
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) ./files/onion-os.json $(1)/usr/share/rpcd/acl.d/onion-os.json
	$(INSTALL_BIN) ./files/onion-os.sh $(1)/usr/libexec/rpcd/onion-os
	# copy the web site files
	$(INSTALL_DIR) $(1)/www/ $(1)/www/OnionOS $(1)/www/cgi-bin
	$(CP) ./files/www/index.html $(1)/www/
	$(CP) -r ./files/www/OnionOS/* $(1)/www/OnionOS/
	$(INSTALL_BIN) ./files/www/cgi-bin/setup.sh $(1)/www/cgi-bin/setup
endef

define Package/onion-os/postinst
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	echo "# mqtt over websocket configuration
bind_address 0.0.0.0
port 1883
protocol mqtt
log_type information
log_type websockets
websockets_log_level 0
listener 9001 0.0.0.0
protocol websockets
" > /etc/mosquitto/mosquitto.conf

	/etc/init.d/mosquitto restart
fi
exit 0
endef

# calls to build each package
$(eval $(call BuildPackage,onion-os))
