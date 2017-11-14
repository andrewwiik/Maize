#import <MaizeUI/MZEAppLauncherModule.h>

@interface MZEPolusAppLauncherModule : MZEAppLauncherModule {
	NSString *_identifier;
	UIImage *_cachedIconGlyph;
}
- (id)initWithIdentifier:(NSString *)identifier;
@end