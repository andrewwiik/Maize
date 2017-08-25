#import <SpringBoard/SBAppSwitcherController.h>
#import <SpringBoard/SBUIController.h>
#import <SpringBoard/SBApplication.h>


@interface SBUIController (Private)
+ (instancetype)sharedInstance;
- (void)activateApplicationFromSwitcher:(SBApplication *)application;
- (void)_dismissSwitcherAnimated:(BOOL)animated;
- (void)dismissSwitcherAnimated:(BOOL)animated;
- (void)getRidOfAppSwitcher;
- (void)_dismissAppSwitcherImmediately;
- (BOOL)isAppSwitcherShowing;

//iOS 7
- (void)activateApplicationAnimated:(SBApplication *)application;
- (SBAppSwitcherController *)_appSwitcherController;

// iOS 10
- (void)activateApplication:(SBApplication *)application;
@end