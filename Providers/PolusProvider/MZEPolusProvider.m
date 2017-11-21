#import "MZEPolusProvider.h"
#import <FlipSwitch/FSSwitchPanel+Private.h>
#import <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <AppList/ALApplicationList.h>
#import "MZEPolusAppLauncherModule.h"
#import "MZEPolusActionLauncherModule.h"
// #import <Polus/PLPrefsHelper.h>
// #import <Polus/PLAppsController.h>

extern NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);

static inline NSString *eventNameFromAppID(NSString *applicationID)
{
	return [NSString stringWithFormat:@"%@-%@", EVENT_PREFIX, applicationID];
}

static inline NSString *heldEventNameFromAppID(NSString *applicationID)
{
	return [NSString stringWithFormat:@"%@-%@", HELD_EVENT_PREFIX, applicationID];
}

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

// PLAppsController *prefsController;

// self.prefsController = [NSClassFromString(@"PLAppsController") sharedInstance];
//self.enabledIdentifiers = [(PLAppsController *)self.prefsController visibleAppsForViewMode:self.viewMode];

static BOOL hasAttemptedToLoadPolus = NO;
NSArray *idsToIgnore = nil;
@implementation MZEPolusProvider

// PLAppsController *prefsController;

+ (NSArray<NSString *> *)possibleIdentifiers {

	if (!idsToIgnore) {
		idsToIgnore = @[@"com.apple.camera", 
								 @"com.apple.calculator", 
								 @"com.apple.mobiletimer"];
	}

	if (!hasAttemptedToLoadPolus) {
		dlopen("/usr/lib/libpolus.dylib", RTLD_NOW);
		hasAttemptedToLoadPolus = YES;
	}
	if (!NSClassFromString(@"PLAppsController")) {
		return [NSArray new];
	} else {
		NSArray *visibleAppsTop = [(PLAppsController *)[NSClassFromString(@"PLAppsController") sharedInstance] visibleAppsForViewMode:PLViewModeTopShelf];
		NSArray *hiddenAppsTop = [(PLAppsController *)[NSClassFromString(@"PLAppsController") sharedInstance] hiddenAppsForViewMode:PLViewModeTopShelf];
		NSArray *visibleAppsBottom = [(PLAppsController *)[NSClassFromString(@"PLAppsController") sharedInstance] visibleAppsForViewMode:PLViewModeBottomShelf];
		NSArray *hiddenAppsBottom = [(PLAppsController *)[NSClassFromString(@"PLAppsController") sharedInstance] hiddenAppsForViewMode:PLViewModeBottomShelf];
		NSArray *allTop = [visibleAppsTop arrayByAddingObjectsFromArray:hiddenAppsTop];
		NSArray *allBottom = [visibleAppsBottom arrayByAddingObjectsFromArray:hiddenAppsBottom];
		NSArray *all = [allTop arrayByAddingObjectsFromArray:allBottom];
		NSMutableArray *filtered = [NSMutableArray new];
		for (NSString *identifier in all) {
			if (![identifier hasPrefix:FS_PREFIX]) {
				[filtered addObject:identifier];
			}
		}

		NSMutableArray *allIdentifiers = [[[NSSet setWithArray:[filtered copy]] allObjects] mutableCopy];

		for (NSString *identifier in idsToIgnore) {
			[allIdentifiers removeObject:identifier];
		}

		return [allIdentifiers copy];
		//return [[[NSSet setWithArray:[filtered copy]] allObjects] copy];
		//return [visibleApps arrayByAddingObjectsFromArray:hiddenApps];
	}
	//return [(PLAppsController *)[NSClassFromString(@"PLAppsController") sharedInstance] visibleAppsForViewMode:PLViewModeTopShelf];
	//return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] sortedSwitchIdentifiers];
}

+ (id<MZEContentModule>)moduleForIdentifier:(NSString *)identifier {
	if (![identifier hasPrefix:ACTION_PREFIX]) {
		return [[MZEPolusAppLauncherModule alloc] initWithIdentifier:identifier];
	} else {
		return [[MZEPolusActionLauncherModule alloc] initWithIdentifier:identifier];
	}
	return nil;
}

+ (UIImage *)glyphForIdentifier:(NSString *)identifier {
	return [[[NSClassFromString(@"PLAppsController") sharedInstance] glyphOfSize:PLGlyphSizeSmall forAppIdentifier:identifier withViewMode:PLViewModeTopShelf] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIColor *)glyphBackgroundColorForIdentifier:(NSString *)identifier {
	//FSSwitchPanel *panel = (FSSwitchPanel *)[NSClassFromString(@"FSSwitchPanel") sharedPanel];
	return [UIColor grayColor];
	//return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] primaryColorForSwitchIdentifier:identifier] ? [[NSClassFromString(@"FSSwitchPanel") sharedPanel] primaryColorForSwitchIdentifier:identifier] : [UIColor grayColor];;
}

+ (NSString *)displayNameForIdentifier:(NSString *)identifier {

	if ([identifier hasPrefix:ACTION_PREFIX]) {
		return nameForActionButton(identifier, NO);
	} else {
		return SBSCopyLocalizedApplicationNameForDisplayIdentifier(identifier);
	}
	return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] titleForSwitchIdentifier:identifier];
}

+ (NSInteger)rowsForIdentifier:(NSString *)identifier {
	return 1;
}

+ (NSInteger)columnsForIdentifier:(NSString *)identifier {
	return 1;
}
@end