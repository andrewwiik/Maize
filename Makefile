include $(THEOS)/makefiles/common.mk

ifeq ($(SIMULATOR),1)
	export TARGET = simulator:clang:latest:7.0
	export ARCHS = x86_64
else
	export TARGET = iphone:latest:7.0
	export ARCHS = armv7 arm64
endif

Maize_CFLAGS = -fobjc-arc -I./headers

TWEAK_NAME = Maize
Maize_FILES = $(wildcard *.m) $(wildcard *.xm)

include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(SIMULATOR),1)
after-all::
	@echo Copying .dylib to /opt/simject
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject
	@echo Copying .plist to /opt/simject
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	@echo Signing .dylib in /opt/simject
	@ldid -S /opt/simject/$(TWEAK_NAME).dylib
endif

after-install::
	install.exec "killall -9 SpringBoard"
