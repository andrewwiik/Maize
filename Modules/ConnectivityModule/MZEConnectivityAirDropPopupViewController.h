
#import <Sharing/SFAirDropDiscoveryController.h>
#import <Sharing/SFAirDropDiscoveryControllerDelegate-Protocol.h>

@interface MZEConnectivityAirDropPopupViewController : UIViewController {
	SFAirDropDiscoveryController *_discoveryController;
}
@property (nonatomic, retain, readwrite) SFAirDropDiscoveryController *discoveryController;
- (id)initWithDiscoveryController:(SFAirDropDiscoveryController *)discoveryController;
@end