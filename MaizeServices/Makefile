include $(THEOS)/makefiles/common.mk

ifeq ($(SIMULATOR),1)
	export TARGET = simulator:clang:latest:7.0
	export ARCHS = x86_64
else
	export TARGET = iphone:latest:7.0
	export ARCHS = armv7 arm64
endif

MaizeServices_CFLAGS = -fobjc-arc -I../headers -I../

FRAMEWORK_NAME = MaizeServices
MaizeServices_FILES = $(wildcard *.m)
MaizeServices_FRAMEWORKS = CoreFoundation
MaizeServices_INSTALL_PATH = /Library/Frameworks

include $(THEOS_MAKE_PATH)/framework.mk
