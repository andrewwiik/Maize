include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FlashlightModule
FlashlightModule_BUNDLE_NAME = com.ioscreatix.maize.FlashlightModule
FlashlightModule_BUNDLE_EXTENSION = bundle
FlashlightModule_CFLAGS =  -fobjc-arc
FlashlightModule_FILES = $(wildcard *.m)
FlashlightModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
FlashlightModule_EXTRA_FRAMEWORKS = MaizeUI
FlashlightModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
FlashlightModule_INSTALL_PATH = /Library/Maize/Bundles/
FlashlightModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
