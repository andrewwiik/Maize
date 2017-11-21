#import "MZEMediaMetaDataView.h"
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIImage+Private.h>

extern NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);

@implementation MZEMediaMetaDataView
-(id)initWithFrame:(CGRect)arg1 {
	self = [super initWithFrame:arg1];

	self.titleLabel = [[MZEMediaMarqueeLabel alloc] init];
	self.titleLabel.frame = self.bounds;
	//self.titleLabel.label.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.label.font = [UIFont fontWithName:@".SFUIText-Semibold" size:11.0];
	self.titleLabel.label.textColor = [UIColor whiteColor];
	self.titleLabel.label.alpha = 0.48;
	[self addSubview:self.titleLabel];

	self.primaryLabel = [[MZEMediaMarqueeLabel alloc] init];
	self.primaryLabel.frame = self.bounds;
	self.primaryLabel.label.textAlignment = NSTextAlignmentCenter;
	self.primaryLabel.label.font = [UIFont fontWithName:@".SFUIText-Semibold" size:17.0];
	self.primaryLabel.label.textColor = [UIColor whiteColor];
	self.primaryLabel.label.alpha = 0.8;
	[self addSubview:self.primaryLabel];

	self.secondaryLabel = [[MZEMediaMarqueeLabel alloc] init];
	self.secondaryLabel.frame = self.bounds;
	self.secondaryLabel.label.textAlignment = NSTextAlignmentCenter;
	self.secondaryLabel.label.font = [UIFont fontWithName:@".SFUIText" size:17.0];
	self.secondaryLabel.label.textColor = [UIColor whiteColor];
	self.secondaryLabel.label.alpha = 0.8;
	[self addSubview:self.secondaryLabel];

	self.headerDivider = [[UIView alloc] init];
	self.headerDivider.frame = CGRectMake(0,self.frame.size.height - 0.5, self.frame.size.width, 0.5);
	self.headerDivider.backgroundColor = [UIColor whiteColor];
	self.headerDivider.alpha = 0.080f;
	self.headerDivider.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
	[self addSubview:self.headerDivider];

	// self.subtitleLabel = [[MZEMediaMarqueeLabel alloc] init];
	// self.subtitleLabel.frame = self.bounds;
	// [self addSubview:self.subtitleLabel];

	self.outputButton = [[MZEMediaOutputToggleButton alloc] init];
	[self addSubview:self.outputButton];

	self.artworkView = [[MZEMediaArtworkView alloc] init];
	self.artworkView.alpha = 0;
	[self addSubview:self.artworkView];

	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(updatePickedRoute)
		name:(__bridge NSString *)kMRMediaRemoteRouteStatusDidChangeNotification
		object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(updatePickedRoute)
		name:@"_AVSystemController_ActiveAudioRouteDidChangeNotification"
		object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(nowPlayingAppDidChange)
		name:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationDidChangeNotification
		object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(nowPlayingAppDidChange)
		name:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationDisplayNameDidChangeNotification
		object:nil];

	[self updateMediaForChangeOfMediaControlsStatus];

	return self;
}
-(void)layoutSubviews{

	// if (self.titleLabel.label.text == nil) {
	// 	self.titleLabel.label.text = @"IPHONE";
	// 	self.subtitleLabel.label.text = @"Music";

	// 	[self.titleLabel.label setEffects:1];
	// 	[self.subtitleLabel.label setEffects:0];

	// 	[self.titleLabel setMarqueeEnabled:FALSE];
	// 	[self.subtitleLabel setMarqueeEnabled:FALSE];
	// }

	[self updateFrame];
}
-(void)updateFrame {
	// [self.titleLabel.label sizeToFit];
	// [self.subtitleLabel.label sizeToFit];

	// self.titleLabel.label.frame = CGRectMake(0,0,self.titleLabel.label.frame.size.width, self.frame.size.height/4);
	// self.subtitleLabel.label.frame = CGRectMake(0,0,self.subtitleLabel.label.frame.size.width, self.frame.size.height/4);

	float artwork = self.frame.size.height*0.555;

	if (self.expanded) {

		CGFloat containerHeight = CGRectGetHeight(self.bounds);

		CGFloat titleY = 0;
		CGFloat primaryY = 0;
		CGFloat secondaryY = 0;
		CGFloat allX = containerHeight*0.222 + artwork + 12.0;
		CGFloat maxLabelWidth = (self.frame.size.width - self.frame.size.height*0.222 - self.frame.size.height*0.352 - 6.0) - allX;

		if (self.titleString && self.primaryString && self.secondaryString) {
			
			titleY = containerHeight*0.254;
			primaryY = containerHeight*0.403;
			secondaryY = containerHeight*0.588;
			//CGFloat allX = containerHeight*0.222 + artwork + 12.0;

			
		} else if (self.titleString && self.primaryString) {

			titleY = containerHeight*0.346;
			primaryY = containerHeight*0.496;
			//CGFloat allX = containerHeight*0.222 + artwork + 12.0;

			
		} else if (self.titleString) {
			titleY = containerHeight*0.407;
		} else {

		}

		if (self.titleLabel.label.text != self.titleString) {
			self.titleLabel.label.text = self.titleString;
			[self.titleLabel.label sizeToFit];

			// if (self.titleLabel.label.bounds.size.width > maxLabelWidth)
			[self.titleLabel setContentSize:self.titleLabel.label.bounds.size];
		}

		CGRect titleFrame = self.titleLabel.label.bounds;
		titleFrame.origin.x = allX;
		titleFrame.origin.y = titleY;
		self.titleLabel.frame = titleFrame;
		self.titleLabel.alpha = 1.0;

		BOOL primaryUsesMarquee = NO;
		if (self.primaryLabel.label.text != self.primaryString) {
			self.primaryLabel.label.text = self.primaryString;
			[self.primaryLabel.label sizeToFit];
			//BOOL useMarquee = NO;
			if (self.primaryLabel.label.bounds.size.width > maxLabelWidth) {
				primaryUsesMarquee = YES;
			}
			[self.primaryLabel setContentSize:self.primaryLabel.label.bounds.size];
		}

		CGRect primaryFrame = self.primaryLabel.label.bounds;
		primaryFrame.origin.x = allX;
		primaryFrame.origin.y = primaryY;

		if (primaryUsesMarquee) {
			primaryFrame.size.width = maxLabelWidth;
			primaryFrame.origin.x -= 6;
		}
		self.primaryLabel.fadeEdgeInsets = UIEdgeInsetsMake(0, primaryUsesMarquee ? 6 : 0, 0, primaryUsesMarquee ? 6 : 0);
		[self.primaryLabel setMarqueeEnabled:primaryUsesMarquee];

		self.primaryLabel.label.textAlignment = NSTextAlignmentLeft;
		self.primaryLabel.frame = primaryFrame;


		BOOL secondaryUsesMarquee = NO;
		if (self.secondaryLabel.label.text != self.secondaryString) {
			self.secondaryLabel.label.text = self.secondaryString;
			[self.secondaryLabel.label sizeToFit];

			if (self.secondaryLabel.label.bounds.size.width > maxLabelWidth) {
				secondaryUsesMarquee = YES;
			}
			[self.secondaryLabel setContentSize:self.secondaryLabel.label.bounds.size];
		}

		CGRect secondaryFrame = self.secondaryLabel.label.bounds;
		secondaryFrame.origin.x = allX;
		secondaryFrame.origin.y = secondaryY;

		if (secondaryUsesMarquee) {
			secondaryFrame.size.width = maxLabelWidth;
			secondaryFrame.origin.x -= 6;
		}
		// [self.secondaryLabel setMarqueeEnabled:secondaryUsesMarquee];
		self.secondaryLabel.fadeEdgeInsets = UIEdgeInsetsMake(0, secondaryUsesMarquee ? 6 : 0, 0, secondaryUsesMarquee ? 6 : 0);
		[self.secondaryLabel setMarqueeEnabled:secondaryUsesMarquee];

		self.secondaryLabel.label.textAlignment = NSTextAlignmentLeft;
		self.secondaryLabel.frame = secondaryFrame;

		self.outputButton.alpha = 1;
		self.artworkView.alpha = 1;
		self.headerDivider.alpha = 0.16f;

		self.outputButton.frame = CGRectMake(self.frame.size.width - self.frame.size.height*0.222 - self.frame.size.height*0.352, self.frame.size.height*0.324, self.frame.size.height*0.352, self.frame.size.height*0.352);
		self.artworkView.frame = CGRectMake(self.frame.size.height*0.222, self.frame.size.height*0.222, artwork, artwork);
		self.headerDivider.frame = CGRectMake(0,self.frame.size.height - 0.5, self.frame.size.width, 0.5);

		// self.titleLabel.frame = CGRectMake(artwork + self.frame.size.width/10, self.frame.size.height/4, self.frame.size.width/2, self.frame.size.height/4);
		// self.subtitleLabel.frame = CGRectMake(artwork + self.frame.size.width/10, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/4);

		// [self.titleLabel contentView].frame = self.titleLabel.label.bounds;
		// [self.subtitleLabel contentView].frame = self.subtitleLabel.label.bounds;

		// [self.titleLabel setContentSize:CGSizeMake(self.titleLabel.label.frame.size.width, self.titleLabel.label.frame.size.height)];
		// [self.titleLabel setBounds:self.titleLabel.bounds];

		// [self.subtitleLabel setContentSize:CGSizeMake(self.subtitleLabel.label.frame.size.width, self.subtitleLabel.label.frame.size.height)];
		// [self.subtitleLabel setBounds:self.subtitleLabel.bounds];

		// if([self.titleLabel.label.text length] > 16){
		// 	[self.titleLabel setMarqueeEnabled:TRUE];
		// 	self.titleLabel.label.center = CGPointMake(self.titleLabel.label.frame.size.width  / 2, self.titleLabel.frame.size.height / 2);
		// } else {
		// 	[self.titleLabel setMarqueeEnabled:FALSE];
		// }
		// self.titleLabel.label.center = CGPointMake(self.titleLabel.label.frame.size.width  / 2, self.titleLabel.frame.size.height / 2);

		// if([self.subtitleLabel.label.text length] > 16){
		// 	[self.subtitleLabel setMarqueeEnabled:TRUE];
		// } else {
		// 	[self.subtitleLabel setMarqueeEnabled:FALSE];
		// }
		// self.subtitleLabel.label.center = CGPointMake(self.subtitleLabel.label.frame.size.width/2, self.subtitleLabel.frame.size.height/2);

	} else {

		CGFloat containerHeight = CGRectGetHeight(self.bounds);

		CGFloat titleY = 0;
		CGFloat primaryY = 0;
		CGFloat secondaryY = 0;
		CGFloat allX = 0;
		CGFloat maxLabelWidth = self.frame.size.width - 6;

		if (self.primaryString) {

			secondaryY = containerHeight/3;
			//CGFloat allX = containerHeight*0.222 + artwork + 12.0;
		} 

		if (self.titleLabel.label.text != self.titleString) {
			self.titleLabel.label.text = self.titleString;
			[self.titleLabel.label sizeToFit];

			// if (self.titleLabel.label.bounds.size.width > maxLabelWidth)
			[self.titleLabel setContentSize:self.titleLabel.label.bounds.size];
		}

		CGRect titleFrame = self.titleLabel.label.bounds;
		titleFrame.origin.x = allX;
		titleFrame.origin.y = titleY;
		self.titleLabel.frame = titleFrame;
		self.titleLabel.alpha = 0;

		BOOL primaryUsesMarquee = NO;
		if (self.primaryLabel.label.text != self.primaryString) {
			self.primaryLabel.label.text = self.primaryString;
			[self.primaryLabel.label sizeToFit];
			//BOOL useMarquee = NO;
			if (self.primaryLabel.label.bounds.size.width > maxLabelWidth) {
				primaryUsesMarquee = YES;
			}
			[self.primaryLabel setContentSize:self.primaryLabel.label.bounds.size];
		}

		CGRect primaryFrame = self.primaryLabel.label.bounds;
		primaryFrame.origin.x = allX;
		primaryFrame.origin.y = primaryY;

		if (primaryUsesMarquee) {
			primaryFrame.size.width = maxLabelWidth;
			//primaryFrame.origin.x -= 6;
		}
		self.primaryLabel.fadeEdgeInsets = UIEdgeInsetsMake(0, primaryUsesMarquee ? 6 : 0, 0, primaryUsesMarquee ? 6 : 0);
		[self.primaryLabel setMarqueeEnabled:primaryUsesMarquee];

		self.primaryLabel.label.textAlignment = NSTextAlignmentCenter;
		self.primaryLabel.frame = primaryFrame;
		CGPoint primaryCenter = self.primaryLabel.center;
		primaryCenter.x = self.frame.size.width/2 - (primaryUsesMarquee ? 0 : 0);
		self.primaryLabel.center = primaryCenter;


		BOOL secondaryUsesMarquee = NO;
		if (self.secondaryLabel.label.text != self.secondaryString) {
			self.secondaryLabel.label.text = self.secondaryString;
			[self.secondaryLabel.label sizeToFit];

			if (self.secondaryLabel.label.bounds.size.width > maxLabelWidth) {
				secondaryUsesMarquee = YES;
			}
			[self.secondaryLabel setContentSize:self.secondaryLabel.label.bounds.size];
		}

		CGRect secondaryFrame = self.secondaryLabel.label.bounds;
		secondaryFrame.origin.x = allX;
		secondaryFrame.origin.y = secondaryY;

		if (secondaryUsesMarquee) {
			secondaryFrame.size.width = maxLabelWidth;
			//secondaryFrame.origin.x -= 6;
		}
		self.secondaryLabel.fadeEdgeInsets = UIEdgeInsetsMake(0, secondaryUsesMarquee ? 6 : 0, 0, secondaryUsesMarquee ? 6 : 0);
		[self.secondaryLabel setMarqueeEnabled:secondaryUsesMarquee];

		self.secondaryLabel.label.textAlignment = NSTextAlignmentCenter;
		self.secondaryLabel.frame = secondaryFrame;
		CGPoint secondaryCenter = self.secondaryLabel.center;
		secondaryCenter.x = self.frame.size.width/2 - (secondaryUsesMarquee ? 0 : 0);
		self.secondaryLabel.center = secondaryCenter;




		self.outputButton.alpha = 0;
		self.artworkView.alpha = 0;
		self.headerDivider.alpha = 0;



		// self.titleLabel.frame = CGRectMake(self.frame.size.width/20, self.frame.size.height/4, self.frame.size.width - self.frame.size.width/10, self.frame.size.height/4);
		// self.subtitleLabel.frame = CGRectMake(self.frame.size.width/20, self.frame.size.height/2 + 5, self.frame.size.width - self.frame.size.width/10, self.frame.size.height/4);

		// [self.titleLabel contentView].frame = self.titleLabel.label.bounds;
		// [self.subtitleLabel contentView].frame = self.subtitleLabel.label.bounds;

		// [self.titleLabel setContentSize:CGSizeMake(self.titleLabel.label.frame.size.width, self.titleLabel.label.frame.size.height)];
		// [self.titleLabel setBounds:self.titleLabel.bounds];

		// [self.subtitleLabel setContentSize:CGSizeMake(self.subtitleLabel.label.frame.size.width, self.subtitleLabel.label.frame.size.height)];
		// [self.subtitleLabel setBounds:self.subtitleLabel.bounds];


		// if([self.titleLabel.label.text length] >= 16){
		// 	[self.titleLabel setMarqueeEnabled:TRUE];
		// 	self.titleLabel.label.center = CGPointMake(self.titleLabel.label.frame.size.width  / 2, self.titleLabel.frame.size.height / 2);
		// } else {
		// 	[self.titleLabel setMarqueeEnabled:FALSE];
		// 	self.titleLabel.label.center = CGPointMake(self.titleLabel.frame.size.width  / 2, self.titleLabel.frame.size.height / 2);
		// }

		// if([self.subtitleLabel.label.text length] >= 16){
		// 	[self.subtitleLabel setMarqueeEnabled:TRUE];
		// 	self.subtitleLabel.label.center = CGPointMake(self.subtitleLabel.label.frame.size.width/2, self.subtitleLabel.frame.size.height/2);
		// } else {
		// 	[self.subtitleLabel setMarqueeEnabled:FALSE];
		// 	self.subtitleLabel.label.center = CGPointMake(self.subtitleLabel.frame.size.width/2, self.subtitleLabel.frame.size.height/2);
		// }
	}
}
-(void)updateMediaForChangeOfMediaControlsStatus {
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
			NSDictionary *dict=(__bridge NSDictionary *)(information);

			if(dict != NULL){
					if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] != nil) {
						NSString *titleText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]];
						_primaryString = titleText;
					} else {
						_primaryString = _nowPlayingApplicationDisplayName;
					}

					if (_expanded) {
						if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] != nil && [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] != nil) {
							NSString *artistText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
							NSString *albumText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum]];
							_secondaryString = [NSString stringWithFormat:@"%@ — %@", artistText, albumText];
						} else if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] != nil) {
							NSString *artistText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
							_secondaryString = artistText;
						} else if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] != nil) {
							NSString *albumText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum]];
							_secondaryString = albumText;
						} else {
							_secondaryString = nil;
						}
					} else {
						if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] != nil) {
							NSString *artistText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
							_secondaryString = artistText;
						} else {
							_secondaryString = nil;
						}
					}

					if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]!= NULL) {
						UIImage *image = [UIImage imageWithData:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]];
						self.artworkView.imageView.contentMode = UIViewContentModeScaleToFill;
						[self.artworkView setImage:image];

					} else {
						if (_nowPlayingIconImage) {
							[self.artworkView setImage:_nowPlayingIconImage];
							self.artworkView.imageView.contentMode = UIViewContentModeCenter;
						}
						// if (_nowPlayingApplicationID) {
						// 	[self.artworkView]
						// }
						// [self.artworkView setImage:[UIImage _applicationIconImageForBundleIdentifier:]];
					}

					// if (!_primaryString && !_secondaryString) {
					// 	MRMediaRemoteGetNowPlayingApplicationDisplayID(dispatch_get_main_queue(), ^(CFStringRef applicationDisplayID) {
					// 		NSString *nowPlayingApplicationID = (__bridge NSString*)applicationDisplayID;
					// 		if (_nowPlayingApplicationID != nowPlayingApplicationID) {
					// 			_nowPlayingApplicationID = nowPlayingApplicationID;
					// 			_nowPlayingApplicationDisplayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(_nowPlayingApplicationID);
					// 			self.primaryString = _nowPlayingApplicationDisplayName;
					// 		}
					// 	});
					// }

					//self.titleString = @"MASTER'S AIRPODS";

					// if(self.titleLabel.label.style == 1 || self.subtitleLabel.label.style == 0){
					// 	[self.titleLabel.label setEffects:0];
					// 	[self.subtitleLabel.label setEffects:2];
					// }
			} else {
				// MRMediaRemoteGetNowPlayingApplicationDisplayID(dispatch_get_main_queue(), ^(CFStringRef applicationDisplayID) {
				// 	NSString *nowPlayingApplicationID = (__bridge NSString*)applicationDisplayID;
				// 	if (_nowPlayingApplicationID != nowPlayingApplicationID) {
				// 		_nowPlayingApplicationID = nowPlayingApplicationID;
				// 		_nowPlayingApplicationDisplayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(_nowPlayingApplicationID);
				// 		self.primaryString = _nowPlayingApplicationDisplayName;
				// 	}
				// });
				// if ()
				_primaryString = _nowPlayingApplicationDisplayName;
				_secondaryString = nil;
			}

			// if ((!_primaryString && !_secondaryString) || _nowPlayingApplicationID == nil) {
			// 	MRMediaRemoteGetNowPlayingApplicationDisplayID(dispatch_get_main_queue(), ^(CFStringRef applicationDisplayID) {
			// 		NSString *nowPlayingApplicationID = (__bridge NSString*)applicationDisplayID;
			// 		if (nowPlayingApplicationID == nil) {
			// 			nowPlayingApplicationID = @"com.apple.Music";
			// 		}

			// 		if (_nowPlayingApplicationID != nowPlayingApplicationID) {
			// 			_nowPlayingApplicationID = nowPlayingApplicationID;
			// 			_nowPlayingApplicationDisplayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(_nowPlayingApplicationID);
			// 			if (!_primaryString && !_secondaryString) {
			// 				self.primaryString = _nowPlayingApplicationDisplayName;
			// 			}
			// 		}
			// 	});
			// }

			if (self.routingController) {
				if ([self.routingController pickedRoute]) {
					MPAVRoute *pickedRoute = [self.routingController pickedRoute];
					NSString *titleString = pickedRoute.routeName;
					if (!pickedRoute.isDeviceRoute) {
						titleString = [titleString uppercaseString];
					}

					_titleString = titleString;
				}
			}

			//_titleString = @"MASTER'S AIRPODS";

			[self updateFrame];
	});

	if ((!_primaryString && !_secondaryString) || _nowPlayingApplicationID == nil) {
		MRMediaRemoteGetNowPlayingApplicationDisplayID(dispatch_get_main_queue(), ^(CFStringRef applicationDisplayID) {
			NSString *nowPlayingApplicationID = (__bridge NSString*)applicationDisplayID;
			if (nowPlayingApplicationID == nil) {
				nowPlayingApplicationID = @"com.apple.Music";
			}

			if (_nowPlayingApplicationID != nowPlayingApplicationID) {
				_nowPlayingApplicationID = nowPlayingApplicationID;
				_nowPlayingApplicationDisplayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(_nowPlayingApplicationID);
				if (!_nowPlayingApplicationDisplayName || [_nowPlayingApplicationDisplayName length] == 0) {
					_nowPlayingApplicationID = @"com.apple.Music";
					_nowPlayingApplicationDisplayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(_nowPlayingApplicationID);
				}
				_nowPlayingIconImage = [UIImage _applicationIconImageForBundleIdentifier:_nowPlayingApplicationID format:0 scale:[UIScreen mainScreen].scale];
				if (!_primaryString && !_secondaryString) {
					self.primaryString = _nowPlayingApplicationDisplayName;
					self.artworkView.imageView.contentMode = UIViewContentModeCenter;
					[self.artworkView setImage:_nowPlayingIconImage];
				}
			}
		});
	}


	// if (!_primaryString)
}

- (void)updatePickedRoute {
	if (self.routingController) {
		if ([self.routingController pickedRoute]) {
			MPAVRoute *pickedRoute = [self.routingController pickedRoute];
			NSString *titleString = pickedRoute.routeName;
			if (!pickedRoute.isDeviceRoute) {
				titleString = [titleString uppercaseString];
			}

			self.titleString = titleString;
		}
	}
}

- (void)nowPlayingAppDidChange {
	MRMediaRemoteGetNowPlayingApplicationDisplayID(dispatch_get_main_queue(), ^(CFStringRef applicationDisplayID) {
		NSString *nowPlayingApplicationID = (__bridge NSString*)applicationDisplayID;
		if (nowPlayingApplicationID == nil || [nowPlayingApplicationID length] == 0) {
			nowPlayingApplicationID = @"com.apple.Music";
		}

		if (_nowPlayingApplicationID != nowPlayingApplicationID) {
			_nowPlayingApplicationID = nowPlayingApplicationID;
			_nowPlayingApplicationDisplayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(_nowPlayingApplicationID);
			if (!_nowPlayingApplicationDisplayName || [_nowPlayingApplicationDisplayName length] == 0) {
				_nowPlayingApplicationID = @"com.apple.Music";
				_nowPlayingApplicationDisplayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(_nowPlayingApplicationID);
			}
			_nowPlayingIconImage = [UIImage _applicationIconImageForBundleIdentifier:_nowPlayingApplicationID format:0 scale:[UIScreen mainScreen].scale];
			if (!_primaryString && !_secondaryString) {
				self.primaryString = _nowPlayingApplicationDisplayName;
				self.artworkView.imageView.contentMode = UIViewContentModeCenter;
				[self.artworkView setImage:_nowPlayingIconImage];
			}
		}
	});
}

- (void)setExpanded:(BOOL)expanded {
	if (_expanded != expanded) {
		_expanded = expanded;
		[self updateMediaForChangeOfMediaControlsStatus];
	}
}

- (void)setTitleString:(NSString *)titleString {
	if (titleString && [titleString length] == 0) titleString = nil;
	if (_titleString != titleString) {
		_titleString = titleString;
		[self updateFrame];
	}
}

- (void)setPrimaryString:(NSString *)primaryString {

	if (primaryString && [primaryString length] == 0) primaryString = nil;
	if (_primaryString != primaryString) {
		_primaryString = primaryString;
		[self updateFrame];
	}
}

- (void)setSecondaryString:(NSString *)secondaryString {
	if (secondaryString && [secondaryString length] == 0) secondaryString = nil;
	if (_secondaryString != secondaryString) {
		_secondaryString = secondaryString;
		[self updateFrame];
	}
}
@end
