#import "MZEConnectivityCellularDataViewController.h"


#if __cplusplus
    extern "C" {
#endif
    extern CFStringRef const kCTRegistrationStatusChangedNotification;
	extern CFStringRef const kCTRegistrationStatusSearching;
	extern CFStringRef const kCTRegistrationDataStatusChangedNotification;
	extern CFStringRef const kCTRegistrationOperatorNameChangedNotification;
	extern CFStringRef const kCTRegistrationDisplayStatusChangedNotification;
	extern CFStringRef const kCTRegistrationDisplayStatus;
	Boolean CTCellularDataPlanGetIsEnabled();
	void CTCellularDataPlanSetIsEnabled(Boolean enabled);
   	CFStringRef CTRegistrationGetStatus();
	CFNotificationCenterRef CTTelephonyCenterGetDefault();
	void CTTelephonyCenterAddObserver(CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior);
	void CTTelephonyCenterRemoveObserver(CFNotificationCenterRef center, const void *observer, CFStringRef name, const void *object);
#if __cplusplus
}
#endif

static MZEConnectivityCellularDataViewController *sharedDataController;
//static BOOL isSearching = NO;

@interface SBTelephonyManager : NSObject
+ (instancetype)sharedTelephonyManager;
-(int)registrationStatus;
@end


static void telephonyEventCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);

@implementation MZEConnectivityCellularDataViewController
- (id)init {
	_bundle = [NSBundle bundleForClass:[self class]];
	_iapBundle = [NSBundle bundleWithIdentifier:@"com.apple.IAP"];
	NSURL *packageURL = [_bundle URLForResource:@"CellularData" withExtension:@"ca"];
	CAPackage *package = [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
	UIColor *highlightColor = [UIColor systemGreenColor];

	self = [super initWithGlyphPackage:package highlightColor:highlightColor];
	if (self) {
		_lastGlyphState = @"";
		// _bluetoothManager = [NSClassFromString(@"BluetoothManager") sharedInstance];
		sharedDataController = self;
		[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(_updateState)
			name:@"com.ioscreatix.Maize.CellularStateChanged"
			object:nil];
	}
	return self;
}

- (void)buttonTapped:(UIControl *)button {
	[self _toggleState];
	[super buttonTapped:button];
}

- (NSString *)displayName {
	return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_CELLUAR_DATA_NAME" value:@"" table:nil];
}

- (int)_currentState {
	if (CTCellularDataPlanGetIsEnabled() && ![_airplaneModeController airplaneMode]) {
		int registrationStatus = [[NSClassFromString(@"SBTelephonyManager") sharedTelephonyManager] registrationStatus];
		if (registrationStatus == 1) {
			return 3;
		} else if (registrationStatus == 3) {
			return 4;
		} else {
			return 2;
		}
	} else {
		if ([_airplaneModeController airplaneMode]) {
			return 1;
		} else return 0;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if (!_airplaneModeController) {
		_airplaneModeController = [[NSClassFromString(@"RadiosPreferences") alloc] init];
		[_airplaneModeController setDelegate:self];
	}
	[self _beginObservingStateChanges];
	[self _updateState];
}

- (void)willBecomeActive {
	sharedDataController = self;
	[self _updateState];
	//[self _beginObservingStateChanges];
}

- (void)willResignActive {
	//[self _stopObservingStateChanges];
}

- (void)_updateState {
	int currentState = [self _currentState];
	[self setEnabled:currentState > 1 ? YES : NO];

	NSString *glyphState = [self _glyphStateForState:currentState];
	if (![_lastGlyphState isEqualToString:glyphState]) {
		[self setGlyphState:glyphState];
		_lastGlyphState = glyphState;
	}
	//[self setGlyphState:[self _glyphStateForState:[self _currentState]]];
	[self setSubtitle:[self subtitleText]];
	[self setInoperative:[_airplaneModeController airplaneMode]];

}
- (BOOL)_toggleState {
	if ([self _currentState] > 1) {
		CTCellularDataPlanSetIsEnabled(NO);
		[self setEnabled:NO];
	} else {
		CTCellularDataPlanSetIsEnabled(YES);
		[self setEnabled:YES];
	}
	return YES;
}
- (NSString *)subtitleText {
	int state = [self _currentState];
	if (state == 4) {
		return [_iapBundle localizedStringForKey:@"TELEPHONY_NO_SERVICE" value:@"" table:@"Framework"];
	} else if (state == 3) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_BLUETOOTH_BUSY" value:@"" table:nil];
	} else if (state == 2) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_GENERIC_ON" value:@"" table:nil];
	} else if (state == 1) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_AIRPLANE_MODE_NAME" value:@"AIRPLANE_MODE_NAME" table:nil];
	} else {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_GENERIC_OFF" value:@"" table:nil];
	}
}

- (NSString *)_glyphStateForState:(int)state {
	if (state == 3) {
		return @"seeking|2.0";
	} else if (state == 2 || state == 4) {
		return @"on";
	} else {
		return @"off";
	}
}

- (void)airplaneModeChanged {
	[self _updateState];
}

- (void)_beginObservingStateChanges {
	CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, (CFNotificationCallback)telephonyEventCallback, kCTRegistrationDataStatusChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
	CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, (CFNotificationCallback)telephonyEventCallback, kCTRegistrationStatusChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
	//CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, (CFNotificationCallback)telephonyEventCallback, kCTRegistrationOperatorNameChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
	CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, (CFNotificationCallback)telephonyEventCallback, kCTRegistrationDisplayStatusChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);

}

- (void)_stopObservingStateChanges {
	CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(), (CFNotificationCallback)telephonyEventCallback, kCTRegistrationDataStatusChangedNotification, NULL);
	CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(), (CFNotificationCallback)telephonyEventCallback, kCTRegistrationStatusChangedNotification, NULL);
	//CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(), (CFNotificationCallback)telephonyEventCallback, kCTRegistrationOperatorNameChangedNotification, NULL);
	CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(), (CFNotificationCallback)telephonyEventCallback, kCTRegistrationDisplayStatusChangedNotification, NULL);

}

- (NSString *)regStatus {
	return (__bridge NSString *)CTRegistrationGetStatus();
}

- (void)dealloc {
	_airplaneModeController.delegate = nil;
	_airplaneModeController = nil;
	_iapBundle = nil;
	[self _stopObservingStateChanges];
}

@end

static void telephonyEventCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	// if (CFEqual(name, kCTRegistrationDisplayStatusChangedNotification)) {
	// 	if (CFEqual(CFDictionaryGetValue(userInfo,kCTRegistrationDisplayStatus), kCTRegistrationStatusSearching)) {
	// 		isSearching = YES;
	// 		HBLogInfo(@"GOT IS SEARCHING");
	// 	} else {
	// 		isSearching = NO;
	// 	}

	// 	CFShow(userInfo);

	// }

	// HBLogInfo(@"DisplayStatusInfo: \nNotificationName: %@\nData: %@",(__bridge NSString *)name, (__bridge NSDictionary *)userInfo);

	if (sharedDataController) {
		[sharedDataController _updateState];
	}

}