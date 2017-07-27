include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LowPowerModule
LowPowerModule_BUNDLE_NAME = com.ioscreatix.maize.LowPowerModule
LowPowerModule_BUNDLE_EXTENSION = bundle
LowPowerModule_CFLAGS =  -fobjc-arc
LowPowerModule_FILES = $(wildcard *.m)
LowPowerModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
LowPowerModule_EXTRA_FRAMEWORKS = MaizeUI
LowPowerModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
LowPowerModule_INSTALL_PATH = /Library/Maize/Bundles/
LowPowerModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
