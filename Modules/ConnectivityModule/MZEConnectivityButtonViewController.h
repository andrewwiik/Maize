#import <MaizeUI/MZELabeledRoundButtonViewController.h>

@interface MZEConnectivityButtonViewController : MZELabeledRoundButtonViewController

+ (BOOL)isSupported;
- (void)_updateStringForEnabledStatus:(BOOL)enabledStatus;
- (void)buttonTapped:(UIControl *)button;
- (NSString *)displayName;
- (void)setEnabled:(BOOL)enabled;
- (NSString *)statusText;
- (NSString *)subtitleText;
- (void)viewDidLoad;

@end