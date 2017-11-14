#import <AppSupport/RadiosPreferences+Private.h>
#import <AppSupport/RadiosPreferencesDelegate-Protocol.h>
#import "MZEConnectivityButtonViewController.h"
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIColor+Private.h>
#import <ControlCenterUI/CCUIPersonalHotspotSetting.h>
#import <Flipswitch/FSSwitchState.h>

@interface MZEConnectivityHotspotViewController : MZEConnectivityButtonViewController <RadiosPreferencesDelegate> {
    BOOL _hotspotModeEnabled;
    CCUIPersonalHotspotSetting *_hotspotModeController;
    RadiosPreferences *_airplaneModeController;
    NSBundle *_bundle;
    NSString *_switchIdentifier;
    FSSwitchState _currentState;
	BOOL _isEnabled;
}
@property (nonatomic, setter=_setHotspotModeEnabled:, getter=_isHotspotModeEnabled) BOOL hotspotModeEnabled;
@property (nonatomic, retain, readwrite) CCUIPersonalHotspotSetting *hotspotModeController;
@property (nonatomic, retain, readwrite) RadiosPreferences *airplaneModeController;
- (id)init;
- (void)buttonTapped:(UIControl *)button;
- (NSString *)displayName;
- (void)viewDidLoad;
- (void)hotspotModeChanged;
- (void)_updateState;
- (BOOL)_toggleState;
- (BOOL)_stateWithEffectiveOverrides;
- (BOOL)_isStateOverridden;
- (BOOL)_isHotspotModeEnabled;
- (void)_setHotspotModeEnabled:(BOOL)enabled;
@end