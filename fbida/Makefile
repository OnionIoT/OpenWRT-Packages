# 
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# 
# based on fbida from https://github.com/mozzwald/openwrt-zipit-packages
# 

include $(TOPDIR)/rules.mk

PKG_NAME:=fbida
PKG_VERSION:=2.09

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://dl.bytesex.org/releases/fbida/
PKG_MD5SUM:=62415c7cb28d995f9d317868de0f2830

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/fbida
    SUBMENU:=fbida
    SECTION:=utils
    CATEGORY:=Utilities
    URL:=http://linux.bytesex.org/fbida/
    #DEPENDS:=+libpng +libtiff +libexif $(ICONV_DEPENDS) +dejavu-fonts-ttf +libcurl +libfreetype +fontconfig
    DEPENDS:=+libpng +libtiff +libexif $(ICONV_DEPENDS) +dejavu-fonts-ttf-DejaVuSans +libcurl +libfreetype +fontconfig
endef

define Package/fbida/description
    The fbida project contains a few applications for viewing and editing images
endef

define Package/fbi
	$(call Package/fbida)
	TITLE:=This is a image viewer for the linux framebuffer console.
endef

# example: fbi -d /dev/fb0 -notty -nocomments --noverbose <FILE>

# define Package/fbgs
#     $(call Package/fbida)
#     TITLE:=A wrapper script for viewing ps/pdf files on the framebuffer console using fbi.
#     DEPENDS:=+fbi +ghostscript
# endef

define Build/Compile
	$(call Build/Compile/Default,verbose=yes)
endef

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include/freetype2
TARGET_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib/libiconv-full/lib/ -L$(STAGING_DIR)/usr/lib/libiconv-full/lib/ -liconv

define Package/fbi/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/{fbi,exiftran} $(1)/usr/bin/
endef

# define Package/fbgs/install
# 	$(INSTALL_DIR) $(1)/usr/bin
# 	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fbgs $(1)/usr/bin/
# endef

$(eval $(call BuildPackage,fbi))
# $(eval $(call BuildPackage,fbgs))
