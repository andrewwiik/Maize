#import "MZEMediaModuleViewController.h"

@implementation MZEMediaModuleViewController

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	self = [super initWithNibName:arg1 bundle:arg2];
	if (self) {
		self.metadataView = [[NSClassFromString(@"MZEMediaMetaDataView") alloc] initWithFrame:self.view.bounds];
		[self.view addSubview:self.metadataView];
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
		self.metadataView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height/3);
	} else {
		self.metadataView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height/2);
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

	return _prefferedContentExpandedHeight;
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
