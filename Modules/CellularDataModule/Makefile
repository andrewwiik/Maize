include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CellularDataModule
CellularDataModule_BUNDLE_NAME = com.ioscreatix.maize.CellularDataModule
CellularDataModule_BUNDLE_EXTENSION = bundle
CellularDataModule_CFLAGS =  -fobjc-arc
CellularDataModule_FILES = $(wildcard *.m)
CellularDataModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
CellularDataModule_EXTRA_FRAMEWORKS = MaizeUI
CellularDataModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
CellularDataModule_INSTALL_PATH = /Library/Maize/Bundles/
CellularDataModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
