include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LockWatchPrefs
LockWatchPrefs_FILES = LWPRootListController.m LWPInstalledFacesController.m
LockWatchPrefs_INSTALL_PATH = /Library/PreferenceBundles
LockWatchPrefs_FRAMEWORKS = UIKit
LockWatchPrefs_PRIVATE_FRAMEWORKS = Preferences
LockWatchPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LockWatchPrefs.plist$(ECHO_END)
