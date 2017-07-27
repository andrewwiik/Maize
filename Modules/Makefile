ifeq ($(SIMULATOR),1)
	export TARGET = simulator:clang:latest:7.0
	export ARCHS = x86_64
else
	export TARGET = iphone:latest:7.0
	export ARCHS = armv7 arm64
endif

include $(THEOS)/makefiles/common.mk

export ADDITIONAL_CFLAGS = -I./../../headers -I./../../

SUBPROJECTS += ConnectivityModule DoNotDisturbModule LowPowerModule ScreenRecordingModule OrientationLockModule LocationModule RingerModule VPNModule
include $(THEOS_MAKE_PATH)/aggregate.mk
