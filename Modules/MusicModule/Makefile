include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MusicModule
MusicModule_BUNDLE_NAME = com.ioscreatix.maize.MusicModule
MusicModule_BUNDLE_EXTENSION = bundle
MusicModule_CFLAGS =  -fobjc-arc
MusicModule_FILES = $(wildcard *.m)
MusicModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
MusicModule_EXTRA_FRAMEWORKS = MaizeUI
MusicModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
MusicModule_INSTALL_PATH = /Library/Maize/Bundles/
MusicModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
