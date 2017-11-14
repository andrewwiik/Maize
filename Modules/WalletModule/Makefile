include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = WalletModule
WalletModule_BUNDLE_NAME = com.ioscreatix.maize.WalletModule
WalletModule_BUNDLE_EXTENSION = bundle
WalletModule_CFLAGS =  -fobjc-arc
WalletModule_FILES = $(wildcard *.m)
WalletModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
WalletModule_EXTRA_FRAMEWORKS = MaizeUI
WalletModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
WalletModule_INSTALL_PATH = /Library/Maize/Bundles/
WalletModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
