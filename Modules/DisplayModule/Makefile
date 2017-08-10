include $(THEOS)/makefiles/common.mk

export TARGET = iphone:10.1:10.1

BUNDLE_NAME = DisplayModule
DisplayModule_BUNDLE_NAME = com.ioscreatix.maize.DisplayModule
DisplayModule_BUNDLE_EXTENSION = bundle
DisplayModule_CFLAGS =  -fobjc-arc
DisplayModule_FILES = $(wildcard *.m)
DisplayModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore MediaPlayer
DisplayModule_PRIVATE_FRAMEWORKS = MediaPlayerUI BackBoardServices
DisplayModule_EXTRA_FRAMEWORKS = MaizeUI
DisplayModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
DisplayModule_INSTALL_PATH = /Library/Maize/Bundles/
DisplayModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
