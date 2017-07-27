include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LocationModule
LocationModule_BUNDLE_NAME = com.ioscreatix.maize.LocationModule
LocationModule_BUNDLE_EXTENSION = bundle
LocationModule_CFLAGS =  -fobjc-arc
LocationModule_FILES = $(wildcard *.m)
LocationModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
LocationModule_EXTRA_FRAMEWORKS = MaizeUI
LocationModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
LocationModule_INSTALL_PATH = /Library/Maize/Bundles/
LocationModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
