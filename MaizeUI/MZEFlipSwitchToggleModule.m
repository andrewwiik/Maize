#import "MZEFlipSwitchToggleModule.h"
#import <UIKit/UIColor+Private.h>
#import <Flipswitch/FSSwitchPanel.h>
#import <FlipSwitch/FSSwitchPanel+Private.h>

@interface NSBundle (MZE)
@property (nonatomic, assign) BOOL isMZEFlipSwitchThemeBundle;
+ (instancetype)mze_bundleWithPath:(id)path;
@end

@implementation MZEFlipSwitchToggleModule
+ (NSBundle *)sharedTemplateBundle {
	static NSBundle *_sharedTemplateBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,  ^{
    	_sharedTemplateBundle = [NSBundle bundleForClass:[self class]];
    });
    return _sharedTemplateBundle;
}


- (id)initWithSwitchIdentifier:(NSString *)switcherIdentifier {
	self = [super init];
	if (self) {
		_switchIdentifier = switcherIdentifier;
		_templateBundle = [MZEFlipSwitchToggleModule sharedTemplateBundle];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchStateDidChange:) name:FSSwitchPanelSwitchStateChangedNotification object:nil];
		_currentState = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] stateForSwitchIdentifier:_switchIdentifier];
		_isEnabled = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] switchWithIdentifierIsEnabled:_switchIdentifier];
	}
	return self;
}

- (BOOL)isReversed {
	return NO;
}

- (UIColor *)selectedColor {
	UIColor *color = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] primaryColorForSwitchIdentifier:_switchIdentifier];
	if (color == nil || color == [UIColor whiteColor]) {
		color = [UIColor systemBlueColor];
	}
	return color;
	//return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] primaryColorForSwitchIdentifier:_switchIdentifier];
}

- (UIImage *)iconGlyph {
	if (!_cachedIconImage) {
		_cachedIconImage = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] imageOfSwitchState:[self isReversed] ? FSSwitchStateOn : FSSwitchStateOff controlState:UIControlStateNormal forSwitchIdentifier:_switchIdentifier usingTemplate:_templateBundle];
	}
	return _cachedIconImage;
}

- (UIImage *)selectedIconGlyph {
	if (!_cachedSelectedIconImage) {
		_cachedSelectedIconImage = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] imageOfSwitchState:[self isReversed] ? FSSwitchStateOff : FSSwitchStateOn controlState:UIControlStateNormal forSwitchIdentifier:_switchIdentifier usingTemplate:_templateBundle];
	}
	return _cachedSelectedIconImage;
}

- (CAPackage *)glyphPackage {
	return nil;
}

- (NSString *)glyphState {
	return nil;
}

- (BOOL)isSelected {
	if ([[NSClassFromString(@"FSSwitchPanel") sharedPanel] switchWithIdentifierIsSimpleAction:_switchIdentifier]) {
		return NO;
	} else {
		if ([self isReversed]) {
			switch (_currentState) {
				case FSSwitchStateOff:
					return YES;
				case FSSwitchStateOn:
					return NO;
				default:
					return NO;
			}
		} else {
				switch (_currentState) {
				case FSSwitchStateOff:
					return NO;
				case FSSwitchStateOn:
					return YES;
				default:
					return NO;
			}
		}
	}
	//return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] ;
}

- (void)setSelected:(BOOL)isSelected {
	BOOL isReversed = [self isReversed];
	[[NSClassFromString(@"FSSwitchPanel") sharedPanel] setState:isSelected ? (isReversed ? FSSwitchStateOff : FSSwitchStateOn) : (isReversed ? FSSwitchStateOn : FSSwitchStateOff) forSwitchIdentifier:_switchIdentifier];
	if ([[NSClassFromString(@"FSSwitchPanel") sharedPanel] switchWithIdentifierIsSimpleAction:_switchIdentifier]) {
		[_viewController setSelected:NO];
	} else {
		[_viewController setSelected:isSelected];
	}
	[super setSelected:isSelected];
}

- (void)switchStateDidChange:(NSNotification *)notification
{
	NSString *changedIdentifier = [notification.userInfo objectForKey:FSSwitchPanelSwitchIdentifierKey];
	if ([changedIdentifier isEqual:_switchIdentifier] || !changedIdentifier) {
		_isEnabled = [[FSSwitchPanel sharedPanel] switchWithIdentifierIsEnabled:_switchIdentifier];
		if ([[NSClassFromString(@"FSSwitchPanel") sharedPanel] switchWithIdentifierIsSimpleAction:_switchIdentifier]) {
			_currentState = FSSwitchStateOff;
		} else {
			_currentState = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] stateForSwitchIdentifier:_switchIdentifier];
		}
		//self.enabled = [[FSSwitchPanel sharedPanel] switchWithIdentifierIsEnabled:switchIdentifier];
		[self refreshState];
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.switchIdentifier = nil;
	self.cachedIconImage = nil;
	self.cachedSelectedIconImage = nil;
	self.templateBundle = nil;
}

- (BOOL)isEnabled {
	return _isEnabled;
}
@end
