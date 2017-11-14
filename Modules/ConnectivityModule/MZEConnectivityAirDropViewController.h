#import "MZEConnectivityButtonViewController.h"
#import <Sharing/SFAirDropDiscoveryController.h>
#import <Sharing/SFAirDropDiscoveryControllerDelegate-Protocol.h>
#import "MZEConnectivityAirDropPopupViewController.h"

@interface MZEConnectivityAirDropViewController : MZEConnectivityButtonViewController <SFAirDropDiscoveryControllerDelegate> {
	SFAirDropDiscoveryController *_airDropDiscoveryController;
	NSBundle *_bundle;
}
@property (nonatomic, retain, readwrite) SFAirDropDiscoveryController *airDropDiscoveryController;
- (id)init;
- (NSInteger)_currentState;
- (void)_updateState;
- (BOOL)_enabledForState:(int)state;
- (NSString *)subtitleText;
- (NSString *)displayName;
- (void)discoveryControllerVisibilityDidChange:(id)arg1;
- (void)discoveryControllerSettingsDidChange:(id)arg1;
- (MZEConnectivityAirDropPopupViewController *)airdropPopupController;
@end