include $(THEOS)/makefiles/common.mk

TWEAK_NAME = mediapatches
mediapatches_CFLAGS = -fobjc-arc
mediapatches_FILES = Patch.xm
mediapatches_FRAMEWORKS = UIKit CoreGraphics MediaPlayer AVKit
mediapatches_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk
