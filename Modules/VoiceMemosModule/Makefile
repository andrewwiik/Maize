include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VoiceMemosModule
VoiceMemosModule_BUNDLE_NAME = com.ioscreatix.maize.VoiceMemosModule
VoiceMemosModule_BUNDLE_EXTENSION = bundle
VoiceMemosModule_CFLAGS =  -fobjc-arc
VoiceMemosModule_FILES = $(wildcard *.m)
VoiceMemosModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
VoiceMemosModule_EXTRA_FRAMEWORKS = MaizeUI
VoiceMemosModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
VoiceMemosModule_INSTALL_PATH = /Library/Maize/Bundles/
VoiceMemosModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
