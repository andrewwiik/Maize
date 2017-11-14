include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PolusProvider
PolusProvider_BUNDLE_NAME = com.ioscreatix.maize.PolusProvider
PolusProvider_BUNDLE_EXTENSION = bundle
PolusProvider_CFLAGS =  -fobjc-arc
PolusProvider_FILES = $(wildcard *.m)
PolusProvider_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
PolusProvider_EXTRA_FRAMEWORKS = MaizeUI
PolusProvider_LIBRARIES = flipswitch
PolusProvider_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
PolusProvider_INSTALL_PATH = /Library/Maize/Providers/
PolusProvider_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)
PolusProvider_LDFLAGS += ./SpringBoardServices.tbd


include $(THEOS_MAKE_PATH)/bundle.mk
