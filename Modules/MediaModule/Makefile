include $(THEOS)/makefiles/common.mk

# export TARGET = iphone:10.1:10.1

BUNDLE_NAME = MediaModule
MediaModule_BUNDLE_NAME = com.ioscreatix.maize.MediaModule
MediaModule_BUNDLE_EXTENSION = bundle
MediaModule_CFLAGS =  -fobjc-arc
MediaModule_FILES = $(wildcard *.xm) $(wildcard *.m)
MediaModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
MediaModule_EXTRA_FRAMEWORKS = MaizeUI
MediaModule_LDFLAGS += $(THEOS)/vendor/lib/libsubstrate.tbd ./AppSupport.tbd ./MediaRemote.tbd ./MPUFoundation.tbd
MediaModule_INSTALL_PATH = /Library/Maize/Bundles/
MediaModule_LDFLAGS += -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
