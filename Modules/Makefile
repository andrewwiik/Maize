ifeq ($(SIMULATOR),1)
	export TARGET = simulator:clang:latest:7.0
	export ARCHS = x86_64
else
	export TARGET = iphone:latest:7.0
	export ARCHS = armv7 arm64
endif

include $(THEOS)/makefiles/common.mk

export ADDITIONAL_CFLAGS = -I./../../headers -I./../../

SUBPROJECTS += ConnectivityModule 
SUBPROJECTS += DoNotDisturbModule
SUBPROJECTS += LowPowerModule
SUBPROJECTS += ScreenRecordingModule
SUBPROJECTS += OrientationLockModule
SUBPROJECTS += LocationModule
SUBPROJECTS += RingerModule
SUBPROJECTS += VPNModule
SUBPROJECTS += AudioModule
SUBPROJECTS += DisplayModule
SUBPROJECTS += FlashlightModule
# SUBPROJECTS += MusicModule
include $(THEOS_MAKE_PATH)/aggregate.mk
