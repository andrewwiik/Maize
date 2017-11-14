include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MagnifierModule
MagnifierModule_BUNDLE_NAME = com.ioscreatix.maize.MagnifierModule
MagnifierModule_BUNDLE_EXTENSION = bundle
MagnifierModule_CFLAGS =  -fobjc-arc
MagnifierModule_FILES = $(wildcard *.m)
MagnifierModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
MagnifierModule_EXTRA_FRAMEWORKS = MaizeUI
MagnifierModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
MagnifierModule_INSTALL_PATH = /Library/Maize/Bundles/
MagnifierModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
