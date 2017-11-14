#import "MZEPolusAppLauncherModule.h"

#import <Polus/PLPrefsHelper.h>
#import <Polus/PLAppsController.h>
#import <UIKit/UIImage+Private.h>

@implementation MZEPolusAppLauncherModule
- (id)initWithIdentifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		_identifier = identifier;
	}
	return self;
}

- (NSString *)applicationIdentifier {
	return _identifier;
}

- (UIImage *)iconGlyph {
	if (!_cachedIconGlyph) {
		_cachedIconGlyph = [[[NSClassFromString(@"PLAppsController") sharedInstance] glyphOfSize:PLGlyphSizeNormal forAppIdentifier:_identifier withViewMode:PLViewModeBottomShelf] _flatImageWithColor:[UIColor whiteColor]];
	}
	return _cachedIconGlyph;
}
@end