include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VolumeBar9
VolumeBar9_FILES = $(wildcard *.xm) UIImage+Scale.m
VolumeBar9_FRAMEWORKS = Foundation
VolumeBar9_LIBRARIES = colorpicker objcipc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += prefs
SUBPROJECTS += vb9appkit
include $(THEOS_MAKE_PATH)/aggregate.mk

depiction: README.md
	@mkdir -p ./generated_depictions/
	@ruby ./depictions/generate.rb ./README.md $(shell cat ./control | grep Name: | cut -d' ' -f2-) $(shell cat ./control | grep Version: | cut -d' ' -f2-) $(shell cat ./control | grep Package: | cut -d' ' -f2-)
