#import <MaizeUI/MZEExpandingModuleDelegate-Protocol.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>
#import "MZEConnectivityButtonViewController.h"

@interface MZEConnectivityModuleViewController : UIViewController <MZEContentModuleContentViewController> {
	CGFloat _prefferedContentExpandedHeight;
	NSMutableArray<MZEConnectivityButtonViewController *> *_buttonViewControllers;
	BOOL _isExpanded;

}
@property (nonatomic, retain, readwrite) NSMutableArray<MZEConnectivityButtonViewController *> *buttonViewControllers;
@property (nonatomic, readwrite) BOOL isExpanded;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (CGFloat)preferredExpandedContentWidth;
- (CGFloat)preferredExpandedContentHeight;
- (CGSize)_buttonSize;
- (BOOL)providesOwnPlatter;
+ (NSArray *)defaultButtonClasses;
- (MZEConnectivityButtonViewController *)_makeButtonWithClass:(Class)buttonClass;
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;
- (NSUInteger)visibleColumns;
- (NSUInteger)visibleRows;
- (NSUInteger)numberOfColumns;
- (NSUInteger)numberOfRows;
- (void)willBecomeActive;
- (void)willResignActive;
@end