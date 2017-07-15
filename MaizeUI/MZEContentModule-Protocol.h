@class MZEContentModuleContext, UIViewController;
@protocol MZEContentModuleContentViewController;

@protocol MZEContentModule
@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;

@optional
@property(readonly, nonatomic) UIViewController *backgroundViewController;
- (void)setContentModuleContext:(MZEContentModuleContext *)arg1;
@end