include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = OrientationLockModule
OrientationLockModule_BUNDLE_NAME = com.ioscreatix.maize.OrientationLockModule
OrientationLockModule_BUNDLE_EXTENSION = bundle
OrientationLockModule_CFLAGS =  -fobjc-arc
OrientationLockModule_FILES = $(wildcard *.m)
OrientationLockModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
OrientationLockModule_EXTRA_FRAMEWORKS = MaizeUI
OrientationLockModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
OrientationLockModule_INSTALL_PATH = /Library/Maize/Bundles/
OrientationLockModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
