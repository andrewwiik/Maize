include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = QuickNoteModule
QuickNoteModule_BUNDLE_NAME = com.ioscreatix.maize.QuickNoteModule
QuickNoteModule_BUNDLE_EXTENSION = bundle
QuickNoteModule_CFLAGS =  -fobjc-arc
QuickNoteModule_FILES = $(wildcard *.m)
QuickNoteModule_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
QuickNoteModule_EXTRA_FRAMEWORKS = MaizeUI
QuickNoteModule_LDFLAGS = $(THEOS)/vendor/lib/libsubstrate.tbd
QuickNoteModule_INSTALL_PATH = /Library/Maize/Bundles/
QuickNoteModule_LDFLAGS = -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
