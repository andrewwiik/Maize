#import "MZEModuleContainerViewController.h"
#import "MZELayoutOptions.h"

@implementation MZEModuleContainerViewController

- (id)initWithIdentifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		self.darkBackground = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
		self.lightBackground = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleLight];
		self.lightBackground.alpha = 0;
		_state = @"unlocked";
	}
	return self;
}

- (void)loadView {
	[super loadView];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.tag = 4510;
	self.previewInteraction = [[UIPreviewInteraction alloc] initWithView:self.view];
    self.previewInteraction.delegate = self;


	self.darkBackground.frame = CGRectMake(0,0,_compactModuleSize.size.width,_compactModuleSize.size.height);
	self.darkBackground.layer.cornerRadius = [self compactCornerRadius];
	self.darkBackground.clipsToBounds = YES;
	[self.view addSubview:self.darkBackground];

	self.lightBackground.frame = CGRectMake(0,0,_compactModuleSize.size.width,_compactModuleSize.size.height);
	self.lightBackground.layer.cornerRadius = [self compactCornerRadius];
	self.lightBackground.clipsToBounds = YES;
	[self.view addSubview:self.lightBackground];

	self.view.frame = _compactModuleSize;
 }

- (CGRect)expandedModuleBackgroundRect {
	return CGRectMake(27,125,321,417.5);
}

- (CGFloat)expandedModuleBackgroundCornerRadius {
	return 38.0f;
}

- (CGFloat)compactCornerRadius {
	return 19.0f;
}

- (CGFloat)expandedCornerRadius {
	return 38.0f;
}

- (void)setModulePosition:(CGRect)modulePosition {
	_modulePosition = modulePosition;

	CGFloat moduleSize = [MZELayoutOptions edgeSize];
    CGFloat moduleSpacing = [MZELayoutOptions itemSpacingSize];
    CGFloat edgeInset = [MZELayoutOptions edgeInsetSize];

	CGFloat w = _modulePosition.size.width;
	CGFloat h = _modulePosition.size.height;
	CGFloat x = _modulePosition.origin.x;
	CGFloat y = _modulePosition.origin.y;

	CGFloat xOrigin = edgeInset+(x*moduleSize)+(x*moduleSpacing);
    CGFloat yOrigin = 0 + (moduleSize*y) + (moduleSpacing*y);

    CGFloat height = (moduleSize*h)+(moduleSpacing*(h-1));
    CGFloat width = (moduleSize*w)+(moduleSpacing*(w-1));

    _compactModuleSize = CGRectMake(xOrigin, yOrigin,width,height);

    if (self.view) {
    	self.view.frame = _compactModuleSize;
    }

    if (self.darkBackground) {
    	self.darkBackground.frame = CGRectMake(0,0,_compactModuleSize.size.width,_compactModuleSize.size.height);
    }

    if (self.lightBackground) {
    	self.lightBackground.frame = CGRectMake(0,0,_compactModuleSize.size.width,_compactModuleSize.size.height);
    }

    if (w == 1 && h == 1 && (x == 0 || x == 1) && y == 2) {

    	if (x == 0) {
    		_onState = @"locked";
    		_offState = @"unlocked";
    		_moduleName = @"OrientationLock";
    	} else {
    		_onState = @"on";
    		_offState = @"off";
    		_moduleName = @"DoNotDisturb";
    	}

    	_state = _offState;
    	_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleState)];
    	[self.view addGestureRecognizer:_tapRecognizer];
    	_packageView = [[MZECAPackageView alloc] initWithFrame:self.darkBackground.frame];
    	NSURL *packageURL = [[NSBundle bundleWithPath:@"/Library/Application Support/Maize.bundle/"] URLForResource:_moduleName withExtension:@"ca"];
    	_packageView.package = [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
    	[self.view addSubview:_packageView];
    }

    [self.darkBackground setCompactCornerRadius:[self compactCornerRadius] expandedCornerRadius:[self expandedCornerRadius] compactSize:CGSizeMake(width,height) expandedSize:[self expandedModuleBackgroundRect].size];
}

- (void)toggleState {
	if (_packageView) {
		CGFloat alphaToTransition = 0.0;
		if ([_state isEqualToString:_offState]) {
			_state = _onState;
			alphaToTransition = 1.0;
		} else {
			_state = _offState;
		}

		// [CATransaction begin];
		// [CATransaction setDisableActions:NO];
  //       [CATransaction setAnimationDuration:2.0];
  //       [_packageView setStateName:_state];
  //       [CATransaction commit];
		[UIView animateWithDuration:0.25
                         animations:^{
                             [_packageView setStateName:_state];
                             self.lightBackground.alpha = alphaToTransition;
                         }
                         ];
	}
}

- (CGRect)modulePosition {
	return _modulePosition;
}

- (CGRect)compactModuleSize {
	return _compactModuleSize;
}

#pragma mark UIPreviewInteractioncollectionViewControllerMethods

-(BOOL)previewInteractionShouldBegin:(UIPreviewInteraction *)previewInteraction {

	BOOL shouldBegin = [self.collectionViewController previewInteractionShouldBegin:previewInteraction];

	if (shouldBegin) {
		self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveEaseIn animations:^{
			self.darkBackground.frame = [self expandedModuleBackgroundRect];
			self.darkBackground.layer.cornerRadius = [self expandedCornerRadius];
		}];
	}

	return shouldBegin;
}

-(void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction {

	if (self.animator) {
		[self.animator stopAnimation:NO];
		[self.animator finishAnimationAtPosition:UIViewAnimatingPositionStart];
		self.isExpanded = NO;
	}

	[self.collectionViewController previewInteractionDidCancel:previewInteraction];
}

-(void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdatePreviewTransition:(CGFloat)transitionProgress ended:(BOOL)ended {
	if (self.animator) {
		self.animator.fractionComplete = transitionProgress*1;
	}

	if (ended) {
		[self.animator stopAnimation:NO];
		[self.animator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
		self.isExpanded = YES;
	}

	[self.collectionViewController previewInteraction:previewInteraction didUpdatePreviewTransition:transitionProgress ended:ended]; 
}

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdateCommitTransition:(CGFloat)transitionProgress ended:(BOOL)ended {
	// if (self.animator) {
	// 	self.animator.fractionComplete = transitionProgress;
	// }

	// if (ended) {
	// 	[self.animator stopAnimation:NO];
	// 	[self.animator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
	// }

	[self.collectionViewController previewInteraction:previewInteraction didUpdateCommitTransition:transitionProgress ended:ended];

}

@end