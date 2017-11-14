include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FlipSwitchProvider
FlipSwitchProvider_BUNDLE_NAME = com.ioscreatix.maize.FlipSwitchProvider
FlipSwitchProvider_BUNDLE_EXTENSION = bundle
FlipSwitchProvider_CFLAGS =  -fobjc-arc
FlipSwitchProvider_FILES = $(wildcard *.m)
FlipSwitchProvider_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
FlipSwitchProvider_EXTRA_FRAMEWORKS = MaizeUI
FlipSwitchProvider_LIBRARIES = flipswitch
FlipSwitchProvider_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
FlipSwitchProvider_INSTALL_PATH = /Library/Maize/Providers/
FlipSwitchProvider_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)


include $(THEOS_MAKE_PATH)/bundle.mk
