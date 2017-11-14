#import "MZEQuickNoteModule.h"
#import <UIKit/UIColor+Private.h>
#import <UIKit/UIImage+Private.h>

@implementation MZEQuickNoteModule

- (id)init {
	self = [super init];
	if (self) {
		_moduleBundle = [NSBundle bundleForClass:[self class]];
	}
	return self;
}

- (UIImage *)iconGlyph {
	if (!_cachedIconGlyph) {
		_cachedIconGlyph = [[UIImage imageNamed:@"AppIcon" inBundle:_moduleBundle] _flatImageWithColor:[UIColor whiteColor]];
	}
	return _cachedIconGlyph;
}

- (NSString *)applicationIdentifier {
	return @"com.apple.mobilenotes";
}
@end