include $(THEOS)/makefiles/common.mk
BUNDLE_NAME = ConnectivityModule
ConnectivityModule_BUNDLE_NAME = com.ioscreatix.maize.ConnectivityModule
ConnectivityModule_BUNDLE_EXTENSION = bundle
ConnectivityModule_CFLAGS =  -fobjc-arc
ConnectivityModule_FILES = $(wildcard *.m)
ConnectivityModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore CoreTelephony
ConnectivityModule_EXTRA_FRAMEWORKS = MaizeUI
ConnectivityModule_LIBRARIES = MobileGestalt
ConnectivityModule_LDFLAGS += ./MobileWiFi.tbd
ConnectivityModule_INSTALL_PATH = /Library/Maize/Bundles/
ConnectivityModule_LDFLAGS += -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
