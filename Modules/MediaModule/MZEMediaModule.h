#import <MaizeUI/MZEContentModule-Protocol.h>
#import "MZEMediaModuleViewController.h"

@interface MZEMediaModule : NSObject <MZEContentModule> {
	MZEMediaModuleViewController	*_viewController;
}
@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;
@end
