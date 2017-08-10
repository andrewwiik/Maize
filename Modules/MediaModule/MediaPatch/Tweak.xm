@interface CAFilter : NSObject
+(id)filterWithType:(id)arg1 ;
@end
@interface MPUControlCenterTimeView : UIView
@end

%hook MPUControlCenterTimeView
-(void)setFrame:(CGRect)frame {
	if(self.superview.tag == 4123723){
		frame.origin.y = self.superview.frame.size.height/10;
	}

	%orig(frame);
}
-(void)setHidden:(BOOL)arg1 {
	%orig(FALSE);
}
-(void)layoutSubviews {
	%orig;

		UISlider *slider = [self valueForKey:@"_slider"];

			UIView *trackView = [slider valueForKey:@"_maxTrackClipView"];
			trackView.alpha = 0.38;
			trackView.layer.cornerRadius = 2;
			trackView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
			trackView.backgroundColor = [UIColor whiteColor];


			UIImageView *maxTrack = [slider valueForKey:@"_maxTrackView"];
			maxTrack.alpha = 0;

}
%end

@interface MPUMediaControlsVolumeView : UIView
@end

%hook MPUMediaControlsVolumeView
-(void)setFrame:(CGRect)frame {
	if(self.superview.tag == 4123723){
		frame.origin.y = self.superview.frame.size.height - frame.size.height - self.superview.frame.size.height/10;
	}
	%orig(frame);
}
-(void)setHidden:(BOOL)arg1 {
	%orig(FALSE);
}
%end


@interface MPUTransportControlsView : UIView
@end

%hook MPUTransportControlsView
-(void)setFrame:(CGRect)frame {
	if(self.superview.tag == 4123723){
		frame.origin.y = self.superview.frame.size.height/2 - frame.size.height/2;
		if(self.superview.frame.size.width > 200){
			frame.origin.x = self.superview.frame.size.width/6;
			frame.size.width = self.superview.frame.size.width - self.superview.frame.size.width/3;
	 	} else {
			frame.origin.x = self.superview.frame.size.width/12;
			frame.size.width = self.superview.frame.size.width - self.superview.frame.size.width/6;
		}
	}
	[UIView
    animateWithDuration:0.5
    animations:^{
			%orig(frame);
    }];
}
-(void)setHidden:(BOOL)arg1 {
	%orig(FALSE);
}
%end


%hook MPUControlCenterTransportButton
- (void)_updateEffectForStateChange:(NSUInteger)state {
		%orig(1);
}
%end

@interface CCUIControlCenterLabel : UILabel
@end

%hook CCUIControlCenterLabel
-(void)setFrame:(CGRect)arg1 {
	%orig;
	if(self.superview.superview.tag == 4123723){
		self.textColor = [UIColor whiteColor];
		self.alpha = 0.48;
		self.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
	}
}
-(void)_updateEffects {
	if(self.superview.superview.tag == 4123723){
		self.textColor = [UIColor whiteColor];
		self.alpha = 0.48;
		self.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
	}
}
%end

@interface CCUIControlCenterSlider : UISlider
@end

%hook CCUIControlCenterSlider
-(void)_updateEffects {
	%orig;
	if(self.superview.superview.tag == 4123723){
		UIImageView *rightImage = [self valueForKey:@"_maxValueHighlightedImageView"];
		UIImageView *leftImage = [self valueForKey:@"_minValueHighlightedImageView"];

		rightImage.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
		leftImage.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];

		rightImage.image = [rightImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		[rightImage setTintColor:[UIColor whiteColor]];
		rightImage.alpha = 0.38;

		leftImage.image = [leftImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		[leftImage setTintColor:[UIColor whiteColor]];
		leftImage.alpha = 0.38;
		UIImageView *maxTrack = [self valueForKey:@"_maxTrackView"];
		maxTrack.alpha = 0;

		UIView *trackView = [self valueForKey:@"_maxTrackClipView"];
		trackView.alpha = 0.38;
		trackView.layer.cornerRadius = 2;
		leftImage.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
		trackView.backgroundColor = [UIColor whiteColor];
	}
}
%end
