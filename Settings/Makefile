include $(THEOS)/makefiles/common.mk


MaizeSettings_CFLAGS = -fobjc-arc -I../headers -I../

BUNDLE_NAME = MaizeSettings
MaizeSettings_FILES = $(wildcard *.mm) $(wildcard *.m)
MaizeSettings_FRAMEWORKS = UIKit
#MaizeSettings_PRIVATE_FRAMEWORKS += SpringBoardServices Preferences
MaizeSettings_EXTRA_FRAMEWORKS += MaizeServices
MaizeSettings_INSTALL_PATH = /Library/PreferenceBundles
MaizeSettings_LDFLAGS += ./SpringBoardServices.tbd ./Preferences.tbd
MaizeSettings_LDFLAGS += -F../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MaizeSettings.plist$(ECHO_END)
