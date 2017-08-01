#import <AppSupport/RadiosPreferences+Private.h>
#import <AppSupport/RadiosPreferencesDelegate-Protocol.h>
#import "MZEConnectivityButtonViewController.h"
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIColor+Private.h>

@interface MZEConnectivityAirplaneViewController : MZEConnectivityButtonViewController <RadiosPreferencesDelegate> {
    BOOL _airplaneModeEnabled;
    RadiosPreferences *_airplaneModeController;
    NSBundle *_bundle;
}
@property (nonatomic, setter=_setAirplaneModeEnabled:, getter=_isAirplaneModeEnabled) BOOL airplaneModeEnabled;
@property (nonatomic, retain, readwrite) RadiosPreferences *airplaneModeController;
- (id)init;
- (void)buttonTapped:(UIControl *)button;
- (NSString *)displayName;
- (void)viewDidLoad;
- (void)airplaneModeChanged;
- (void)_updateState;
- (BOOL)_toggleState;
- (BOOL)_stateWithEffectiveOverrides;
- (BOOL)_isStateOverridden;
- (BOOL)_isAirplaneModeEnabled;
- (void)_setAirplaneModeEnabled:(BOOL)enabled;
@end