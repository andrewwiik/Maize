include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ClockModule
ClockModule_BUNDLE_NAME = com.ioscreatix.maize.ClockModule
ClockModule_BUNDLE_EXTENSION = bundle
ClockModule_CFLAGS =  -fobjc-arc
ClockModule_FILES = $(wildcard *.m)
ClockModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
ClockModule_EXTRA_FRAMEWORKS = MaizeUI
ClockModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
ClockModule_INSTALL_PATH = /Library/Maize/Bundles/
ClockModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
