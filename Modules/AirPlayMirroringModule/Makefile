include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AirPlayMirroringModule
AirPlayMirroringModule_BUNDLE_NAME = com.ioscreatix.maize.AirPlayMirroringModule
AirPlayMirroringModule_BUNDLE_EXTENSION = bundle
AirPlayMirroringModule_CFLAGS =  -fobjc-arc
AirPlayMirroringModule_FILES = $(wildcard *.m)
AirPlayMirroringModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore MediaPlayer
AirPlayMirroringModule_EXTRA_FRAMEWORKS = MaizeUI
AirPlayMirroringModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
AirPlayMirroringModule_INSTALL_PATH = /Library/Maize/Bundles/
AirPlayMirroringModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
