include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CalculatorModule
CalculatorModule_BUNDLE_NAME = com.ioscreatix.maize.CalculatorModule
CalculatorModule_BUNDLE_EXTENSION = bundle
CalculatorModule_CFLAGS =  -fobjc-arc
CalculatorModule_FILES = $(wildcard *.m)
CalculatorModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
CalculatorModule_EXTRA_FRAMEWORKS = MaizeUI
CalculatorModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
CalculatorModule_INSTALL_PATH = /Library/Maize/Bundles/
CalculatorModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
