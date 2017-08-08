#import <SpringBoard/SBWiFiManager+Private.h>


%hook WiFiManager


+ (id)alloc {
	id orig = %orig;
	if (NSClassFromString(@"SBWiFiManager")) {
		SBWiFiManager *manager = [NSClassFromString(@"SBWiFiManager") sharedInstance];
		if (manager) {
			MSHookIvar<void *>(orig, "_manager") = [manager _manager];
			MSHookIvar<void *>(orig, "_device") = [manager _device];
		}
	}
	return orig;
}

- (id)init {
	if (NSClassFromString(@"SBWiFiManager")) {
		SBWiFiManager *manager = [NSClassFromString(@"SBWiFiManager") sharedInstance];
		if (manager) {
			MSHookIvar<void *>(self, "_manager") = [manager _manager];
			MSHookIvar<void *>(self, "_device") = [manager _device];
		}
	}

	id orig = %orig;

	if (NSClassFromString(@"SBWiFiManager")) {
		SBWiFiManager *manager = [NSClassFromString(@"SBWiFiManager") sharedInstance];
		if (manager) {
			MSHookIvar<void *>(orig, "_manager") = [manager _manager];
			MSHookIvar<void *>(orig, "_device") = [manager _device];
		}
	}

	return orig;
}

%end


%ctor {
	BOOL shouldInit = NO;
	if (!NSClassFromString(@"APTableCell")) {
		NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle"];
		NSBundle *bundle;
		bundle = [NSBundle bundleWithPath:fullPath];
		BOOL didLoad = [bundle load];
		if (didLoad) {
			shouldInit = YES;
		}
	} else {
		shouldInit = YES;
	}

	if (shouldInit) {
		%init;
	}
}