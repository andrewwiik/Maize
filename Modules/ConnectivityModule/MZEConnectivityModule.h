#import <MaizeUI/MZEContentModule-Protocol.h>
#import "MZEConnectivityModuleViewController.h"

@interface MZEConnectivityModule : NSObject <MZEContentModule> {
	MZEConnectivityModuleViewController	*_viewController;
}
@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;
@end