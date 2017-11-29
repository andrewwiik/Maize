#import "MZEMediaModuleViewController.h"
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIScreen+Private.h>
#import <SpringBoard/SBControlCenterController+Private.h>
#import <MaizeUI/MZELayoutOptions.h>

@implementation MZEMediaModuleViewController

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	self = [super initWithNibName:arg1 bundle:arg2];
	if (self) {
		self.metadataView = [[NSClassFromString(@"MZEMediaMetaDataView") alloc] initWithFrame:self.view.bounds];
		[self.view addSubview:self.metadataView];

		[self.metadataView.outputButton.toggleButton addTarget:self action:@selector(outputButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

		self.controlsView = [[NSClassFromString(@"MZEMediaControlsViewController") alloc] init];
		[self.view addSubview:self.controlsView.view];

		self.metadataView.routingController = [self.controlsView.routingView.routingViewController _routingController];

		[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(updateMedia)
		name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification
		object:nil];

		_volumeHUDController = [[NSClassFromString(@"MPUVolumeHUDController") alloc] init];
		self.nowPlayingController = [[NSClassFromString(@"MPUNowPlayingController") alloc] init];
		_nowPlayingController.delegate = self;
		[_nowPlayingController _registerForNotifications];

		_isExpanded = NO;
	}
	return self;
}

- (void)outputButtonPressed:(UIButton *)outputButton {
	if (self.controlsView.showRouting) {
		self.controlsView.showRouting = NO;
		[UIView animateWithDuration:0.3 animations:^{
			[self.view setNeedsLayout];
			[self.view layoutIfNeeded];
			[self.controlsView viewWillLayoutSubviews];
			UIImage *btnImage = [[UIImage imageNamed:@"AirPlay" inBundle:[NSBundle bundleForClass:[self class]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  			[outputButton setImage:btnImage forState:UIControlStateNormal];
		} completion:^(BOOL completed) {
			//[self.controlsView.routingView.routingViewController _endRouteDiscovery];
		}];

		// UIImage *btnImage = [[UIImage imageNamed:@"AirPlay" inBundle:[NSBundle bundleForClass:[self class]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  // 		[outputButton setImage:btnImage forState:UIControlStateNormal];
		//[self.controlsView.routingView.routingViewController _endRouteDiscovery];
	} else {
		self.controlsView.showRouting = YES;
		//[self.controlsView.routingView.routingViewController _beginRouteDiscovery];
		[UIView animateWithDuration:0.3 animations:^{
			[self.view setNeedsLayout];
			[self.view layoutIfNeeded];
			[self.controlsView viewWillLayoutSubviews];
			UIImage *btnImage = [[UIImage imageNamed:@"Play-Pause" inBundle:[NSBundle bundleForClass:[self class]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  			[outputButton setImage:btnImage forState:UIControlStateNormal];
		} completion:^(BOOL completed) {

		}];
		// [self.view setNeedsLayout];
		// [self.view layoutIfNeeded];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.clipsToBounds = YES;
}

- (void)willBecomeActive {
	[self updateMedia];
}

- (void)willResignActive {
}

- (void)viewWillLayoutSubviews {
	if(_isExpanded){
		self.controlsView.view.frame = CGRectMake(0,108, self.view.frame.size.width, self.view.frame.size.height - 108);
		self.metadataView.frame = CGRectMake(0,0,self.view.frame.size.width, 108);

		self.controlsView.expanded = TRUE;
	} else {
		self.metadataView.frame = CGRectMake(0,self.view.frame.size.height*0.2135,self.view.frame.size.width, self.view.frame.size.height*0.392);
		self.controlsView.view.frame = CGRectMake(0,self.view.frame.size.height*0.2135 + self.view.frame.size.height*0.392, self.view.frame.size.width, self.view.frame.size.height*0.3268);

		self.controlsView.expanded = FALSE;
	}

}

- (CGFloat)preferredExpandedContentWidth {
	return [MZELayoutOptions defaultExpandedModuleWidth];
}

- (CGFloat)preferredExpandedContentHeight {
	if (!_prefferedContentExpandedHeight) {
		_interpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_interpolator addValue:403.5 forReferenceMetric:320];
		[_interpolator addValue:417.5 forReferenceMetric:375];
		[_interpolator addValue:455.5 forReferenceMetric:414];
		[_interpolator addValue:417.5 forReferenceMetric:1024];
		[_interpolator addValue:389.5 forReferenceMetric:736];
		[_interpolator addValue:361.5 forReferenceMetric:667];
		[_interpolator addValue:417.5 forReferenceMetric:768];
		[_interpolator addValue:455.5 forReferenceMetric:414];
		_prefferedContentExpandedHeight = [_interpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	return [_interpolator valueForReferenceMetric:[self rootViewFrame].size.width] - [_interpolator valueForReferenceMetric:[self rootViewFrame].size.width]/8;
}

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
	[_volumeHUDController setVolumeHUDEnabled:expanded == NO forCategory:@"Audio/Video"];
	_isExpanded = expanded;
	self.metadataView.expanded = expanded;
	self.controlsView.showRouting = NO;
	UIImage *btnImage = [[UIImage imageNamed:@"AirPlay" inBundle:[NSBundle bundleForClass:[self class]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  	[self.metadataView.outputButton.toggleButton setImage:btnImage forState:UIControlStateNormal];

  	if (expanded) {
  		[self.controlsView.routingView.routingViewController _beginRouteDiscovery];
  	} else {
  		[self.controlsView.routingView.routingViewController _endRouteDiscovery];
  	}

  	if (_controlsView) {
	  	if (_controlsView.progressView) {
			if (expanded) {
				[_nowPlayingController _startUpdatingTimeInformation];
			} else {
				[_nowPlayingController _stopUpdatingTimeInformation];
			}
		}
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.view setNeedsLayout];
		[self.view layoutIfNeeded];
        // do whatever
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (BOOL)providesOwnPlatter {
	return NO;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return NO;
}
-(void)updateMedia {
	[self.controlsView updateMediaForChangeOfMediaControlsStatus];
	[self.metadataView updateMediaForChangeOfMediaControlsStatus];

	if([_controlsView.progressView hasSong] == NO){
			self.controlsView.controlsView.skipButton.alpha = 0.16;
			self.controlsView.controlsView.rewindButton.alpha = 0.16;
			self.controlsView.hasTitles = FALSE;
	} else {
			self.controlsView.controlsView.skipButton.alpha = 0.8;
			self.controlsView.controlsView.rewindButton.alpha = 0.8;
			self.controlsView.hasTitles = TRUE;
	}
}

- (CGRect)rootViewFrame {
	SBControlCenterController *mainController = [NSClassFromString(@"SBControlCenterController") _sharedInstanceCreatingIfNeeded:YES];
	if (mainController && mainController.view) {
		return [mainController.view window].bounds;
	}
	return CGRectZero;
}


-(void)nowPlayingController:(MPUNowPlayingController *)controller nowPlayingInfoDidChange:(NSDictionary *)nowPlayingInfo {
	if (_controlsView) {
		if (_controlsView.progressView) {
			_controlsView.progressView.songDuration = [_nowPlayingController currentDuration];
			[_nowPlayingController _updateTimeInformationAndCallDelegate:YES];

			if([_controlsView.progressView hasSong] == NO){
				self.controlsView.controlsView.skipButton.alpha = 0.16;
				self.controlsView.controlsView.rewindButton.alpha = 0.16;
				self.controlsView.hasTitles = FALSE;
			} else {
				self.controlsView.controlsView.skipButton.alpha = 0.8;
				self.controlsView.controlsView.rewindButton.alpha = 0.8;
				self.controlsView.hasTitles = TRUE;
			}
			//[_controlsView.progressView startTimer];
		}
	}
}

-(void)nowPlayingController:(MPUNowPlayingController *)controller playbackStateDidChange:(BOOL)isPlaying {
	if (_controlsView) {
		if (_controlsView.controlsView) {
			[_controlsView.controlsView setIsPlaying:isPlaying];
		}

		// if(isPlaying) {

		// }

		if (_controlsView.progressView) {
			_controlsView.progressView.songDuration = [_nowPlayingController currentDuration];
			[_nowPlayingController _updateTimeInformationAndCallDelegate:YES];

			if (isPlaying) {
				[_nowPlayingController _startUpdatingTimeInformation];
			} else {
				[_nowPlayingController _stopUpdatingTimeInformation];
			}

			if([_controlsView.progressView hasSong] == NO){
				self.controlsView.controlsView.skipButton.alpha = 0.16;
				self.controlsView.controlsView.rewindButton.alpha = 0.16;
				self.controlsView.hasTitles = FALSE;
			} else {
				self.controlsView.controlsView.skipButton.alpha = 0.8;
				self.controlsView.controlsView.rewindButton.alpha = 0.8;
				self.controlsView.hasTitles = TRUE;
			}
			// if (isPlaying) {
			// 	[_controlsView.progressView startTimer];
			// } else {
			// 	[_controlsView.progressView stopTimer];
			// }
		}
	}
}

-(void)nowPlayingController:(MPUNowPlayingController *)controller nowPlayingApplicationDidChange:(id)nowPlayingApplication {
	if (_metadataView) {
		[self.metadataView nowPlayingAppDidChange];
	}

	if (_controlsView) {
		if (_controlsView.progressView) {
			_controlsView.progressView.songDuration = [_nowPlayingController currentDuration];
			[_nowPlayingController _updateTimeInformationAndCallDelegate:YES];

			if([_controlsView.progressView hasSong] == NO){
				self.controlsView.controlsView.skipButton.alpha = 0.16;
				self.controlsView.controlsView.rewindButton.alpha = 0.16;
				self.controlsView.hasTitles = FALSE;
			} else {
				self.controlsView.controlsView.skipButton.alpha = 0.8;
				self.controlsView.controlsView.rewindButton.alpha = 0.8;
				self.controlsView.hasTitles = TRUE;
			}
			//[_controlsView.progressView startTimer];
		}
	}
	//[self.metadataView nowPlayingAppDidChange];
}

-(void)nowPlayingControllerDidBeginListeningForNotifications:(MPUNowPlayingController *)controller {

}

-(void)nowPlayingControllerDidStopListeningForNotifications:(MPUNowPlayingController *)controller {

}

-(void)nowPlayingController:(MPUNowPlayingController *)controller elapsedTimeDidChange:(CGFloat)elapsedTime {
	if (_controlsView) {
		if (_controlsView.progressView) {
			[_controlsView.progressView updateTimeWithElapsedTime:(NSTimeInterval)elapsedTime];
		}
	}
}

@end
