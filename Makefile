include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-wificity
PKG_RELEASE:=0.0.1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PO2LMO:=$(shell find $(TOPDIR)/build_dir/target-*/luci* -name po2lmo | awk '{if(match($$0,/build\/po2lmo/)) print $$0}')

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-wificity
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=jmtoo License Key 
  DEPENDS:=+luci
endef

define Package/luci-app-wificity/description
  License Key Save Application.
  Developer by bywayboy<bywayboy@qq.com>
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/luasrc
endef

define Package/luci-app-wificity/postinst
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
	rm -f /tmp/luci-indexcache
	exit 0
}
endef

define Package/luci-app-wificity/install
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/etc/config/* $(1)/etc/config
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(CP) $(PKG_BUILD_DIR)/luasrc/controller/* $(1)/usr/lib/lua/luci/controller
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/admin_services
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/cbi
	$(CP) $(PKG_BUILD_DIR)/luasrc/view/admin_services/* $(1)/usr/lib/lua/luci/view/admin_services
	$(CP) $(PKG_BUILD_DIR)/luasrc/view/cbi/* $(1)/usr/lib/lua/luci/view/cbi
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/admin_services
	$(CP) $(PKG_BUILD_DIR)/luasrc/model/cbi/admin_services/* $(1)/usr/lib/lua/luci/model/cbi/admin_services
	
#	$(INSTALL_DIR) $(1)/www/cgi-bin
#	$(INSTALL_BIN) $(PKG_BUILD_DIR)/luasrc/www/cgi-bin/* $(1)/www/cgi-bin
	
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/luasrc/usr/sbin/* $(1)/usr/sbin
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(PO2LMO) ./lang/wificity.zh-cn.po $(1)/usr/lib/lua/luci/i18n/wificity.zh-cn.lmo
	
#	$(INSTALL_DIR) $(1)/www/luci-static/resources
#	$(CP) ./luci-static/resources/* $(1)/www/luci-static/resources
endef

#[安装后执行的脚本 记得加上#!/bin/sh 没有就空着]
define Package/luci-app-wificity/postinst
#!/bin/sh

mkdir -p $${PKG_ROOT}/etc/crontabs
if [ -f $${PKG_ROOT}/etc/crontabs/root ]; then
	grep -q apsync $${PKG_ROOT}/etc/crontabs/root || {
		echo "*/2 * * * * /usr/sbin/apsync >/dev/null&" >> $${PKG_ROOT}/etc/crontabs/root
		echo "*/10 * * * * /usr/sbin/infreport >/dev/null&" >> $${PKG_ROOT}/etc/crontabs/root
	}
else
	echo "*/2 * * * * /usr/sbin/apsync >/dev/null&" >> $${PKG_ROOT}/etc/crontabs/root
	echo "*/10 * * * * /usr/sbin/infreport >/dev/null&" >> $${PKG_ROOT}/etc/crontabs/root
fi

endef

$(eval $(call BuildPackage,luci-app-wificity))
