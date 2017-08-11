include $(THEOS)/makefiles/common.mk
# export TARGET iphone:10.1:10.1
BUNDLE_NAME = AudioModule
AudioModule_BUNDLE_NAME = com.ioscreatix.maize.AudioModule
AudioModule_BUNDLE_EXTENSION = bundle
AudioModule_CFLAGS =  -fobjc-arc
AudioModule_FILES = $(wildcard *.m)
AudioModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore MediaPlayer
AudioModule_PRIVATE_FRAMEWORKS = 
AudioModule_EXTRA_FRAMEWORKS = MaizeUI
AudioModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
AudioModule_INSTALL_PATH = /Library/Maize/Bundles/
AudioModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
