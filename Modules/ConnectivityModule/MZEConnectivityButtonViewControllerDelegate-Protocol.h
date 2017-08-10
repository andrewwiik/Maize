@class MZEConnectivityButtonViewController;


@protocol MZEConnectivityButtonViewControllerDelegate <NSObject>
@required
- (BOOL)isExpanded;
- (void)buttonViewController:(MZEConnectivityButtonViewController *)buttonController willPresentSecondaryViewController:(UIViewController *)secondaryViewController;
- (void)buttonViewController:(MZEConnectivityButtonViewController *)buttonController didDismissSecondaryViewController:(UIViewController *)secondaryViewController;
@end