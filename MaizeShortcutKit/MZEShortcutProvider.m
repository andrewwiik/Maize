#import "MZEShortcutProvider.h"
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoardUI/SBUIAction.h>
#import <SpringBoard/SBApplication+Private.h>
#import <SpringBoardUI/SBUIAppIconForceTouchController.h>
#import <SpringBoardUI/SBUIForceTouchGestureRecognizer.h>
#import <SpringBoardUI/SBUIAppIconForceTouchShortcutViewController.h>
#import <SpringBoardUI/SBUIAppIconForceTouchControllerDataProvider.h>
#import <SpringBoardUI/SBUIAppIconForceTouchControllerDelegate-Protocol.h>
#import <SpringBoardServices/SBSApplicationShortcutItem.h>
#import <SpringBoardServices/SBSApplicationShortcutTemplateIcon.h>
#import <SpringBoardServices/SBSApplicationShortcutCustomImageIcon.h>
#import <UIKit/UIImage+Private.h>


@implementation MZEShortcutProvider

+ (instancetype)sharedInstance {
	static MZEShortcutProvider *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MZEShortcutProvider alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
	self = [super init];
	if (self) {
		_iconController = [NSClassFromString(@"SBIconController") sharedInstance];
	}
	return self;
}


- (NSArray<MZEShortcutItem *> *)shortcutsForBundleIdentifier:(NSString *)bundleIdentifier {


	NSMutableArray<MZEShortcutItem *> *shortcutItems = [NSMutableArray new];
	if (bundleIdentifier) {
		if ([bundleIdentifier length] > 0) {
			if (NSClassFromString(@"SBUIAppIconForceTouchController")) {
				SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleIdentifier];

				SBUIForceTouchGestureRecognizer *gestureRecognizer = [[NSClassFromString(@"SBUIForceTouchGestureRecognizer") alloc] initWithTarget:_iconController action:nil];
				gestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)_iconController;

				SBUIAppIconForceTouchController *iconForceTouchController = [[NSClassFromString(@"SBUIAppIconForceTouchController") alloc] init];
		    	[iconForceTouchController setDataSource:(id<SBUIAppIconForceTouchControllerDataSource>)_iconController];
		    	[iconForceTouchController setDelegate:(id<SBUIAppIconForceTouchControllerDelegate>)_iconController];
		    	[iconForceTouchController startHandlingGestureRecognizer:gestureRecognizer];

		    	NSArray *filteredShortcutItems = [NSClassFromString(@"SBUIAppIconForceTouchController") filteredApplicationShortcutItemsWithStaticApplicationShortcutItems:app.staticApplicationShortcutItems dynamicApplicationShortcutItems:app.dynamicApplicationShortcutItems];

		    	if(filteredShortcutItems.count < 1) {
		    		UINotificationFeedbackGenerator *feedback = [[UINotificationFeedbackGenerator alloc] init];
		            [feedback prepare];
		            [feedback notificationOccurred:UINotificationFeedbackTypeError];
		            feedback = nil;
		           // [touchController dismissAnimated:YES withCompletionHandler:nil];
		            return nil;
		    	}

		    	for(SBSApplicationShortcutItem *shortcut in filteredShortcutItems){

		    		if([shortcut.icon isKindOfClass:NSClassFromString(@"SBSApplicationShortcutTemplateIcon")]) {
		    			NSBundle *appBundle = [app bundle];
		    			NSBundle *bundle = [NSBundle bundleWithPath:[appBundle bundlePath]];
		    			NSString *templateName = [(SBSApplicationShortcutTemplateIcon *)shortcut.icon templateImageName];
		    			UIImage *shortcutIcon = [UIImage imageNamed:templateName inBundle:bundle];
		    			[shortcut setIcon:[[NSClassFromString(@"SBSApplicationShortcutCustomImageIcon") alloc] initWithImagePNGData:UIImagePNGRepresentation(shortcutIcon)]];
		    		}
		    		shortcut.bundleIdentifierToLaunch = bundleIdentifier;
		    	}

		    	SBUIAppIconForceTouchControllerDataProvider *dataProvider = [[NSClassFromString(@"SBUIAppIconForceTouchControllerDataProvider") alloc] initWithDataSource:_iconController controller:iconForceTouchController gestureRecognizer:gestureRecognizer];

		    	SBUIAppIconForceTouchController *ftController = [_iconController valueForKey:@"_appIconForceTouchController"];

		    	SBUIAppIconForceTouchShortcutViewController *shortcutController = [[NSClassFromString(@"SBUIAppIconForceTouchShortcutViewController") alloc] initWithDataProvider:dataProvider applicationShortcutItems:filteredShortcutItems];

		    	for(SBSApplicationShortcutItem *item in filteredShortcutItems) {
		    		SBUIAction *origAction = [shortcutController _actionFromApplicationShortcutItem:item];
		    		id newHandler = ^{
		    			//[touchController dismissAnimated:YES withCompletionHandler:nil];
		    			for(SBSApplicationShortcutItem *item in filteredShortcutItems) {
		    				if([item.localizedTitle isEqualToString:origAction.title]) {
		    					[ftController appIconForceTouchShortcutViewController:shortcutController activateApplicationShortcutItem:item];
		    					break;
		    				}
		    			}
		    		};

		    		MZEShortcutItem *newItem = [[MZEShortcutItem alloc] init];
		    		newItem.title = origAction.title;
		    		newItem.subtitle = origAction.subtitle;
		    		newItem.image = origAction.image;
		    		newItem.block = (MZEShortcutItemBlock)newHandler;

		    		[shortcutItems addObject:newItem];

		    		// SBUIAction *newAction = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:origAction.title subtitle:origAction.subtitle image:origAction.image handler:newHandler];
		    		// [actionsToDisplay addObject:newAction];
		    	}
			}
		}
	}

	return [shortcutItems copy];
}
@end