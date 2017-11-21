#import "APTableCell.h"
#import <QuartzCore/CAFilter+Private.h>
#import <QuartzCore/CALayer+Private.h>

%hook APTableCell
%property (nonatomic, assign) BOOL mze_isMZECell;
%property (nonatomic, retain) MZEMaterialView *vibrantSeparator;

- (void)layoutSubviews {
	%orig;
	if (self.mze_isMZECell) {
		if (!self.vibrantSeparator) {
			CGFloat separatorHeight = 1.0f/[UIScreen mainScreen].scale;
			self.vibrantSeparator = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
			self.vibrantSeparator.frame = CGRectMake(self.separatorInset.left,self.bounds.size.height - separatorHeight,CGRectGetWidth(self.bounds) - self.separatorInset.left, separatorHeight);
			[self addSubview:self.vibrantSeparator];
			self.vibrantSeparator.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
										UIViewAutoresizingFlexibleBottomMargin | 
										UIViewAutoresizingFlexibleRightMargin);
		}
		if (self.vibrantSeparator) {
			if (MSHookIvar<BOOL>(self, "_labelOnly")) {
				self.vibrantSeparator.alpha = 0.0;
				CGRect sepFrame = self.vibrantSeparator.frame;
				sepFrame.origin.x = self.separatorInset.left;
				sepFrame.size.width = self.bounds.size.width - self.separatorInset.left;
				self.vibrantSeparator.frame = sepFrame;
			} else {
				self.vibrantSeparator.alpha = 1.0;
			}
		}

		if ([self valueForKey:@"_hotspotNetworkTypeLabel"]) {
			((UILabel *)[self valueForKey:@"_hotspotNetworkTypeLabel"]).textColor = [UIColor whiteColor];
		}

		if (self.textLabel) {
			self.textLabel.textColor = [UIColor whiteColor];
		}

		MSHookIvar<UIColor *>(self, "_selectionTintColor") = [UIColor colorWithWhite:1 alpha:0.4];
	}
	// if (self.mze_isMZECell) {
	// 	if (self.textLabel) {
	// 		if (!self.textLabel.layer.compositingFilter) {
	// 			self.textLabel.layer.compositingFilter = @"plusL";
	// 		}
	// 		self.textLabel.textColor = [UIColor whiteColor];
	// 		self.textLabel.alpha = 0.6;
	// 	}

	// 	if (self.detailTextLabel) {
	// 		// if (!self.detailTextLabel.layer.compositingFilter) {
	// 		// 	self.detailTextLabel.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
	// 		// }
	// 		// self.detailTextLabel.textColor = [UIColor whiteColor];
	// 		// self.detailTextLabel.alpha = 0.3;
	// 		self.detailTextLabel.text = nil;
	// 	}

	// 	if ([self valueForKey:@"_barsView"]) {
	// 		UIImageView *barsView = (UIImageView *)[self valueForKey:@"_barsView"];
	// 		barsView.tintColor = [UIColor whiteColor];
	// 		if (!barsView.layer.compositingFilter) {
	// 			barsView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
	// 		}

	// 		barsView.alpha = 0.8;
	// 	}

	// 	if ([self valueForKey:@"_lockView"]) {
	// 		UIImageView *lockView = (UIImageView *)[self valueForKey:@"_lockView"];
	// 		lockView.tintColor = [UIColor whiteColor];
	// 		if (!lockView.layer.compositingFilter) {
	// 			lockView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
	// 		}
	// 		lockView.alpha = 0.8;
	// 	}
	// }
}

- (void)refreshCellContentsWithSpecifier:(id)spec {
	%orig;
	self.detailTextLabel.text = nil;
}

- (void)setDetailText:(NSString *)text {
	if (self.mze_isMZECell) {
		%orig(nil);
		self.detailTextLabel.text = nil;
	} else {
		%orig;
	}
}

- (void)__layoutNetwork {
	%orig;
	if (self.mze_isMZECell) {
		if (self.textLabel) {
			if (!self.textLabel.layer.compositingFilter) {
				self.textLabel.layer.compositingFilter = @"plusL";
			}
			self.textLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
		}
		self.detailTextLabel.text = nil;

		if ([self valueForKey:@"_barsView"]) {
			UIImageView *barsView = (UIImageView *)[self valueForKey:@"_barsView"];
			if (barsView.image) {
				barsView.image = [barsView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			barsView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
			if (!barsView.layer.compositingFilter) {
				barsView.layer.compositingFilter = @"plusL";
			}
		}

		if ([self valueForKey:@"_lockView"]) {
			UIImageView *lockView = (UIImageView *)[self valueForKey:@"_lockView"];
			if (lockView.image) {
				lockView.image = [lockView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			lockView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
			if (!lockView.layer.compositingFilter) {
				lockView.layer.compositingFilter = @"plusL";
			}
		}

		if ([self valueForKey:@"_hotspotSignalView"]) {
			UIImageView *hotspotSignalView = (UIImageView *)[self valueForKey:@"_hotspotSignalView"];
			if (hotspotSignalView.image) {
				hotspotSignalView.image = [hotspotSignalView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			hotspotSignalView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
			if (!hotspotSignalView.layer.compositingFilter) {
				hotspotSignalView.layer.compositingFilter = @"plusL";
			}
		}

		if ([self valueForKey:@"_hotspotBatteryView"]) {
			id hotspotBatteryView = [self valueForKey:@"_hotspotBatteryView"];
			if ([hotspotBatteryView valueForKey:@"_shellImageView"]) {
				UIImageView *batteryShellView = (UIImageView *)[hotspotBatteryView valueForKey:@"_shellImageView"];
				if (batteryShellView.image) {
					batteryShellView.image = [batteryShellView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				}
				batteryShellView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
				if (!batteryShellView.layer.compositingFilter) {
					batteryShellView.layer.compositingFilter = @"plusL";
				}
			}
		}
	}
	// if (self.textLabel) {
	// 	if (!self.textLabel.layer.compositingFilter) {
	// 		self.textLabel.layer.compositingFilter = @"plusL";
	// 	}
	// 	self.textLabel.alpha = 0.6;
	// 	self.textLabel.textColor = [UIColor whiteColor];
	// }

	// if (self.detailTextLabel) {
	// 	// if (!self.detailTextLabel.layer.compositingFilter) {
	// 	// 	self.detailTextLabel.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
	// 	// }
	// 	// self.detailTextLabel.textColor = [UIColor whiteColor];
	// 	// self.detailTextLabel.alpha = 0.3;
	// 	self.detailTextLabel.text = nil;
	// }
	// if ([self valueForKey:@"_barsView"]) {
	// 	UIImageView *barsView = (UIImageView *)[self valueForKey:@"_barsView"];
	// 	barsView.tintColor = [UIColor whiteColor];
	// 	if (!barsView.layer.compositingFilter) {
	// 		barsView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
	// 	}

	// 	barsView.alpha = 0.8;
	// }

	// if ([self valueForKey:@"_lockView"]) {
	// 	UIImageView *lockView = (UIImageView *)[self valueForKey:@"_lockView"];
	// 	lockView.tintColor = [UIColor whiteColor];
	// 	if (!lockView.layer.compositingFilter) {
	// 		lockView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
	// 	}
	// 	lockView.alpha = 0.8;
	// }

	//self.detailTextLabel.text = nil;
}

-(void)updateImages {
	%orig;
	if (self.mze_isMZECell) {
		if ([self valueForKey:@"_barsView"]) {
			UIImageView *barsView = (UIImageView *)[self valueForKey:@"_barsView"];
			if (barsView.image) {
				barsView.image = [barsView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			barsView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
			if (!barsView.layer.compositingFilter) {
				barsView.layer.compositingFilter = @"plusL";
			}
		}

		if ([self valueForKey:@"_lockView"]) {
			UIImageView *lockView = (UIImageView *)[self valueForKey:@"_lockView"];
			if (lockView.image) {
				lockView.image = [lockView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			lockView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
			if (!lockView.layer.compositingFilter) {
				lockView.layer.compositingFilter = @"plusL";
			}
		}

		if ([self valueForKey:@"_hotspotSignalView"]) {
			UIImageView *hotspotSignalView = (UIImageView *)[self valueForKey:@"_hotspotSignalView"];
			if (hotspotSignalView.image) {
				hotspotSignalView.image = [hotspotSignalView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			hotspotSignalView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
			if (!hotspotSignalView.layer.compositingFilter) {
				hotspotSignalView.layer.compositingFilter = @"plusL";
			}
		}

		if ([self valueForKey:@"_hotspotBatteryView"]) {
			id hotspotBatteryView = [self valueForKey:@"_hotspotBatteryView"];
			if ([hotspotBatteryView valueForKey:@"_shellImageView"]) {
				UIImageView *batteryShellView = (UIImageView *)[hotspotBatteryView valueForKey:@"_shellImageView"];
				if (batteryShellView.image) {
					batteryShellView.image = [batteryShellView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				}
				batteryShellView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
				if (!batteryShellView.layer.compositingFilter) {
					batteryShellView.layer.compositingFilter = @"plusL";
				}
			}
		}
	}
}

- (void)setLabelOnly {
	%orig;
	if (self.mze_isMZECell) {
		if (!self.vibrantSeparator) {
			CGFloat separatorHeight = 1.0f/[UIScreen mainScreen].scale;
			self.vibrantSeparator = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
			self.vibrantSeparator.frame = CGRectMake(0,self.bounds.size.height - separatorHeight,CGRectGetWidth(self.bounds) - self.separatorInset.left, separatorHeight);
			[self addSubview:self.vibrantSeparator];
			self.vibrantSeparator.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
										UIViewAutoresizingFlexibleBottomMargin | 
										UIViewAutoresizingFlexibleRightMargin);
		}
		if (self.vibrantSeparator) {
			if (MSHookIvar<BOOL>(self, "_labelOnly")) {
				self.vibrantSeparator.alpha = 0.0;
				CGRect sepFrame = self.vibrantSeparator.frame;
				sepFrame.origin.x = self.separatorInset.left;
				sepFrame.size.width = self.bounds.size.width - self.separatorInset.left;
				self.vibrantSeparator.frame = sepFrame;
			} else {
				self.vibrantSeparator.alpha = 1.0;
			}
		}
	}
}

- (UIColor *)selectionTintColor {
	if (self.mze_isMZECell) {
		return [UIColor colorWithWhite:1 alpha:0.4];
	} else return %orig;
}

- (void)setSelectionTintColor:(UIColor *)color {
	if (self.mze_isMZECell) {
		%orig([UIColor colorWithWhite:1 alpha:0.4]);
	} else {
		%orig;
	}
}

- (void)__layoutRemoteHotspotDevice {
	%orig;
	if (self.mze_isMZECell) {
		if ([self valueForKey:@"_hotspotSignalView"]) {
			UIImageView *hotspotSignalView = (UIImageView *)[self valueForKey:@"_hotspotSignalView"];
			if (hotspotSignalView.image) {
				hotspotSignalView.image = [hotspotSignalView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			hotspotSignalView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
			if (!hotspotSignalView.layer.compositingFilter) {
				hotspotSignalView.layer.compositingFilter = @"plusL";
			}
		}

		if ([self valueForKey:@"_hotspotBatteryView"]) {
			id hotspotBatteryView = [self valueForKey:@"_hotspotBatteryView"];
			if ([hotspotBatteryView valueForKey:@"_shellImageView"]) {
				UIImageView *batteryShellView = (UIImageView *)[hotspotBatteryView valueForKey:@"_shellImageView"];
				if (batteryShellView.image) {
					batteryShellView.image = [batteryShellView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				}
				batteryShellView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
				if (!batteryShellView.layer.compositingFilter) {
					batteryShellView.layer.compositingFilter = @"plusL";
				}
			}
		}

		if ([self valueForKey:@"_hotspotNetworkTypeLabel"]) {
			((UILabel *)[self valueForKey:@"_hotspotNetworkTypeLabel"]).textColor = [UIColor whiteColor];
		}
	}
}
%end


%ctor {
	BOOL shouldInit = NO;
	if (!NSClassFromString(@"APTableCell")) {
		NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle"];
		NSBundle *bundle;
		bundle = [NSBundle bundleWithPath:fullPath];
		BOOL didLoad = [bundle load];
		if (didLoad) {
			shouldInit = YES;
		}
	} else {
		shouldInit = YES;
	}

	if (shouldInit) {
		%init;
	}
}