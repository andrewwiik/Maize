include $(THEOS)/makefiles/common.mk


Settings_CFLAGS = -fobjc-arc -I../headers -I../

BUNDLE_NAME = Settings
Settings_FILES = $(wildcard *.mm) $(wildcard *.m)
Settings_FRAMEWORKS = UIKit
Settings_PRIVATE_FRAMEWORKS += SpringBoardServices Preferences
Settings_EXTRA_FRAMEWORKS += MaizeServices
Settings_INSTALL_PATH = /Library/PreferenceBundles
Settings_LDFLAGS += ./SpringBoardServices.tbd ./Preferences.tbd
Settings_LDFLAGS += -F../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Settings.plist$(ECHO_END)
