#import "MZEConnectivityAirDropViewController.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <UIKit/UIColor+Private.h>
#import <UIKit/UIImage+Private.h>


/*

Discovery Mode:
	2 - Everyone
	1 - Contacts Only
	0 - Recieving Off
*/


@implementation MZEConnectivityAirDropViewController

- (id)init {
	if (!NSClassFromString(@"SFAirDropDiscoveryController")) {
		dlopen("/System/Library/PrivateFrameworks/Sharing.framework/Sharing", RTLD_NOW);
	}

	if (NSClassFromString(@"SFAirDropDiscoveryController")) {
		UIImage *glyphImage = [UIImage imageNamed:@"AirDropGlyph" inBundle:[NSBundle bundleForClass:[self class]]];
		UIColor *highlightColor = [UIColor systemBlueColor];
		self = [super initWithGlyphImage:glyphImage highlightColor:highlightColor];

		if (self) {
			_bundle = [NSBundle bundleForClass:[self class]];
			_airDropDiscoveryController = [[NSClassFromString(@"SFAirDropDiscoveryController") alloc] init];
			_airDropDiscoveryController.delegate = self;
		}
		return self;
	}

	return nil;
}


- (MZEConnectivityAirDropPopupViewController *)airdropPopupController {
	MZEConnectivityAirDropPopupViewController *controller = [[MZEConnectivityAirDropPopupViewController alloc] initWithDiscoveryController:_airDropDiscoveryController];
	// controller.title = [self displayName];

	// [controller addActionWithTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_EVERYONE_ONE_LINE" value:@"" table:nil] glyph:nil handler:(MZEMenuItemBlock)^{
	// 	[_airDropDiscoveryController setDiscoverableMode:2];
	// 	return YES;
	// }];

	// [controller addActionWithTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_CONTACTS_ONE_LINE" value:@"" table:nil] glyph:nil handler:(MZEMenuItemBlock)^{
	// 	[_airDropDiscoveryController setDiscoverableMode:1];
	// 	return YES;
	// }];

	// [controller addActionWithTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_RECEIVING_OFF_ONE_LINE" value:@"" table:nil] glyph:nil handler:(MZEMenuItemBlock)^{
	// 	[_airDropDiscoveryController setDiscoverableMode:0];
	// 	return YES;
	// }];

	return controller;
}


- (NSInteger)_currentState {
	return [_airDropDiscoveryController discoverableMode];
}

- (void)_updateState {
	int state = [self _currentState];
	[self setEnabled:[self _enabledForState:state]];
	[self setSubtitle:[self subtitleText]];
}

- (BOOL)_enabledForState:(int)state {
	if (state > 0) {
		return YES;
	} else return NO;
}


- (NSString *)subtitleText {
	int state = [self _currentState];

	if (state == 2) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_EVERYONE_ONE_LINE" value:@"" table:nil];
	} else if (state == 1) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_CONTACTS_ONE_LINE" value:@"" table:nil];
	} else {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_RECEIVING_OFF_ONE_LINE" value:@"" table:nil];
	}
}

- (NSString *)displayName {
	return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_AIRDROP_NAME" value:@"Airdrop" table:nil];
}

-(void)discoveryControllerVisibilityDidChange:(id)arg1 {
	[self _updateState];
}

-(void)discoveryControllerSettingsDidChange:(id)arg1 {
	[self _updateState];
}

- (void)buttonTapped:(UIControl *)button {
	// [self _toggleState];
	// [super buttonTapped:button];

	
	MZEConnectivityAirDropPopupViewController *popupController = [[MZEConnectivityAirDropPopupViewController alloc] initWithDiscoveryController:_airDropDiscoveryController];
	popupController.buttonController = self;
	[self.buttonDelegate buttonViewController:self willPresentSecondaryViewController:popupController];
	[self presentViewController:popupController animated:true completion:nil];
}


@end