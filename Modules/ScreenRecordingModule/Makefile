include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ScreenRecordingModule
ScreenRecordingModule_BUNDLE_NAME = com.ioscreatix.maize.ScreenRecordingModule
ScreenRecordingModule_BUNDLE_EXTENSION = bundle
ScreenRecordingModule_CFLAGS =  -fobjc-arc
ScreenRecordingModule_FILES = $(wildcard *.m)
ScreenRecordingModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
ScreenRecordingModule_EXTRA_FRAMEWORKS = MaizeUI
ScreenRecordingModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
ScreenRecordingModule_INSTALL_PATH = /Library/Maize/Bundles/
ScreenRecordingModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
