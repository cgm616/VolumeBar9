include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VolumeBar9
VolumeBar9_FILES = $(wildcard *.m)
VolumeBar9_INSTALL_PATH = /Library/PreferenceBundles
VolumeBar9_FRAMEWORKS = UIKit
VolumeBar9_PRIVATE_FRAMEWORKS = Preferences
VolumeBar9_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/VolumeBar9.plist$(ECHO_END)
