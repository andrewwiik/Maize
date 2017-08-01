
#import <BluetoothManager/BluetoothManager-Class.h>
#import "MZEConnectivityButtonViewController.h"
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIColor+Private.h>

@interface MZEConnectivityBluetoothViewController : MZEConnectivityButtonViewController {
    BluetoothManager *_bluetoothManager;
    NSBundle *_bundle;
}
@property (nonatomic, retain, readwrite) BluetoothManager *bluetoothManager;
- (id)init;
- (void)buttonTapped:(UIControl *)button;
- (NSString *)displayName;
- (void)_updateState;
- (BOOL)_toggleState;
- (NSString *)_glyphStateForState:(int)state;
- (BOOL)_enabledForState:(int)state;
- (BOOL)_inoperativeForState:(int)state;
- (int)_stateWithOverridesApplied:(int)state;
- (int)_currentState;
- (void)_beginObservingStateChanges;
- (void)_stopObservingStateChanges;
- (NSString *)subtitleText;
@end