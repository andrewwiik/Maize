#import "MZEConnectivityWiFiViewController.h"
#import <SpringBoard/SBWiFiManager+Private.h>
#import "MZEConnectivityWiFiNetworksViewController.h"

#if __cplusplus
    extern "C" {
#endif

   typedef struct __WiFiManager* WiFiManagerRef;
   typedef struct __WiFiDeviceClient* WiFiDeviceClientRef;
   typedef struct __WiFiNetwork* WiFiNetworkRef;

   typedef void (*WiFiManagerClientDeviceAttachmentCallback)(void *, void *, const void *object);

   CFStringRef WiFiNetworkGetSSID(void *);
   CFStringRef WiFiManagerClientGetUserAutoJoinState(void *);
   int WiFiManagerClientGetPower(void *);
   void WiFiManagerClientSetPower(void *, int power);
   void * WiFiManagerClientCreate(CFAllocatorRef allocator, int flags);
   void * WiFiManagerClientGetDevice(void *);
   int WiFiDeviceClientGetPower(void *);
   Boolean MobileWiFiContainsRadio();
   void WiFiManagerClientScheduleWithRunLoop(void *, CFRunLoopRef runLoop, CFStringRef mode);
   void WiFiManagerClientRegisterBackgroundScanCallback(void *, CFNotificationCallback callBack, const void *object);
   void WiFiManagerClientRegisterDeviceAttachmentCallback(void *, WiFiManagerClientDeviceAttachmentCallback callBack, const void *object);
   void * WiFiDeviceClientCopyCurrentNetwork(void *);
   void WiFiDeviceClientRegisterBgScanSuspendResumeCallback(void *, CFNotificationCallback callBack, const void *object);
   void WiFiDeviceClientRegisterLinkCallback(void *, CFNotificationCallback callBack, const void *object);
   void WiFiDeviceClientRegisterPowerCallback(void *, CFNotificationCallback callBack, const void *object);
   void WiFiDeviceClientRegisterBssidChangeCallback(void *, CFNotificationCallback callBack, const void *object);

   Boolean MGGetBoolAnswer(CFStringRef property);
#if __cplusplus
}
#endif

static MZEConnectivityWiFiViewController *sharedWifiController;
static void *_wifiManager;
static void *_wifiClient;
static void *_registeredWifiClient;

static void wifiEventCallback(void);
static void wifiDeviceAttachedCallback(void *, void *, __unused void *object);

@implementation MZEConnectivityWiFiViewController

+ (BOOL)isSupported {
	return YES;
}


- (id)init {
	_bundle = [NSBundle bundleForClass:[self class]];
	NSURL *packageURL = [_bundle URLForResource:@"WiFi" withExtension:@"ca"];
	CAPackage *package = [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
	UIColor *highlightColor = [UIColor systemBlueColor];

	self = [super initWithGlyphPackage:package highlightColor:highlightColor];
	if (self) {

		if (NSClassFromString(@"SBWiFiManager")) {
			SBWiFiManager *manager = [NSClassFromString(@"SBWiFiManager") sharedInstance];
			if (manager) {
				_wifiManager = [manager _manager];
				_wifiClient = [manager _device];
			}
		}

		if (!_wifiManager) {
			 HBLogInfo(@"CRASH POINT #6");
			_wifiManager = WiFiManagerClientCreate(kCFAllocatorDefault, 0);
			HBLogInfo(@"CRASH POINT #7");
			if (!_wifiManager) {
				return nil;
			}
		}

		if (_wifiManager && !_wifiClient) {
			HBLogInfo(@"CRASH POINT #0");
			_wifiClient = WiFiManagerClientGetDevice(_wifiManager);
			HBLogInfo(@"CRASH POINT #1");
			WiFiManagerClientScheduleWithRunLoop(_wifiManager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		}

		if (_wifiClient) {
			HBLogInfo(@"CRASH POINT #2");
			WiFiManagerClientRegisterDeviceAttachmentCallback(_wifiManager,(WiFiManagerClientDeviceAttachmentCallback)wifiDeviceAttachedCallback, NULL);
		}


		HBLogInfo(@"CRASH POINT #3");
		_isWAPI = MGGetBoolAnswer(CFSTR("wapi"));
		HBLogInfo(@"CRASH POINT #4");
		sharedWifiController = self;
	}
	return self;
}

- (int)_currentState {
	if ((BOOL)WiFiManagerClientGetPower(_wifiManager)) {
		if (WiFiDeviceClientCopyCurrentNetwork(_wifiClient)) {
			return 2;
		} else {
			return 3;
		}
	} else {
		if (MobileWiFiContainsRadio()) {
			return 1;
		} else {
			return 0;
		}
	}
}

- (void)buttonTapped:(UIControl *)button {
	[self _toggleState];
	[super buttonTapped:button];
	// MZEConnectivityWiFiNetworksViewController *wifiController = [[MZEConnectivityWiFiNetworksViewController alloc] init];
	// wifiController.buttonController = self;
	// [self.buttonDelegate buttonViewController:self willPresentSecondaryViewController:wifiController];
	// [self presentViewController:wifiController animated:true completion:nil];
}

- (NSString *)displayName {
	if (_isWAPI) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_WLAN_NAME" value:@"" table:nil];
	}
    return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_WIFI_NAME" value:@"" table:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self _updateState];
	[self _beginObservingStateChanges];
}

- (void)willBecomeActive {
	[self _updateState];
	[self _beginObservingStateChanges];
}

- (void)willResignActive {
	[self _stopObservingStateChanges];

}

- (void)_updateState {
	int state = [self _currentState];
	[self setEnabled:[self _enabledForState:state]];
	[self setInoperative:[self _inoperativeForState:state]];
	[self setGlyphState:[self _glyphStateForState:state]];
	[self setSubtitle:[self subtitleText]];
}

- (BOOL)_toggleState {
	if ((BOOL)WiFiManagerClientGetPower(_wifiManager)) {
		WiFiManagerClientSetPower(_wifiManager, 0);
		[self setEnabled:NO];
	} else {
		WiFiManagerClientSetPower(_wifiManager, 1);
		[self setEnabled:NO];
	}
	return YES;
}

- (NSString *)_glyphStateForState:(int)state {
	if (state == 3) {
		return @"seeking|1.5";
	} else if (state == 2) {
		return @"on";
	} else {
		return @"off";
	}
}

- (BOOL)_enabledForState:(int)state {
	if (state > 1) {
		return YES;
	} else {
		return NO;
	}
}
- (BOOL)_inoperativeForState:(int)state {
	if (state > 0) {
		return NO;
	} else return YES;
}

- (NSString *)currentSSID {
	if (_wifiClient) {
		return (__bridge NSString *)WiFiNetworkGetSSID(WiFiDeviceClientCopyCurrentNetwork(_wifiClient));
	}
	return @"";
}

- (NSString *)subtitleText {
	int state = [self _currentState];

	if (state == 3) {
		if (_isWAPI) {
			return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_WLAN_BUSY" value:@"" table:nil];
		} else {
			return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_WIFI_BUSY" value:@"" table:nil];
		}
	} else if (state == 2) {
		return [self currentSSID];
	} else {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_GENERIC_OFF" value:@"" table:nil];
	}
}

- (void)_beginObservingStateChanges {

	if (_wifiManager && _wifiClient && _wifiClient != _registeredWifiClient) {
			WiFiDeviceClientRegisterPowerCallback(_wifiClient, (CFNotificationCallback)wifiEventCallback, NULL);
			WiFiDeviceClientRegisterLinkCallback(_wifiClient, (CFNotificationCallback)wifiEventCallback, NULL);
			WiFiDeviceClientRegisterBssidChangeCallback(_wifiClient, (CFNotificationCallback)wifiEventCallback, NULL);
			WiFiDeviceClientRegisterBgScanSuspendResumeCallback(_wifiClient, (CFNotificationCallback)wifiEventCallback, NULL);
			_registeredWifiClient = _wifiClient;
	}
}

- (void)_stopObservingStateChanges {
	
}

@end


static void wifiEventCallback(void) {
	if (sharedWifiController) {
		[sharedWifiController _updateState];
	}

}


static void wifiDeviceAttachedCallback(void *manager, void *device, __unused void *object) {
	_wifiClient = device;
	if (sharedWifiController) {
		[sharedWifiController _beginObservingStateChanges];
		[sharedWifiController _updateState];
	}
}
