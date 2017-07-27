#import "MZEFlipSwitchToggleModule.h"
#import <FlipSwitch/FSSwitchPanel.h>
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
    	if ([NSBundle respondsToSelector:@selector(mze_bundleWithPath:)]) {
        	_sharedTemplateBundle = [NSBundle mze_bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"MZEFlipSwitchToggleModule")] bundlePath]];
    	} else {
    		_sharedTemplateBundle = [NSBundle bundleForClass:NSClassFromString(@"MZEFlipSwitchToggleModule")];
    	}
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

- (UIColor *)selectedColor {
	return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] primaryColorForSwitchIdentifier:_switchIdentifier];
}

- (UIImage *)iconGlyph {
	if (!_cachedIconImage) {
		_cachedIconImage = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] imageOfSwitchState:FSSwitchStateOff controlState:UIControlStateNormal forSwitchIdentifier:_switchIdentifier usingTemplate:_templateBundle];
	}
	return _cachedIconImage;
}

- (UIImage *)selectedIconGlyph {
	if (!_cachedSelectedIconImage) {
		_cachedSelectedIconImage = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] imageOfSwitchState:FSSwitchStateOn controlState:UIControlStateNormal forSwitchIdentifier:_switchIdentifier usingTemplate:_templateBundle];
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
	switch (_currentState) {
		case FSSwitchStateOff:
			return NO;
		case FSSwitchStateOn:
			return YES;
		default:
			return NO;
	}
	//return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] ;
}

- (void)setSelected:(BOOL)isSelected {
	[[NSClassFromString(@"FSSwitchPanel") sharedPanel] setState:isSelected ? FSSwitchStateOn : FSSwitchStateOff forSwitchIdentifier:_switchIdentifier];
	[_viewController setSelected:isSelected];
	[super setSelected:isSelected];
	return;
}

- (void)switchStateDidChange:(NSNotification *)notification
{
	NSString *changedIdentifier = [notification.userInfo objectForKey:FSSwitchPanelSwitchIdentifierKey];
	if ([changedIdentifier isEqual:_switchIdentifier] || !changedIdentifier) {
		_isEnabled = [[FSSwitchPanel sharedPanel] switchWithIdentifierIsEnabled:_switchIdentifier];
		_currentState = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] stateForSwitchIdentifier:_switchIdentifier];
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