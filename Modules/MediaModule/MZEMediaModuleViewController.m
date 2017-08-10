#import "MZEMediaModuleViewController.h"

@implementation MZEMediaModuleViewController

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	self = [super initWithNibName:arg1 bundle:arg2];
	if (self) {
		self.metadataView = [[NSClassFromString(@"MZEMediaMetaDataView") alloc] initWithFrame:self.view.bounds];
		[self.view addSubview:self.metadataView];

		self.controlsView = [[NSClassFromString(@"MPUControlCenterMediaControlsViewController") alloc] init];

		for(UIView *subview in self.controlsView.view.subviews){
			if([subview isKindOfClass:[NSClassFromString(@"MPUNowPlayingArtworkView") class]]){
					[subview removeFromSuperview];
			} else if([subview isKindOfClass:[NSClassFromString(@"MPUEmptyNowPlayingView") class]]){
					[subview removeFromSuperview];
			} else if([subview isKindOfClass:[NSClassFromString(@"MPUAVRouteHeaderView") class]]){
					[subview removeFromSuperview];
			} else if([subview isKindOfClass:[NSClassFromString(@"MPUControlCenterMetadataView") class]]){
					[subview removeFromSuperview];
			} else {
				[subview removeConstraints:subview.constraints];
			}
		}

		[[self.controlsView.view valueForKey:@"_timeView"] setAlpha:0];
		[[self.controlsView.view valueForKey:@"_volumeView"] setAlpha:0];

		self.controlsView.view.tag = 4123723;
		[self.view addSubview:self.controlsView.view];

		_isExpanded = NO;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.clipsToBounds = YES;
}

- (void)willBecomeActive {
}

- (void)willResignActive {
}

- (void)viewWillLayoutSubviews {
	if(_isExpanded){
		self.controlsView.view.frame = CGRectMake(0,self.view.frame.size.height/3.5, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.height/3.5);
		self.metadataView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height/3.5);
		[[self.controlsView.view valueForKey:@"_timeView"] setAlpha:1];
		[[self.controlsView.view valueForKey:@"_volumeView"] setAlpha:1];
	} else {
		[[self.controlsView.view valueForKey:@"_timeView"] setAlpha:0];
		[[self.controlsView.view valueForKey:@"_volumeView"] setAlpha:0];
		self.metadataView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height/2);
		self.controlsView.view.frame = CGRectMake(0,self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
	}
}

- (CGFloat)preferredExpandedContentWidth {
	CGSize containerSize = [[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:[UIDevice currentDevice].orientation].size;
	return [MZEMediaLayoutHelper widthForExpandedContainerWithContainerSize:containerSize defaultButtonSize:CGSizeMake(90,90)];
}

- (CGFloat)preferredExpandedContentHeight {
	if (!_prefferedContentExpandedHeight) {
		MPULayoutInterpolator *interpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[interpolator addValue:403.5 forReferenceMetric:320];
		[interpolator addValue:417.5 forReferenceMetric:375];
		[interpolator addValue:455.5 forReferenceMetric:414];
		_prefferedContentExpandedHeight = [interpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	return _prefferedContentExpandedHeight - _prefferedContentExpandedHeight/8;
}

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
	_isExpanded = expanded;
	self.metadataView.expanded = expanded;
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
@end
