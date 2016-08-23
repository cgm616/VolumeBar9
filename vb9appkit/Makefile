include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VB9AppKit
VB9AppKit_FILES = Tweak.xm
VB9AppKit_LIBRARIES = objcipc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
