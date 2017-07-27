include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = RingerModule
RingerModule_BUNDLE_NAME = com.ioscreatix.maize.RingerModule
RingerModule_BUNDLE_EXTENSION = bundle
RingerModule_CFLAGS =  -fobjc-arc
RingerModule_FILES = $(wildcard *.m)
RingerModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
RingerModule_EXTRA_FRAMEWORKS = MaizeUI
RingerModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
RingerModule_INSTALL_PATH = /Library/Maize/Bundles/
RingerModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
