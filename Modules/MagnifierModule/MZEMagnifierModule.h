#import <MaizeUI/MZEAppLauncherModule.h>

@interface MZEMagnifierModule : MZEAppLauncherModule {
	NSBundle *_moduleBundle;
	UIImage *_cachedIconGlyph;
}
- (id)init;
- (NSString *)applicationIdentifier;
- (UIImage *)iconGlyph;
@end