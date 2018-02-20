export THEOS_DEVICE_IP=192.168.178.98
export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.lw-internal.$(shell date +%y%m%d)"

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LockWatch
LockWatch_CFLAGS = -fobjc-arc -I./headers -I ./
LockWatch_FILES = LockWatch_iOS10.xm $(wildcard Core/*.m) $(wildcard LockScreen/*.m)
LockWatch_EXTRA_FRAMEWORKS = LockWatchKit

ifeq ($(THEOS_TARGET_NAME),iphone)
LockWatch_EXTRA_FRAMEWORKS += Cephei
endif

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

ifeq ($(THEOS_TARGET_NAME),iphone_simulator)
after-all::
	@echo Copying .dylib to /opt/simject
	@cp $(THEOS_OBJ_DIR)/$(PROJECT_NAME).dylib /opt/simject
	@cp $(PROJECT_NAME).plist /opt/simject
	@ldid -S /opt/simject/$(PROJECT_NAME).dylib
	@~/Documents/Xcode/simject/bin/respring_simulator -d "iPhone 6s" -v 10.2
endif

ifeq ($(THEOS_TARGET_NAME),iphone)
LockWatch_SUBPROJECTS = lockwatchprefs
endif

include $(THEOS_MAKE_PATH)/aggregate.mk
