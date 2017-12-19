export THEOS_DEVICE_IP=169.254.194.91
export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.lw-internal.$(shell date +%y%m%d)"

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LockWatch
LockWatch_CFLAGS = -fobjc-arc -I./headers -I ./
LockWatch_FILES = LockWatch_iOS10.xm $(wildcard Core/*.m) $(wildcard LockScreen/*.m)
LockWatch_EXTRA_FRAMEWORKS = LockWatchKit

ifeq ($(THEOS_TARGET_NAME),iphone)
LockWatcg_EXTRA_FRAMEWORKS = Cephei
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
	@~/Documents/Xcode/simject/bin/respring_simulator all
endif
