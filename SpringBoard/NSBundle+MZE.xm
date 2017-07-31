
// #import <MaizeUI/MZELayoutOptions.h>
// #import <FlipSwitch/FlipSwitch+NSBundle.h>

// static NSMutableDictionary *mze_templateDict;
// static NSString *sizeStuff;

// @interface NSBundle (MZE)
// @property (nonatomic, assign) BOOL isMZEFlipSwitchThemeBundle;
// + (instancetype)mze_bundleWithPath:(id)path;
// @end

// %hook NSBundle
// %property (nonatomic, assign) BOOL isMZEFlipSwitchThemeBundle;

// %new
// + (NSBundle *)mze_bundleWithPath:(id)path  {
// 	NSBundle *bundle = [NSBundle bundleWithPath:path];
// 	if (bundle) {
// 		if ([bundle respondsToSelector:@selector(setIsMZEFlipSwitchThemeBundle:)]) {
// 			bundle.isMZEFlipSwitchThemeBundle = YES;
// 		}
// 	}
// 	return bundle;
// }

// - (NSBundle *)flipswitchThemedBundle {
// 	NSBundle *orig = %orig;
// 	if (orig) {
// 		if (self.isMZEFlipSwitchThemeBundle) {
// 			orig.isMZEFlipSwitchThemeBundle = self.isMZEFlipSwitchThemeBundle;
// 		}
// 	}
// 	return orig;

// }

// - (NSMutableDictionary *)flipswitchThemedInfoDictionary
// {
// 	if (self.isMZEFlipSwitchThemeBundle) {
// 		if (mze_templateDict) {
// 			return mze_templateDict;
// 		}
// 		NSMutableDictionary *dict = %orig;
// 		HBLogInfo(@"MZEORIGDICT: %@", dict);
// 		if (dict) {
// 			//return dict;

// 			//BOOL needsNonMutable = NO;
// 			NSMutableDictionary *modified;
// 			//if ([dict isKindOfClass:[NSMutableDictionary class]]) {
// 				modified = (NSMutableDictionary *)dict;
// 			// } else {
// 			// 	needsNonMutable = YES;
// 			// 	modified = [dict mutableCopy];
// 			// }
// 			// HBLogInfo(@"MZEDICT: %@", modified);
// 			// if ([modified isKindOfClass:NSClassFromString(@"NSMutableDictionary")]) {
// 			// 	HBLogInfo(@"MZEDICT: %@", modified);
// 			// 	NSNumber *width = [NSNumber numberWithFloat:[MZELayoutOptions edgeSize]];
// 			// 	NSNumber *height = [NSNumber numberWithFloat:[MZELayoutOptions edgeSize]];
// 			// 	if (width) {
// 			// 		HBLogInfo(@"GOT INTO WIDTH");
// 			// 		if ([modified objectForKey:@"width"]) {
// 			// 			[modified removeObjectForKey:@"width"];
// 			// 		}
// 			// 		HBLogInfo(@"WMODDICT: %@", modified);
// 			// 		[modified setObject:@([MZELayoutOptions edgeSize]) forKey:@"width"];
// 			// 		HBLogInfo(@"WMODDICT2: %@", modified);
// 			// 	}
// 			// 	if (height) {
// 			// 		HBLogInfo(@"GOT INTO HEGIHT");
// 			// 		if ([modified objectForKey:@"height"]) {
// 			// 			[modified removeObjectForKey:@"height"];
// 			// 		}
// 			// 		HBLogInfo(@"HMODDICT: %@", modified);
// 			// 		[modified setObject:@([MZELayoutOptions edgeSize]) forKey:@"height"];
// 			// 		HBLogInfo(@"HMODDICT2: %@", modified);
// 			// 	}
// 			// }


// 			// [modified setObject:[NSNumber numberWithFloat:[MZELayoutOptions edgeSize]] forKey:@"width"];
// 			// [modified setObject:[NSNumber numberWithFloat:[MZELayoutOptions edgeSize]] forKey:@"height"];

// 			CGFloat glyphSize = [MZELayoutOptions flipSwitchGlyphSize];
// 			CGPoint glyphOrigin = [MZELayoutOptions flipSwitchGlyphOrigin];
// 			CGFloat moduleSize = [MZELayoutOptions edgeSize];

// 			NSString *sizeString = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:moduleSize]];
// 			sizeStuff = sizeString;

// 			NSArray *layers = @[
// 				@{
// 					@"variant": @"modern",
// 					@"type": @"glyph",
// 					@"size": @(glyphSize),
// 					@"x": @(glyphOrigin.x),
// 					@"y": @(glyphOrigin.y),
// 					@"opacity": @(1.0),
// 					@"color": @"#000000",
// 					@"state": @"indeterminate"
// 				}
// 			];

// 			[modified setObject:sizeString forKey:@"width"];
// 			[modified setObject:sizeString forKey:@"height"];
// 			//[modified setObject:@(moduleSize) forKey:@"height"];

// 			[modified setObject:layers forKey:@"layers"];
// 			// if (needsNonMutable){
// 			// 	HBLogInfo(@"FDICT: %@", modified);
// 			// 	NSDictionary *final = [modified copy];
// 			// 	HBLogInfo(@"FSDICT: %@", final);
// 			// 	return final;
// 			// }

// 			HBLogInfo(@"MUTDICT: %@", modified);
// 			mze_templateDict = modified;
// 			return modified;
// 		} else return dict;
// 	} else return %orig;
// }

// %end

// %ctor {
// 	dlopen("/usr/lib/libflipswitch.dylib", RTLD_NOW);
// 	%init;
// }