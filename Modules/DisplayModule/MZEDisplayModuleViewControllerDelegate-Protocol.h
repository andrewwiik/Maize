
@class MZEDisplayModuleViewController;

@protocol MZEDisplayModuleViewControllerDelegate <NSObject>
- (void)displayModuleViewController:(MZEDisplayModuleViewController *)moduleViewController brightnessDidChange:(float)volume;
@end

