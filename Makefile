include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VolumeBar9
VolumeBar9_FILES = $(wildcard *.xm)
VolumeBar9_FRAMEWORKS = Foundation
VolumeBar9_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
