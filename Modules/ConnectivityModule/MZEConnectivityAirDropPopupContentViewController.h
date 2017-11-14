#import <Sharing/SFAirDropDiscoveryController.h>
#import <Sharing/SFAirDropDiscoveryControllerDelegate-Protocol.h>
#import <MaizeUI/MZEMenuModuleViewController.h>


@class MZEConnectivityAirDropPopupViewController;

@interface MZEConnectivityAirDropPopupContentViewController : MZEMenuModuleViewController {
	MZEConnectivityAirDropPopupViewController *_rootController;
}
@property (nonatomic, retain, readwrite) MZEConnectivityAirDropPopupViewController *rootController;
- (id)initWithRootController:(MZEConnectivityAirDropPopupViewController *)rootController;
@end