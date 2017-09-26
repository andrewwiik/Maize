
#import <MaizeUI/MZELayoutOptions.h>
#import <ControlCenterUI/CCUIShortcutModule.h>
#import <SpringBoard/SBUnlockActionContext.h>
#import <SpringBoard/SBCCShortcutModule.h>
#import <SpringBoard/SBLockScreenActionContext+Private.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoard/SBDeviceLockController.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBUIController+Private.h>
#import <SpringBoard/SBLockScreenManager+Private.h>
#import <SpringBoard/SBControlCenterController+Private.h>
// #import <SpringBoard/SBCCTimerShortcut.h>
// #import <SpringBoard/SBCCCalculatorShortcut.h>
// #import <SpringBoard/SBCCCameraShortcut.h>


#define NSCLeft        NSLayoutAttributeLeft
#define NSCRight       NSLayoutAttributeRight
#define NSCTop         NSLayoutAttributeTop
#define NSCBottom      NSLayoutAttributeBottom
#define NSCLeading     NSLayoutAttributeLeading
#define NSCTrailing    NSLayoutAttributeTrailing
#define NSCWidth       NSLayoutAttributeWidth
#define NSCHeight      NSLayoutAttributeHeight
#define NSCCenterX     NSLayoutAttributeCenterX
#define NSCCenterY     NSLayoutAttributeCenterY
#define NSCBaseline    NSLayoutAttributeBaseline

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define NSCLessThanOrEqual     NSLayoutRelationLessThanOrEqual
#define NSCEqual               NSLayoutRelationEqual
#define NSCGreaterThanOrEqual  NSLayoutRelationGreaterThanOrEqual

#define Constraint(item1, attr1, rel, item2, attr2, con) [NSLayoutConstraint constraintWithItem:(item1) attribute:(attr1) relatedBy:(rel) toItem:(item2) attribute:(attr2) multiplier:1 constant:(con)]
#define VisualConstraints(format, ...) [NSLayoutConstraint constraintsWithVisualFormat:(format) options:0 metrics:nil views:_NSDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)]
#define VisualConstraintWithMetrics(format, theMetrics, ...) [NSLayoutConstraint constraintsWithVisualFormat:(format) options:0 metrics:(theMetrics) views:_NSDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)]
#define ConstantConstraint(item, attr, rel, con) Constraint((item), (attr), (rel), nil, NSLayoutAttributeNotAnAttribute, (con))

#define horizontallyFillSuperview ^(UIView *view, NSUInteger idx, BOOL *stop) {[view.superview addConstraints:VisualConstraints(@"|[view]|", view)];}


#define IS_RTL ([MZELayoutOptions isRTL])
#if __cplusplus
    extern "C" {
#endif
    CGPoint UIRectGetCenter(CGRect rect);
	CGFloat UICeilToViewScale(CGFloat value, UIView *view);
	CGFloat UIRoundToViewScale(CGFloat value, UIView *view);
	//CGPoint UIPointRoundToViewScale(CGPoint point, UIView *view);
#if __cplusplus
}
#endif

#define UIPointRoundToViewScale(point, view) CGPointMake(UIRoundToViewScale(point.x, view), UIRoundToViewScale(point.y,view))

//#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];


static inline unsigned int intFromHexString(NSString *hexString) {
	unsigned int hexInt = 0;

  // Create scanner
  NSScanner *scanner = [NSScanner scannerWithString:hexString];

  // Tell scanner to skip the # character
  [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];

  // Scan hex value
  [scanner scanHexInt:&hexInt];

  return hexInt;
}

static inline UIColor *colorFromHexString(NSString *hexString) {
	unsigned int hexint = intFromHexString(hexString);

  // Create color object, specifying alpha as well
  UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
    blue:((CGFloat) (hexint & 0xFF))/255
    alpha:1.0];

  return color;
}

#pragma mark Launching Applications

static inline void launchAppDirect(SBApplication *application)
{
	if (application != nil)
	{
		SBUIController *controller = (SBUIController *)[NSClassFromString(@"SBUIController") sharedInstance];

		if (NSClassFromString(@"SBCCShortcutModule") != nil)
		{
			SBCCShortcutModule *module = [[NSClassFromString(@"SBCCShortcutModule") alloc] init];
			[module activateAppWithDisplayID:application.bundleIdentifier url:nil];
			return;
		} else if (NSClassFromString(@"CCUIShortcutModule") != nil) {
			CCUIShortcutModule *module = [[NSClassFromString(@"CCUIShortcutModule") alloc] init];
			[module activateAppWithDisplayID:application.bundleIdentifier url:nil unlockIfNecessary:YES];
			return;
		}

		if ([controller respondsToSelector:@selector(activateApplicationAnimated:)]) {
			[controller activateApplicationAnimated:application];
		} else if ([controller respondsToSelector:@selector(activateApplication:)]) {
			[controller activateApplication:application];
		}
	}
}

static inline void launchApplication(SBApplication *launchApp)
{
	if (launchApp == nil) return;

	NSArray *standardIDs = @[@"com.apple.mobiletimer", @"com.apple.calculator", @"com.apple.camera"];
	if ([standardIDs containsObject:launchApp.bundleIdentifier] && NSClassFromString(@"SBCCShortcutModule") != nil)
	{
		SBCCShortcutModule *module = nil;
		if (NSClassFromString(@"SBCCShortcutModule")) {
			if ([launchApp.bundleIdentifier isEqualToString:@"com.apple.mobiletimer"]) module = [[NSClassFromString(@"SBCCTimerShortcut") alloc] init];
			else if ([launchApp.bundleIdentifier isEqualToString:@"com.apple.calculator"]) module = [[NSClassFromString(@"SBCCCalculatorShortcut") alloc] init];
			else if ([launchApp.bundleIdentifier isEqualToString:@"com.apple.camera"]) module = [[NSClassFromString(@"SBCCCameraShortcut") alloc] init];
		} else {
			if ([launchApp.bundleIdentifier isEqualToString:@"com.apple.mobiletimer"]) module = [[NSClassFromString(@"CCUITimerShortcut") alloc] init];
			else if ([launchApp.bundleIdentifier isEqualToString:@"com.apple.calculator"]) module = [[NSClassFromString(@"CCUICalculatorShortcut") alloc] init];
			else if ([launchApp.bundleIdentifier isEqualToString:@"com.apple.camera"]) module = [[NSClassFromString(@"CCUICameraShortcut") alloc] init];
		}
		 if (module != nil) [module activateApp];

		 return;
	}

	if ([[NSClassFromString(@"SBDeviceLockController") sharedController] isPasscodeLocked]) {
    	SBLockScreenManager *manager = (SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager") sharedInstance];
     	if ([manager isUILocked])
     	{
     		//Hotfix for switches displayed in CC as default, they dont dismiss Control Center when applying an action
	       	if ([NSClassFromString(@"SBControlCenterController") sharedInstance]) [(SBControlCenterController *)[NSClassFromString(@"SBControlCenterController") sharedInstance] dismissAnimated:YES];

	       	void (^action)() = ^() {
         		launchAppDirect(launchApp);
	        };
	        SBLockScreenViewControllerBase *controller = (SBLockScreenViewControllerBase *)[manager lockScreenViewController];

	        if (NSClassFromString(@"SBUnlockActionContext") != nil)
	        {
	        	SBUnlockActionContext *context = [[NSClassFromString(@"SBUnlockActionContext") alloc] initWithLockLabel:nil shortLockLabel:nil unlockAction:action identifier:nil];
	        	[context setDeactivateAwayController:YES];
	        	[controller setCustomUnlockActionContext:context]; 
	        }
	        else if (NSClassFromString(@"SBLockScreenActionContext") != nil) //8.0+
	        {
	        	SBLockScreenActionContext *context = [[NSClassFromString(@"SBLockScreenActionContext") alloc] initWithLockLabel:nil shortLockLabel:nil action:action identifier:nil];
	        	[context setDeactivateAwayController:YES];
	        	[controller setCustomLockScreenActionContext:context];
	        }

	        [controller setPasscodeLockVisible:YES animated:YES completion:nil];
	       	return;
    	}
	}
	launchAppDirect(launchApp);
}

static inline SBApplication *applicationForID(NSString *applicationID)
{
	SBApplicationController *controller = (SBApplicationController *)[NSClassFromString(@"SBApplicationController") sharedInstance];

	if ([[controller class] instancesRespondToSelector:@selector(applicationWithDisplayIdentifier:)]) return [controller applicationWithDisplayIdentifier:applicationID];

	return [controller applicationWithBundleIdentifier:applicationID];
}


#ifdef __cplusplus
extern "C" {
#endif

CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

#ifdef __cplusplus
}
#endif