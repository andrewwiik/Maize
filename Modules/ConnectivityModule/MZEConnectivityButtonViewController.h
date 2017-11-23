#import <MaizeUI/MZELabeledRoundButtonViewController.h>
#import "MZEConnectivityButtonViewControllerDelegate-Protocol.h"

@interface MZEConnectivityButtonViewController : MZELabeledRoundButtonViewController {
	__weak id <MZEConnectivityButtonViewControllerDelegate> _buttonDelegate;
}

@property(nonatomic) __weak id <MZEConnectivityButtonViewControllerDelegate> buttonDelegate;

+ (BOOL)isSupported;
- (void)_updateStringForEnabledStatus:(BOOL)enabledStatus;
- (void)buttonTapped:(UIControl *)button;
- (NSString *)displayName;
- (void)setEnabled:(BOOL)enabled;
- (NSString *)statusText;
- (NSString *)subtitleText;
- (void)viewDidLoad;
- (void)willResignActive;
- (void)willBecomeActive;
- (void)didDismissSecondaryViewController:(UIViewController *)viewController;
- (void)moduleDidExpand:(BOOL)didExpand;
@end