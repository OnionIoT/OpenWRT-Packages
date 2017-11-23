include $(TOPDIR)/rules.mk

PKG_NAME:=nodejs
PKG_VERSION:=v8.9.1
PKG_RELEASE:=1

PKG_SOURCE:=node-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://nodejs.org/dist/${PKG_VERSION}/

PKG_BUILD_DIR:=$(BUILD_DIR)/node-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/nodejs
  DEPENDS:=+libpthread +librt +libstdcpp +libopenssl +zlib
  SUBMENU:=Node.js
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Node.js $(PKG_VERSION)
  URL:=https://nodejs.org/
endef

define Package/nodejs/description
Event-driven I/O server-side JavaScript environment based on V8
endef

define Package/npm
  DEPENDS:=+nodejs
  SUBMENU:=Node.js
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Node.js Package Manager
  URL:=https://npmjs.org/
endef

DEST_CPU=$(ARCH)



CONFIGURE_ARGS = --dest-cpu=$(DEST_CPU) --dest-os=linux \
  --shared-openssl --shared-openssl-includes="$(STAGING_DIR)/usr/include" --shared-openssl-libpath="$(STAGING_DIR)/usr/lib" \
  --shared-zlib --shared-zlib-includes="$(STAGING_DIR)/usr/include" --shared-zlib-libpath="$(STAGING_DIR)/usr/lib" \
  --v8-options="--max_old_space_size=30 --initial_old_space_size=4 --max_executable_size=20" --without-snapshot


CONFIGURE_ARGS += \
--with-mips-arch-variant=r2 --with-mips-fpu-mode=fp32 --with-mips-float-abi=soft


define Package/nodejs/install
	mkdir -p $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/out/Release/node $(1)/usr/bin/node
endef

define Package/npm/install
	mkdir -p $(1)/usr/lib/node_modules
	$(CP) $(PKG_BUILD_DIR)/deps/npm $(1)/usr/lib/node_modules
	mkdir -p $(1)/usr/bin
	ln -sf /usr/lib/node_modules/npm/bin/npm-cli.js $(1)/usr/bin/npm
endef

$(eval $(call BuildPackage,nodejs))
$(eval $(call BuildPackage,npm))
