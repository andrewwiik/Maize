ifeq ($(SIMULATOR),1)
	export TARGET = simulator:clang:latest:7.0
	export ARCHS = x86_64
else
	export TARGET = iphone:latest:7.0
	export ARCHS = armv7 arm64
endif

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

# the main bits
SUBPROJECTS = MaizeServices MaizeShortcutKit MaizeUI SpringBoard Modules Providers Settings

# SUBPROJECTS += settings
include $(THEOS_MAKE_PATH)/aggregate.mk
