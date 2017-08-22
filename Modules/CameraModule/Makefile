include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CameraModule
CameraModule_BUNDLE_NAME = com.ioscreatix.maize.CameraModule
CameraModule_BUNDLE_EXTENSION = bundle
CameraModule_CFLAGS =  -fobjc-arc
CameraModule_FILES = $(wildcard *.m)
CameraModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
CameraModule_EXTRA_FRAMEWORKS = MaizeUI
CameraModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
CameraModule_INSTALL_PATH = /Library/Maize/Bundles/
CameraModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
