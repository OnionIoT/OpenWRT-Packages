include $(TOPDIR)/rules.mk

PKG_NAME:=iojs
PKG_VERSION:=v2.3.0
PKG_RELEASE:=1

PKG_SOURCE:=iojs-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://iojs.org/dist/${PKG_VERSION}/
PKG_SHA256SUM:=556e1a2f58c993fcb7a89c55bc2a4da6fba74cd4d444777a8b64b19d57c4cc3c

PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/iojs
  DEPENDS:=+libpthread +librt +libstdcpp +libopenssl +zlib
  SUBMENU:=Node.js
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=io.js is an npm compatible platform originally based on node.js
  URL:=https://iojs.org/
endef

define Package/iojs/description
io.js is an npm compatible platform originally based on node.js
endef

define Package/npm
  DEPENDS:=+iojs
  SUBMENU:=Node.js
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Node/io.js Package Manager
  URL:=https://npmjs.org/
endef

ifeq ($(ARCH),i386)
  DEST_CPU=ia32
else
  DEST_CPU=$(ARCH)
endif


CONFIGURE_ARGS = --dest-cpu=$(DEST_CPU) --dest-os=linux \
  --shared-openssl --shared-openssl-includes="$(STAGING_DIR)/usr/include" --shared-openssl-libpath="$(STAGING_DIR)/usr/lib" \
  --shared-zlib --shared-zlib-includes="$(STAGING_DIR)/usr/include" --shared-zlib-libpath="$(STAGING_DIR)/usr/lib" \
  --v8-options="--max_old_space_size=20 --initial_old_space_size=4 --max_semi_space_size=2 --max_executable_size=5" \
  --without-snapshot

ifeq ($(ARCH),mipsel)
  CONFIGURE_ARGS += \
   --with-mips-arch-variant=r2 --with-mips-fpu-mode=fp32 --with-mips-float-abi=soft
endif

define Package/iojs/install
	mkdir -p $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/out/Release/iojs $(1)/usr/bin/iojs
	ln -sf /usr/bin/iojs $(1)/usr/bin/node
endef

define Package/npm/install
	mkdir -p $(1)/usr/lib/node_modules
	$(CP) $(PKG_BUILD_DIR)/deps/npm $(1)/usr/lib/node_modules
	ln -sf /usr/lib/node_modules/npm/bin/npm-cli.js $(1)/usr/bin/npm
endef

$(eval $(call BuildPackage,iojs))
$(eval $(call BuildPackage,npm))
