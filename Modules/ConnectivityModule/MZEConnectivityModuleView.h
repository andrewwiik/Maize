@class MZEConnectivityModuleViewController;

@interface MZEConnectivityModuleView : UIView
@property (nonatomic, retain, readwrite) MZEConnectivityModuleViewController *layoutDelegate;
- (id)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;
@end