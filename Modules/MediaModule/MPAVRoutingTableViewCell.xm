
#import "MPAVRoutingTableViewCell+MZE.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>

%hook MPAVRoutingTableViewCell
%property (nonatomic, assign) BOOL mze_isMZECell;

-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 {
	MPAVRoutingTableViewCell *orig = %orig;
	if ([orig valueForKey:@"_iconImageView"]) {
		UIImageView *iconImageView = (UIImageView *)[orig valueForKey:@"_iconImageView"];
		iconImageView.tintColor = [UIColor whiteColor];
	}
	return orig;
}

-(void)layoutSubviews {
	// %orig;

	if ([self valueForKey:@"_iconImageView"]) {
		UIImageView *iconImageView = (UIImageView *)[self valueForKey:@"_iconImageView"];
		iconImageView.tintColor = [UIColor whiteColor];
	}

	%orig;

	if (self.mze_isMZECell) {
		if ([self valueForKey:@"_iconImageView"]) {
			UIImageView *iconImageView = (UIImageView *)[self valueForKey:@"_iconImageView"];
			iconImageView.tintColor = [UIColor whiteColor];
			if (iconImageView.image) {
				iconImageView.image = [iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
		}

		if ([self valueForKey:@"_routeNameLabel"]) {
			UILabel *routeNameLabel = (UILabel *)[self valueForKey:@"_routeNameLabel"];
			routeNameLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
		}

		if ([self valueForKey:@"_subtitleTextLabel"]) {
			UILabel *subtitletextLabel = (UILabel *)[self valueForKey:@"_subtitleTextLabel"];
			subtitletextLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
			subtitletextLabel.alpha = 0.7;
		}

		// if (!self.layer.filters || [self.layer.filters count] == 0) {
		// 	CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantDark"];
		// 	// // [filter setValue:(id)[[UIColor colorWithWhite:0.3 alpha:0.6] CGColor] forKey:@"inputColor0"];
		// 	// // [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.15] CGColor] forKey:@"inputColor1"];
		// 	// // [filter setValue:(id)[[UIColor colorWithWhite:0.45 alpha:0.7] CGColor] forKey:@"inputColor0"];
		// 	// // [filter setValue:(id)[[UIColor colorWithWhite:0.65 alpha:0.3] CGColor] forKey:@"inputColor1"];
		// 	// [filter setValue:(id)[[UIColor colorWithWhite:0.4 alpha:0.6] CGColor] forKey:@"inputColor0"];
		// 	// [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor] forKey:@"inputColor1"];
		// 	// [filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
		// 	[filter setValue:(id)[[UIColor colorWithWhite:0.8 alpha:0.7] CGColor] forKey:@"inputColor0"];
		// 	[filter setValue:(id)[[UIColor colorWithWhite:0.65 alpha:0.3] CGColor] forKey:@"inputColor1"];
		// 	[filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
		// 	// CAFilter *filter2 = [NSClassFromString(@"CAFilter") filterWithType:@"colorBrightness"];
		// 	// [filter2 setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputAmount"];

		// 	self.layer.filters = [NSArray arrayWithObjects:filter, nil];
		// }
		//self.layer.filters = stuff;
		//self.backgroundColor = [UIColor greenColor];

		// if ([self valueForKey:@"_routeNameLabel"]) {
		// 	UILabel *routeNameLabel = (UILabel *)[self valueForKey:@"_routeNameLabel"];
		// 	routeNameLabel.alpha = 0.2;
		// 	routeNameLabel.textColor = [UIColor whiteColor];
		// }
	}
}

-(id)_iconImageForRoute:(id)arg1 {
	if (self.mze_isMZECell) {
		UIImage *current = %orig;
		current = [current imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

		if ([self valueForKey:@"_iconImageView"]) {
			UIImageView *iconImageView = (UIImageView *)[self valueForKey:@"_iconImageView"];
			iconImageView.tintColor = [UIColor whiteColor];
		}
		return current;
	} else {
		return %orig;
	}

}

- (void)setRoute:(id)route {
	%orig;
	if ([self valueForKey:@"_iconImageView"]) {
		UIImageView *iconImageView = (UIImageView *)[self valueForKey:@"_iconImageView"];
		iconImageView.tintColor = [UIColor whiteColor];
	}

	if (self.mze_isMZECell) {
		if ([self valueForKey:@"_routeNameLabel"]) {
			UILabel *routeNameLabel = (UILabel *)[self valueForKey:@"_routeNameLabel"];
			routeNameLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
		}

		if ([self valueForKey:@"_subtitleTextLabel"]) {
			UILabel *subtitletextLabel = (UILabel *)[self valueForKey:@"_subtitleTextLabel"];
			subtitletextLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
			subtitletextLabel.alpha = 0.7;
		}

		if ([self valueForKey:@"_iconImageView"]) {
			UIImageView *iconImageView = (UIImageView *)[self valueForKey:@"_iconImageView"];
			iconImageView.tintColor = [UIColor whiteColor];
			if (iconImageView.image) {
				iconImageView.image = [iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
		}

	}
}
	
%end

%ctor {
	dlopen("/System/Library/Frameworks/MediaPlayer.framework/MediaPlayer", RTLD_NOW);
	%init;
}