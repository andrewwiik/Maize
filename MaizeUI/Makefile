include $(THEOS)/makefiles/common.mk

ifeq ($(SIMULATOR),1)
	export TARGET = simulator:clang:latest:7.0
	export ARCHS = x86_64
else
	export TARGET = iphone:latest:7.0
	export ARCHS = armv7 arm64
endif

MaizeUI_CFLAGS = -fobjc-arc -I../headers

FRAMEWORK_NAME = MaizeUI
# MaizeUI_PUBLIC_HEADERS = $(wildcard *.h)
MaizeUI_FILES = $(wildcard *.m)
MaizeUI_INSTALL_PATH = /Library/Frameworks

include $(THEOS_MAKE_PATH)/framework.mk
