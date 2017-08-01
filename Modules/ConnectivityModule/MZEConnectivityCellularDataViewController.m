#import "MZEConnectivityCellularDataViewController.h"


#if __cplusplus
    extern "C" {
#endif
    extern CFStringRef const kCTRegistrationStatusChangedNotification;
	extern CFStringRef const kCTRegistrationStatusSearching;
	extern CFStringRef const kCTRegistrationDataStatusChangedNotification;
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


static void telephonyEventCallback(void);

@implementation MZEConnectivityCellularDataViewController
- (id)init {
	_bundle = [NSBundle bundleForClass:[self class]];
	NSURL *packageURL = [_bundle URLForResource:@"CellularData" withExtension:@"ca"];
	CAPackage *package = [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
	UIColor *highlightColor = [UIColor systemGreenColor];

	self = [super initWithGlyphPackage:package highlightColor:highlightColor];
	if (self) {
		// _bluetoothManager = [NSClassFromString(@"BluetoothManager") sharedInstance];
		sharedDataController = self;
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
	if (CTCellularDataPlanGetIsEnabled()) {
		if (CTRegistrationGetStatus() == kCTRegistrationStatusSearching) {
			return 2;
		} else return 1;
	} else return 0;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if (!_airplaneModeController) {
		_airplaneModeController = [[NSClassFromString(@"RadiosPreferences") alloc] init];
		[_airplaneModeController setDelegate:self];
	}
	[self _updateState];
}

- (void)willBecomeActive {
	sharedDataController = self;
	[self _updateState];
	[self _beginObservingStateChanges];
}

- (void)willResignActive {
	[self _stopObservingStateChanges];
}

- (void)_updateState {
	[self setEnabled:CTCellularDataPlanGetIsEnabled()];
	[self setGlyphState:[self _glyphStateForState:[self _currentState]]];
	[self setSubtitle:[self subtitleText]];
	[self setInoperative:NO];

}
- (BOOL)_toggleState {
	if ([self _currentState] > 0) {
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
	if (state == 2) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_BLUETOOTH_BUSY" value:@"" table:nil];
	} else if (state == 1) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_GENERIC_ON" value:@"" table:nil];
	} else {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_GENERIC_OFF" value:@"" table:nil];
	}
}

- (NSString *)_glyphStateForState:(int)state {
	if (state == 2) {
		return @"seeking";
	} else if (state == 1) {
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
}

- (void)_stopObservingStateChanges {
	CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(), (CFNotificationCallback)telephonyEventCallback, kCTRegistrationDataStatusChangedNotification, NULL);
	CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(), (CFNotificationCallback)telephonyEventCallback, kCTRegistrationStatusChangedNotification, NULL);
}

@end

static void telephonyEventCallback(void) {
	if (sharedDataController) {
		[sharedDataController _updateState];
	}

}