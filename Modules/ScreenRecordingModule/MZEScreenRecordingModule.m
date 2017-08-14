#import "MZEScreenRecordingModule.h"
@implementation MZEScreenRecordingModule

- (id)init {
	self = [super initWithSwitchIdentifier:@"com.a3tweaks.switch.record-screen"];
	if (self) {
		_recordToggle = [[NSClassFromString(@"CCUIRecordScreenShortcut") alloc] init];
	}
	return self;
}

- (CAPackage *)glyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"ScreenRecording" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)statusText {
	return @"";
}

- (void)setSelected:(BOOL)isSelected {


	if (_countingDown) {
		if (self.countDownTimer) {
			[self.countDownTimer invalidate];
			self.countDownTimer = nil;
		}
		_countingDown = NO;
		[_viewController setGlyphState:@"off"];
		[_viewController setSelected:NO];

		_isRecording = NO;
	} else if (isSelected) {
		_countingDown = YES;
		[_viewController setGlyphState:@"countdown|1.0"];
		self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(countDownMethodFired:) userInfo:nil repeats:NO];
		//[self performSelector:@selector(_setSelected:) withObject:[NSNumber numberWithBool:YES] afterDelay:3.0];
		// [UIView animateWithDuration:0 delay:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
		// 	// _countingDown = NO;
		// 	// [_viewController setGlyphState:@"recording"];
		// 	// //[_viewController setSelected:YES];
		// 	// [super setSelected:isSelected];
		// 	//[_viewController setGlyphState:@"recording"];
		// } completion:^(BOOL finished) {
		// 	//_countingDown = NO;
		// 	// [_viewController setGlyphState:@"recording"];
		// 	// //[_viewController setSelected:YES];
		// 	// [super setSelected:isSelected];
		// 	// _countingDown = NO;
		// 	// _isRecording = YES;
		// 	//[super setSelected:isSelected];
		// }];
	} else {
		//[super setSelected:isSelected];
		[_recordToggle _stopRecording];
		[_viewController setGlyphState:@"off"];
		[_viewController setSelected:isSelected];
		_isRecording = isSelected;
	}
}

- (void)countDownMethodFired:(NSTimer *)timer {
	if (_countingDown) {
		_isRecording = YES;
		[_recordToggle _startRecording];
		_countingDown = NO;
		[_viewController setGlyphState:@"recording"];
		[_viewController setSelected:YES];
	} else {
		_isRecording = NO;
		[_viewController setSelected:NO];
		[_viewController setGlyphState:@"off"];
	}

	[self.countDownTimer invalidate];
	self.countDownTimer = nil;
}



- (void)_setSelected:(NSNumber *)selected {
	// if ([selected boolValue]) {
	// 	if (![self isSelected]) {
	// 		[[NSClassFromString(@"RPScreenRecorder") sharedRecorder] startRecordingWithMicrophoneEnabled:NO
	// 			windowToRecord:nil
	// 		   	systemRecording:YES
	// 			handler:^(NSError *error) {
	// 			   	if (error) {
	// 			 		HBLogError(@"MZEScreenRecorder Failed: %@", error);
	// 			 	} else {
	// 			 		[_viewController setSelected:YES];
	// 			 	}
	// 		}];
	// 	} else {
	// 		HBLogError(@"MZEScreenRecorder was already recording");
	// 	}
	// } else {
	// 	if ([self isSelected]) {
	// 		[]
	// 	}
	// }
	if (_countingDown) {
		if ([selected boolValue]) {
			[_recordToggle _startRecording];
			_isRecording = YES;
		} else {
			[_recordToggle _stopRecording];
			_isRecording = NO;
		}
		[_viewController setSelected:[selected boolValue]];
		_countingDown = NO;
	}
	//[_viewController setSelected:[selected boolValue]];
}

- (BOOL)allowsHighlighting {
	return NO;
}

- (BOOL)shouldSelfSelect {
	return NO;
}

- (BOOL)isSelected {
	return _isRecording;
}

- (BOOL)isEnabled {
	return YES;
}

// - (BOOL)isEnabled {
// 	return _isRecording;
// }

- (NSString *)glyphState {

	if (_countingDown) {
		return @"countdown|1.0";
	}

	if ([self isSelected]) {
		return @"recording";
	} else {
		return @"off";
	}
}

@end