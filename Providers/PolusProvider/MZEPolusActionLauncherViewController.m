#import "MZEPolusActionLauncherViewController.h"
#import <Activator/Activator+Private.h>
#import <Polus/PLPrefsHelper.h>
#import <Polus/PLAppsController.h>
#import "MZEPolusActionLauncherModule.h"
// #import <libactivator/libactivator.h>

typedef NS_ENUM(NSInteger, PLButtonAction) {
	PLButtonActionLaunch,
	PLButtonActionActivator
};

#define ACTIVE_PREFS_DICT [[NSClassFromString(@"PLPrefsHelper") sharedInstance] topShelfPrefs]
#define OTHER_ACTIVE_PREFS_DICT [[NSClassFromString(@"PLPrefsHelper") sharedInstance] bottomShelfPrefs]
#define DEFAULT_BUNDLE_ID @"com.a3tweaks.polus.defaultglyphs"

#define FLASH_ID @"com.a3tweaks.switch.flashlight"
#define FS_PREFIX @"fs-"
#define ACTION_PREFIX @"la-"

#define EVENT_PREFIX @"com.a3tweaks.polus"
#define HELD_EVENT_PREFIX @"com.a3tweaks.polus-held"

#define LASharedActivator ((LAActivator *)[NSClassFromString(@"LAActivator") sharedInstance])

static inline NSString *eventNameFromAppID(NSString *applicationID)
{
	return [NSString stringWithFormat:@"%@-%@", EVENT_PREFIX, applicationID];
}

static inline NSString *heldEventNameFromAppID(NSString *applicationID)
{
	return [NSString stringWithFormat:@"%@-%@", HELD_EVENT_PREFIX, applicationID];
}

#define MAIN_ACTION_INDEX (_isAction ? -2 : 0)
#define ACTIVATOR_INDEX (_isAction ? -1 : 1)
#define ACTIVATOR_ACTION_INDEX (_isAction ? 0 : 2)
#define DISMISS_INDEX (_isAction ? 1 : 3)

#define ICON_SECTION 0
#define TAP_SECTION 1
#define TAP_HOLD_SECTION 2

// static inline NSString*nameForActionButton(NSString *rawID, BOOL held)
// {
//     NSString *eventName = (!held ? eventNameFromAppID(rawID)  : heldEventNameFromAppID(rawID));

//     LAEvent *event = [NSCLLAEvent eventWithName:eventName mode:LASharedActivator.currentEventMode];
//     NSString *listenerName = [LASharedActivator assignedListenerNameForEvent:event];
//     if (listenerName != nil) return [LASharedActivator localizedTitleForListenerName:listenerName];
//     else
//     {
//         NSInteger buttonIndex = [[rawID stringByReplacingOccurrencesOfString:ACTION_PREFIX withString:@""] intValue];
//         buttonIndex++;
//         return [NSString stringWithFormat:@"%@ %li", Localize(@"CUSTOM_BUTTON"), (long)buttonIndex];
//     }
// }

static inline NSString *Localize(NSString *text)
{
	return [[NSClassFromString(@"PLPrefsHelper") sharedInstance] ownStringForKey:text];
}

static inline NSString*nameForActionButton(NSString *rawID, BOOL held)
{
	NSString *eventName = (!held ? eventNameFromAppID(rawID)  : heldEventNameFromAppID(rawID));

    LAEvent *event = [NSClassFromString(@"LAEvent") eventWithName:eventName mode:((LAActivator *)[NSClassFromString(@"LAActivator") sharedInstance]).currentEventMode];
    NSString *listenerName = [[NSClassFromString(@"LAActivator") sharedInstance] assignedListenerNameForEvent:event];
    if (listenerName != nil) return [[NSClassFromString(@"LAActivator") sharedInstance] localizedTitleForListenerName:listenerName];
    else
    {
    	NSInteger buttonIndex = [[rawID stringByReplacingOccurrencesOfString:ACTION_PREFIX withString:@""] intValue];
		buttonIndex++;
		return [NSString stringWithFormat:@"%@ %li", Localize(@"CUSTOM_BUTTON"), (long)buttonIndex];
    }
}

@interface SBAppSwitcherController (MZE)
- (void)forceDismissAnimated:(BOOL)animated;
@end

@implementation MZEPolusActionLauncherViewController
- (id)init {
	self = [super init];
	if (self) {

	}
	return self;
}

- (NSString *)applicationIdentifier {
	return [_module applicationIdentifier];
}


- (void)viewDidLoad {

	NSString *identifier = [_module applicationIdentifier];

	NSMutableDictionary *prefsDict = ACTIVE_PREFS_DICT;
	if (![[prefsDict objectForKey:@"activator_events_held"] containsObject:identifier]) {
		prefsDict = OTHER_ACTIVE_PREFS_DICT;
	}

	if ([[prefsDict objectForKey:@"activator_events_held"] containsObject:identifier]) {
		//__block NSString *identifier = [_module applicationIdentifier];
		__weak MZEPolusActionLauncherViewController *weakSelf = self;

		[self addActionWithTitle:nameForActionButton(identifier, YES) glyph:nil handler:(MZEMenuItemBlock)^{
			BOOL shouldClose = NO;
			NSString *identifier = [weakSelf applicationIdentifier];
		
			NSString *eventName =  (YES ? heldEventNameFromAppID(identifier) : eventNameFromAppID(identifier));
			
			LAEvent *event = [NSClassFromString(@"LAEvent") eventWithName:eventName mode:LASharedActivator.currentEventMode];
			if ([LASharedActivator assignedListenerNameForEvent:event]) [LASharedActivator sendEventToListener:event];

			NSString *prefsKey = [NSString stringWithFormat:@"WantsDismiss%@-%@", (YES ? @"-Held" : @""), identifier];

			//NSMutableDictionary *prefsDict = ACTIVE_PREFS_DICT;
			if ([[prefsDict objectForKey:prefsKey] boolValue])
			{
				shouldClose = YES;
				[(SBControlCenterController *)[NSClassFromString(@"SBControlCenterController") sharedInstance] dismissAnimated:YES];
				SBUIController *uiController = (SBUIController *)[NSClassFromString(@"SBUIController") sharedInstance];
				if ([uiController respondsToSelector:@selector(_appSwitcherController)]) [[uiController _appSwitcherController] forceDismissAnimated:YES];
			}
				
			return shouldClose;
		}];
		//[self applyAction:PLButtonActionActivator andButtonHeld:YES];
	}
	
	[super viewDidLoad];

	[self setGlyphImage:[_module iconGlyph]];
	[self setSelectedGlyphImage:[_module iconGlyph]];
	[self setSelectedGlyphColor:[UIColor whiteColor]];
	[self setGlyphPackage:nil];
	[self setEnabled:[_module isEnabled]];
	[self setAllowsHighlighting:YES];
	// NSString *identifier = [_module applicationIdentifier];

	// NSMutableDictionary *prefsDict = ACTIVE_PREFS_DICT;
	// if (![[prefsDict objectForKey:@"activator_events_held"] containsObject:identifier]) {
	// 	prefsDict = OTHER_ACTIVE_PREFS_DICT;
	// }

	// if ([[prefsDict objectForKey:@"activator_events_held"] containsObject:identifier]) {
	// 	//__block NSString *identifier = [_module applicationIdentifier];
	// 	__weak MZEPolusActionLauncherViewController *weakSelf = self;

	// 	[self addActionWithTitle:nameForActionButton(identifier, YES) glyph:nil handler:(MZEMenuItemBlock)^{
	// 		BOOL shouldClose = NO;
	// 		NSString *identifier = [weakSelf applicationIdentifier];
		
	// 		NSString *eventName =  (YES ? heldEventNameFromAppID(identifier) : eventNameFromAppID(identifier));
			
	// 		LAEvent *event = [NSClassFromString(@"LAEvent") eventWithName:eventName mode:LASharedActivator.currentEventMode];
	// 		if ([LASharedActivator assignedListenerNameForEvent:event]) [LASharedActivator sendEventToListener:event];

	// 		NSString *prefsKey = [NSString stringWithFormat:@"WantsDismiss%@-%@", (YES ? @"-Held" : @""), identifier];

	// 		//NSMutableDictionary *prefsDict = ACTIVE_PREFS_DICT;
	// 		if ([[prefsDict objectForKey:prefsKey] boolValue])
	// 		{
	// 			shouldClose = YES;
	// 			[(SBControlCenterController *)[NSClassFromString(@"SBControlCenterController") sharedInstance] dismissAnimated:YES];
	// 			SBUIController *uiController = (SBUIController *)[NSClassFromString(@"SBUIController") sharedInstance];
	// 			if ([uiController respondsToSelector:@selector(_appSwitcherController)]) [[uiController _appSwitcherController] forceDismissAnimated:YES];
	// 		}

	// 		return shouldClose;
	// 	}];
	// 	//[self applyAction:PLButtonActionActivator andButtonHeld:YES];
	// }
	//[self refreshState];
}

- (void)applyAction:(PLButtonAction)action andButtonHeld:(BOOL)wasHeld
{
	//if (action == PLButtonActionLaunch) [self launchApp];
	if (action == PLButtonActionActivator)
	{
		NSString *eventName =  (wasHeld ? heldEventNameFromAppID([_module applicationIdentifier]) : eventNameFromAppID([_module applicationIdentifier]));
		[self performActivatorActionWithEventName:eventName];

		NSString *prefsKey = [NSString stringWithFormat:@"WantsDismiss%@-%@", (wasHeld ? @"-Held" : @""), [_module applicationIdentifier]];

		NSMutableDictionary *prefsDict = ACTIVE_PREFS_DICT;
		if ([[prefsDict objectForKey:prefsKey] boolValue])
		{
			[(SBControlCenterController *)[NSClassFromString(@"SBControlCenterController") sharedInstance] dismissAnimated:YES];
			SBUIController *uiController = (SBUIController *)[NSClassFromString(@"SBUIController") sharedInstance];
			if ([uiController respondsToSelector:@selector(_appSwitcherController)]) [[uiController _appSwitcherController] forceDismissAnimated:YES];
		}
	}
}

- (void)performActivatorActionWithEventName:(NSString *)eventName
{
	LAEvent *event = [NSClassFromString(@"LAEvent") eventWithName:eventName mode:LASharedActivator.currentEventMode];

	if ([LASharedActivator assignedListenerNameForEvent:event]) [LASharedActivator sendEventToListener:event];
	//[self setSelected:NO];
}


- (void)buttonTapped:(UIControl *)button forEvent:(id)event {
	if (_module) {
		if ([_module applicationIdentifier]) {

			NSMutableDictionary *prefsDict = ACTIVE_PREFS_DICT;
			if ([[prefsDict objectForKey:@"activator_events"] containsObject:[_module applicationIdentifier]]) [self applyAction:PLButtonActionActivator andButtonHeld:NO];
			else {
				NSMutableDictionary *prefsDict = OTHER_ACTIVE_PREFS_DICT;
				if ([[prefsDict objectForKey:@"activator_events"] containsObject:[_module applicationIdentifier]]) [self applyAction:PLButtonActionActivator andButtonHeld:NO]; 
			} 
		// 	if ([[_module applicationIdentifier] length] > 0) {
		// 		if (NSClassFromString(@"SBApplication")) {
		// 			SBApplication *app = applicationForID([_module applicationIdentifier]);
		// 			if (app) {
		// 				launchApplication(app);
		// 			}
		// 		}
		// 	}
		// }
		}
	}
	//HBLogInfo(@"THE BUTTON WAS TAPPED");
	// BOOL isSelected = [_module isSelected] ? NO : YES;
	// if ([_module shouldSelfSelect])
	// 	[self setSelected:isSelected];
	// [_module setSelected:isSelected];
	[super buttonTapped:button forEvent:event];
}

// - (BOOL)shouldBeginTransitionToExpandedContentModule {
// 	return NO;
// }
@end