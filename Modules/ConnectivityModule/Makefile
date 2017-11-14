include $(THEOS)/makefiles/common.mk
BUNDLE_NAME = ConnectivityModule
ConnectivityModule_BUNDLE_NAME = com.ioscreatix.maize.ConnectivityModule
ConnectivityModule_BUNDLE_EXTENSION = bundle
ConnectivityModule_CFLAGS =  -fobjc-arc
ConnectivityModule_FILES =  $(wildcard *.xm) $(wildcard *.m)
ConnectivityModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore CoreTelephony
ConnectivityModule_EXTRA_FRAMEWORKS = MaizeUI
ConnectivityModule_LIBRARIES = MobileGestalt flipswitch
ConnectivityModule_LDFLAGS += ./MobileWiFi.tbd $(THEOS)/vendor/lib/libsubstrate.tbd
ConnectivityModule_INSTALL_PATH = /Library/Maize/Bundles/
ConnectivityModule_LDFLAGS += -F../../.theos/$(THEOS_OBJ_DIR_NAME)
# ConnectivityModule_LDFLAGS += -Wl,./AirPortSettings
# ConnectivityModule_LDFLAGS += -Wl,-U,_OBJC_METACLASS_$_APNetworksController
# ConnectivityModule_LDFLAGS = -undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/bundle.mk
