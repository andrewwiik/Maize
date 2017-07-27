#import "MZEToggleModule.h"
#import <FlipSwitch/FSSwitchState.h>

@interface MZEFlipSwitchToggleModule : MZEToggleModule {
	NSString *_switchIdentifier;
	UIImage *_cachedIconImage;
	UIImage *_cachedSelectedIconImage;
	NSBundle *_templateBundle;
	FSSwitchState _currentState;
	BOOL _isEnabled;
	//BOOL _isSupported;
}
@property (nonatomic, retain, readwrite) NSString *switchIdentifier;
@property (nonatomic, retain, readwrite) UIImage *cachedIconImage;
@property (nonatomic, retain, readwrite) UIImage *cachedSelectedIconImage;
@property (nonatomic, retain, readwrite) NSBundle *templateBundle;
- (id)initWithSwitchIdentifier:(NSString *)switchIdentifier;

+ (NSBundle *)sharedTemplateBundle;
@end