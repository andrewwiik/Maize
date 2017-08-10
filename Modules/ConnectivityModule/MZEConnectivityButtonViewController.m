#import "MZEConnectivityButtonViewController.h"

@implementation MZEConnectivityButtonViewController
	@synthesize buttonDelegate = _buttonDelegate;

+ (BOOL)isSupported {
	return YES;
}

- (void)_updateStringForEnabledStatus:(BOOL)enabledStatus {
	[self setSubtitle:[self subtitleText]];
}

- (void)buttonTapped:(UIControl *)button {

}

- (NSString *)displayName {
	return @"";
}

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self _updateStringForEnabledStatus:enabled];
}

- (NSString *)statusText {
	return nil;
}

- (NSString *)subtitleText {
	NSString *key = @"";
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	if ([self isEnabled]) {
			key = @"CONTROL_CENTER_STATUS_GENERIC_ON";
	}
	else {
			key = @"CONTROL_CENTER_STATUS_GENERIC_OFF";
	}
	return [bundle localizedStringForKey:key value:@"" table:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setTitle:[self displayName]];
}

- (void)willResignActive {

}

- (void)willBecomeActive {
	
}

- (void)didDismissSecondaryViewController:(UIViewController *)viewController {
	[self.buttonDelegate buttonViewController:self didDismissSecondaryViewController:viewController];
}

@end