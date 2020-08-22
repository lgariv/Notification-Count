export ARCHS = arm64 arm64e
export TARGET := iphone:clang:13.5:11.0

FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NotificationCount

NotificationCount_FILES = Tweak.x
NotificationCount_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
