include $(TOPDIR)/rules.mk

# Name, version and release number
# The name and version of your package are used to define the variable to point to the build directory of your package: $(PKG_BUILD_DIR)
PKG_NAME:=liburtc
PKG_VERSION:=1.0
PKG_MAINTAINER:=Vladimir Inshakov <markoni48@yandex.ru>
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://bitbucket.org/hlorka/liburtc.git
PKG_SOURCE_DATE:=2020-03-25
PKG_SOURCE_VERSION:=a3d73a8503f122a16fd2ec3b7bfd4e574c281c9e
PKG_MIRROR_HASH:=c9f1347bb69df557394d17329c5a5ce706f76d17574686ef9fc6f87e1e3a7bbd

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

# Package definition; instructs on how and where our package will appear in the overall configuration menu ('make menuconfig')
define Package/liburtc
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Library user-space to access RTC device
  URL:=https://bitbucket.org/hlorka/liburtc/
  DEPENDS:=+libc
endef

# Package description; a more verbose description on what our package does
define Package/liburtc/description
  The user-space library for Real Time Clock (RTC) devices.
  It's the simplest way to get communication with RTC from your own
  user applications. Also you can use additional device registers
  if they are. This library is usefull for computers withoun hardware clock.
endef

# Urtcdate утилита
define Package/urtcdate
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Utility to operate RTC
  URL:=https://bitbucket.org/hlorka/liburtc/
  DEPENDS:=+liburtc
endef

define Package/urtcdate/description
  This is usebale utility to manual read, set or sync clock into RTC chip and
  software clock. These utility can be use integrate to the OpenWRT OS and
  sync with NTP and set software clock if OS doesn't have hwclock drivers.
endef

# Установка dev-расширения библиотеки
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/{urtc,pcf8563}.h $(1)/usr/include/
endef

CONFIGURE_ARGS += --enable-shared

# Файлы конфигурации
define Package/liburtc/conffiles
/usr/share/liburtc.conf
endef

# Установка основных файлов библиотека
define Package/liburtc/install
	$(INSTALL_DIR) $(1)/usr/share
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/liburtc/liburtc.conf $(1)/usr/share
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/liburtc/.libs/liburtc.so* $(1)/usr/lib/
endef

# Установка утилиты urtcdate
define Package/urtcdate/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/urtcdate/.libs/urtcdate $(1)/usr/sbin
endef

# Скрипт действий после установки пакета
define Package/urtcdate/postinst
#!/bin/sh

[ -n "$$IPKG_INSTROOT" ] || {
sed -ie '/urtcdate/d;$$a\urtcdate\ --update' /usr/sbin/ntpd-hotplug
sed -ie '/urtcdate/d;$$i\urtcdate\ -s' /etc/rc.local
}
endef

# Скрипт действий после деинсталляции пакета
define Package/urtcdate/prerm
#!/bin/sh

[ -n "$$IPKG_INSTROOT" ] || {
sed -i '/urtcdate/d' /usr/sbin/ntpd-hotplug
sed -i '/urtcdate/d' /etc/rc.local
}
endef

# This command is always the last, it uses the definitions and variables we give above in order to get the job done
$(eval $(call BuildPackage,liburtc))
$(eval $(call BuildPackage,urtcdate))
