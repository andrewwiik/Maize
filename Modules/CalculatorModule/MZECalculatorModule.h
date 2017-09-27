#import <MaizeUI/MZEAppLauncherModule.h>

@interface MZECalculatorModule : MZEAppLauncherModule {
	NSBundle *_moduleBundle;
	UIImage *_cachedIconGlyph;
}
- (id)init;
- (NSString *)applicationIdentifier;
- (UIImage *)iconGlyph;
@end