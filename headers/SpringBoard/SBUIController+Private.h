#import <SpringBoard/SBAppSwitcherController.h>
#import <SpringBoard/SBUIController.h>


@interface SBUIController (Private)
+ (instancetype)sharedInstance;
- (void)activateApplicationFromSwitcher:(id)application;
- (void)_dismissSwitcherAnimated:(BOOL)arg1;
- (void)dismissSwitcherAnimated:(BOOL)animated;
- (void)getRidOfAppSwitcher;
- (void)_dismissAppSwitcherImmediately;
- (BOOL)isAppSwitcherShowing;

//iOS 7
- (void)activateApplicationAnimated:(id)application;
- (SBAppSwitcherController *)_appSwitcherController;

// iOS 10
- (void)activateApplication:(id)arg1 ;
@end