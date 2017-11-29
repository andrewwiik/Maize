include $(THEOS)/makefiles/common.mk


Maize_CFLAGS = -fobjc-arc -I../headers -I../

BUNDLE_NAME = Maize
Maize_FILES = $(wildcard *.mm) $(wildcard *.m)
Maize_FRAMEWORKS = UIKit
#Maize_PRIVATE_FRAMEWORKS += SpringBoardServices Preferences
Maize_EXTRA_FRAMEWORKS += MaizeServices
Maize_INSTALL_PATH = /Library/PreferenceBundles
Maize_LDFLAGS += ./SpringBoardServices.tbd ./Preferences.tbd
Maize_LDFLAGS += -F../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Maize.plist$(ECHO_END)
