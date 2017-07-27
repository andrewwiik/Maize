#import "MZEFlipSwitchThemeBundle.h"
#import <FlipSwitch/FlipSwitch+NSBundle.h>
#import "MZELayoutOptions.h"

@implementation MZEFlipSwitchThemeBundle
- (NSBundle *)flipswitchThemedBundle {
	NSString *path = [[self pathForResource:@"Theme" ofType:@"plist"] stringByDeletingLastPathComponent];
	return (!path || [path isEqualToString:[self bundlePath]]) ? [MZEFlipSwitchThemeBundle bundleWithPath:[self bundlePath]] : [MZEFlipSwitchThemeBundle bundleWithPath:path];
}

- (NSDictionary *)flipswitchThemedInfoDictionary
{
	NSDictionary *dict = [super flipswitchThemedInfoDictionary];
	NSMutableDictionary *modified = [dict mutableCopy];
	[modified setObject:[NSNumber numberWithFloat:[MZELayoutOptions edgeSize]] forKey:@"width"];
	[modified setObject:[NSNumber numberWithFloat:[MZELayoutOptions edgeSize]] forKey:@"height"];

	CGFloat glyphSize = [MZELayoutOptions flipSwitchGlyphSize];
	CGPoint glyphOrigin = [MZELayoutOptions flipSwitchGlyphOrigin];

	NSArray *layers = @[
		@{
			@"variant": @"modern",
			@"type": @"glyph",
			@"size": @(glyphSize),
			@"x": @(glyphOrigin.x),
			@"y": @(glyphOrigin.y),
			@"opacity": @(1.0),
			@"color": @"#000000",
			@"state": @"indeterminate"
		}
	];
	
	[modified setObject:layers forKey:@"layers"];

	return [modified copy];
}
@end