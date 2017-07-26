#import <MaizeUI/MZEExpandingModuleDelegate-Protocol.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>

@interface MZEConnectivityModuleViewController : UIViewController <MZEContentModuleContentViewController> {
	CGFloat _prefferedContentExpandedHeight;
}
@property (nonatomic, retain) NSMutableArray *buttonViewControllers;
- (CGFloat)prefferedContentExpandedWidth;
- (CGFloat)prefferedContentExpandedHeight;
- (BOOL)providesOwnPlatter;
@end