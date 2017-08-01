#import "MZEConnectivityBluetoothViewController.h"
#import <QuartzCore/CAPackage+Private.h>

@implementation MZEConnectivityBluetoothViewController

- (id)init {
	_bundle = [NSBundle bundleForClass:[self class]];
	NSURL *packageURL = [_bundle URLForResource:@"Bluetooth" withExtension:@"ca"];
	CAPackage *package = [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
	UIColor *highlightColor = [UIColor systemBlueColor];

	self = [super initWithGlyphPackage:package highlightColor:highlightColor];
	if (self) {
		 _bluetoothManager = [NSClassFromString(@"BluetoothManager") sharedInstance];
	}
	return self;
}
- (void)buttonTapped:(UIControl *)button {
	[self _toggleState];
	[super buttonTapped:button];
}

- (NSString *)displayName {
    return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_BLUETOOTH_NAME" value:@"" table:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self _updateState];
	// [self _beginObservingStateChanges];

	// if ([self _enabledForState:[self _currentState]]) {
	// 	[self.bluetoothManager setDeviceScanningEnabled:YES];
 //    	[self.bluetoothManager scanForServices:0xFFFFFFFF];
	// }
}

- (void)willBecomeActive {
	[self _updateState];
	[self _beginObservingStateChanges];

	if ([self _enabledForState:[self _currentState]]) {
		[self.bluetoothManager setDeviceScanningEnabled:YES];
    	[self.bluetoothManager scanForServices:0xFFFFFFFF];
	}
}

- (void)willResignActive {
	[self _stopObservingStateChanges];
	[self.bluetoothManager setDeviceScanningEnabled:NO];

}

- (void)_updateState {
	int state = [self _currentState];
	[self setEnabled:[self _enabledForState:state]];
	[self setInoperative:[self _inoperativeForState:state]];
	[self setGlyphState:[self _glyphStateForState:state]];
	[self setSubtitle:[self subtitleText]];
}

- (BOOL)_toggleState {
	if ([self _currentState] > 1) {
		[_bluetoothManager setPowered:NO];
		[_bluetoothManager setEnabled:NO];
		[self setEnabled:NO];
	} else {
		[_bluetoothManager setPowered:YES];
		[_bluetoothManager setEnabled:YES];
		[self setEnabled:YES];
	}
	return YES;
}

- (NSString *)_glyphStateForState:(int)state {
	if (state == 4) {
		return @"seeking";
	} else if (state > 1) {
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

- (int)_stateWithOverridesApplied:(int)state {
	return state;
}

- (int)_currentState {
	if ([_bluetoothManager enabled]) {
		if ([[_bluetoothManager connectedDevices] count] > 0) {
			return 3;
		} else if ([_bluetoothManager deviceScanningInProgress]) {
			return 4;
		} else {
			return 2;
		}
	} else {
		if ([_bluetoothManager available]) {
			return 1;
		} else return 0;
	}
}

- (NSString *)subtitleText {
	int state = [self _currentState];

	if (state == 4) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_BLUETOOTH_BUSY" value:@"" table:nil];
	} else if (state == 3) {
		return [[[_bluetoothManager connectedDevices] firstObject] name];
	} else if (state == 2) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_BLUETOOTH_DISCONNECTED" value:@"" table:nil];
	} else {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_GENERIC_OFF" value:@"" table:nil];
	}
}

- (void)_beginObservingStateChanges {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(_updateState) name:@"BluetoothConnectionStatusChangedNotification" object:nil];
    [nc addObserver:self selector:@selector(_updateState) name:@"BluetoothDeviceDisconnectSuccessNotification" object:nil];
    [nc addObserver:self selector:@selector(_updateState) name:@"BluetoothDeviceConnectSuccessNotification" object:nil];
    [nc addObserver:self selector:@selector(_updateState) name:@"BluetoothPowerChangedNotification" object:nil];
    [nc addObserver:self selector:@selector(_updateState) name:@"BluetoothAvailabilityChangedNotification" object:nil];
}

- (void)_stopObservingStateChanges {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"BluetoothConnectionStatusChangedNotification" object:nil];
    [nc removeObserver:self name:@"BluetoothDeviceDisconnectSuccessNotification" object:nil];
    [nc removeObserver:self name:@"BluetoothDeviceConnectSuccessNotification" object:nil];
    [nc removeObserver:self name:@"BluetoothPowerChangedNotification" object:nil];
    [nc removeObserver:self name:@"BluetoothAvailabilityChangedNotification" object:nil];
}

- (void)dealloc {
	_bundle = nil;
	_bluetoothManager = nil;
	[self _stopObservingStateChanges];
}
@end