#import <MaizeUI/MZELabeledRoundButtonViewController.h>
#import <MaizeUI/MZESliderModuleBackgroundViewController.h>

@interface MZEDisplayModuleBackgroundViewController : MZESliderModuleBackgroundViewController {
	MZELabeledRoundButtonViewController *_nightShiftButton;
	NSBundle *_bundle;
	BOOL _nightShiftEnabled;
}
@property (nonatomic, retain, readwrite) MZELabeledRoundButtonViewController *nightShiftButton;
- (id)init;
- (void)_setupNightShiftButton;
- (void)viewDidLoad;
- (void)viewWillLayoutSubviews;
@end