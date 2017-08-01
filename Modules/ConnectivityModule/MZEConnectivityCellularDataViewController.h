#import <AppSupport/RadiosPreferences+Private.h>
#import <AppSupport/RadiosPreferencesDelegate-Protocol.h>
#import "MZEConnectivityButtonViewController.h"
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIColor+Private.h>

@interface MZEConnectivityCellularDataViewController : MZEConnectivityButtonViewController <RadiosPreferencesDelegate> {
    NSBundle *_bundle;
    RadiosPreferences *_airplaneModeController;
}
@property (nonatomic, retain, readwrite) RadiosPreferences *airplaneModeController;
- (id)init;
- (int)_currentState;
- (void)buttonTapped:(UIControl *)button;
- (NSString *)displayName;
- (void)viewDidLoad;
- (void)_updateState;
- (BOOL)_toggleState;
- (NSString *)_glyphStateForState:(int)state;
- (void)_beginObservingStateChanges;
- (void)_stopObservingStateChanges;
- (void)willBecomeActive;
- (void)willResignActive;
- (void)airplaneModeChanged;
@end