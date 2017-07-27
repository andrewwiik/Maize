include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VPNModule
VPNModule_BUNDLE_NAME = com.ioscreatix.maize.VPNModule
VPNModule_BUNDLE_EXTENSION = bundle
VPNModule_CFLAGS =  -fobjc-arc
VPNModule_FILES = $(wildcard *.m)
VPNModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
VPNModule_EXTRA_FRAMEWORKS = MaizeUI
VPNModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
VPNModule_INSTALL_PATH = /Library/Maize/Bundles/
VPNModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
