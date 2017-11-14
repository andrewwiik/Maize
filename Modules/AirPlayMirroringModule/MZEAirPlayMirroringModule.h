#import <MaizeUI/MZEContentModule-Protocol.h>
#import "MZEAirPlayMirroringModuleViewController.h"
#import <QuartzCore/CAPackage+Private.h>

@interface MZEAirPlayMirroringModule : NSObject <MZEContentModule> {
	MZEAirPlayMirroringModuleViewController	*_viewController;
}
@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;
- (CAPackage *)glyphPackage;
@end