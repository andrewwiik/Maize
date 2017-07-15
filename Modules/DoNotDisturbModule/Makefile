include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DoNotDisturbModule
DoNotDisturbModule_BUNDLE_NAME = com.ioscreatix.maize.DoNotDisturbModule
DoNotDisturbModule_BUNDLE_EXTENSION = bundle
DoNotDisturbModule_CFLAGS =  -fobjc-arc
DoNotDisturbModule_FILES = $(wildcard *.m)
DoNotDisturbModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
DoNotDisturbModule_EXTRA_FRAMEWORKS = MaizeUI
DoNotDisturbModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
DoNotDisturbModule_INSTALL_PATH = /Library/Maize/Bundles/
DoNotDisturbModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
