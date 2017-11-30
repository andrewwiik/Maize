#import "MZEConnectivityModuleViewController.h"
#import "MZEConnectivityLayoutHelper.h"
#import <UIKit/UIScreen+Private.h>
#import "MZEConnectivityModuleView.h"
#import <SpringBoard/SBControlCenterController+Private.h>

@implementation MZEConnectivityModuleViewController

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	self = [super initWithNibName:arg1 bundle:arg2];
	if (self) {
		self.buttonViewControllers = [NSMutableArray new];
		for (NSString *className in [[self class] defaultButtonClasses]) {
			if ([NSClassFromString(className) isSupported]) {
				MZEConnectivityButtonViewController *buttonController = [self _makeButtonWithClass:NSClassFromString(className)];
				if (buttonController) {
					[_buttonViewControllers addObject:buttonController];
				}
			}
		}
		_isExpanded = NO;

		[self willTransitionToExpandedContentMode:NO];
	}
	return self;
}

- (void)loadView {
	self.containerView = [[MZEConnectivityModuleView alloc] initWithFrame:CGRectZero];
	self.containerView.layoutDelegate = self;
	self.view = self.containerView;

}

- (void)viewDidLoad {
	[super viewDidLoad];
	//self.view.clipsToBounds = YES;
	for (MZEConnectivityButtonViewController *buttonController in _buttonViewControllers) {
		[self.view addSubview:buttonController.view];
	}
	[self layoutButtons];
}

- (void)willBecomeActive {
	for (MZEConnectivityButtonViewController *buttonController in _buttonViewControllers) {
		[buttonController willBecomeActive];
	}
}

- (void)willResignActive {
	for (MZEConnectivityButtonViewController *buttonController in _buttonViewControllers) {
		[buttonController willResignActive];
	}
}

- (void)layoutButtons {
	NSUInteger colCount = [self numberOfColumns];
	//NSUInteger rowCount = [self numberOfRows];
	NSUInteger visibleColCount = [self visibleColumns];
	//NSUInteger visibleRowCount = [self visibleRows];

	if (_isExpanded) {

		CGRect bounds = self.view.bounds;
		NSUInteger cols = visibleColCount;
		NSUInteger rows = [self visibleRows];
		UIEdgeInsets edgeInsets = [MZEConnectivityLayoutHelper expandedLayoutInsetsForSize:bounds.size];
		CGSize buttonSize = [self _buttonSize];
		buttonSize.width = [MZEConnectivityLayoutHelper buttonWidthForInsets:edgeInsets containerSize:bounds.size numberOfColumns:cols];
		CGFloat spacingX = bounds.size.width - edgeInsets.left - edgeInsets.right - (buttonSize.width * cols);
		if (cols - 1 > 0) {
			spacingX = spacingX/(cols - 1);
		}

		CGFloat spacingY = bounds.size.height - edgeInsets.top - edgeInsets.bottom - (buttonSize.height * rows);
		if (rows - 1 > 0) {
			spacingY = spacingY/(rows - 1);
		}

		for (NSUInteger x = 0; x < [_buttonViewControllers count]; x++) {
			NSUInteger row = (x / colCount) + 1;
			NSUInteger col = (x % colCount) + 1;

			CGFloat xOrigin = edgeInsets.left + (spacingX * (col  - 1)) + (buttonSize.width * (col - 1));
			CGFloat yOrigin = edgeInsets.top + (spacingY * (row - 1)) + (buttonSize.height * (row - 1));
			_buttonViewControllers[x].view.frame = CGRectMake(xOrigin,yOrigin,buttonSize.width,buttonSize.height);

		}


	} else {

		UIEdgeInsets edgeInsets = [MZEConnectivityLayoutHelper compactLayoutInsets];
		CGSize buttonSize = [self _buttonSize];
		CGFloat spacing = roundf(self.view.bounds.size.width - (edgeInsets.left * (float)2.0) - (buttonSize.width * (float)visibleColCount - 1)/((float)visibleColCount - 1));
		for (NSUInteger x = 0; x < [_buttonViewControllers count]; x++) {
			NSUInteger row = (x / colCount) + 1;
			NSUInteger col = (x % colCount) + 1;

			CGFloat xOrigin = edgeInsets.left + (spacing * (col  - 1)) + (buttonSize.width * (col - 1));
			CGFloat yOrigin = edgeInsets.top + (spacing * (row - 1)) + (buttonSize.height * (row - 1));
			_buttonViewControllers[x].view.frame = CGRectMake(xOrigin,yOrigin,buttonSize.width,buttonSize.height);

		}
	}
}

- (void)viewWillLayoutSubviews {

	[super viewWillLayoutSubviews];
	[self layoutButtons];
}

- (CGFloat)preferredExpandedContentWidth {
	if (!_widthInterpolator) {
		_widthInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_widthInterpolator addValue:288 forReferenceMetric:320];
		[_widthInterpolator addValue:321 forReferenceMetric:375];
		[_widthInterpolator addValue:346 forReferenceMetric:414];
		[_widthInterpolator addValue:440 forReferenceMetric:568];
		[_widthInterpolator addValue:476 forReferenceMetric:667];
		[_widthInterpolator addValue:516 forReferenceMetric:736];
	}

	_prefferedContentExpandedWidth = [_widthInterpolator valueForReferenceMetric:[self rootViewFrame].size.width];
	return _prefferedContentExpandedWidth;
}

- (CGFloat)preferredExpandedContentHeight {
	if (!_heightInterpolator) {
		_heightInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_heightInterpolator addValue:410 forReferenceMetric:568];
		[_heightInterpolator addValue:446 forReferenceMetric:667];
		[_heightInterpolator addValue:468 forReferenceMetric:736];
		[_heightInterpolator addValue:222 forReferenceMetric:320];
		[_heightInterpolator addValue:302 forReferenceMetric:375];
		[_heightInterpolator addValue:335 forReferenceMetric:414];
	}

	_prefferedContentExpandedHeight = [_heightInterpolator valueForReferenceMetric:[self rootViewFrame].size.height];

	return _prefferedContentExpandedHeight;
}

- (CGRect)rootViewFrame {
	SBControlCenterController *mainController = [NSClassFromString(@"SBControlCenterController") _sharedInstanceCreatingIfNeeded:YES];
	if (mainController && mainController.view) {
		return [mainController.view window].bounds;
	}
	return CGRectZero;
}

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
	_isExpanded = expanded;
	if (expanded) self.view.clipsToBounds = YES;
	for (MZEConnectivityButtonViewController *buttonController in _buttonViewControllers) {
		[buttonController setLabelsVisible:expanded];
		[buttonController.view setAlpha:1.0];
		[buttonController moduleDidExpand:expanded];
	}

	for (NSUInteger x = (2*2); x < [_buttonViewControllers count]; x++) {
		_buttonViewControllers[x].view.alpha = _isExpanded ? 1.0 : 0.0;
	}
}

- (void)didTransitionToExpandedContentMode:(BOOL)expanded {
	if (expanded == NO) {
		self.view.clipsToBounds = NO;
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	HBLogInfo(@"DID CALL TRANSITITON TO SIZE IN CONNECTIVITY");
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.view layoutIfNeeded];
        // do whatever
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) { 

    }];
}

- (BOOL)providesOwnPlatter {
	return NO;
}


- (CGSize)_buttonSize {
	return [[_buttonViewControllers objectAtIndex:0].buttonContainer sizeThatFits:CGSizeZero];
}

- (NSUInteger)numberOfColumns {
	if (_isExpanded) {
		if (self.view.bounds.size.width > self.view.bounds.size.height) {
			return 3;
		}
	}
	return 2;
}

- (NSUInteger)numberOfRows {
	if (_isExpanded) {
		if (self.view.bounds.size.width > self.view.bounds.size.height) {
			return 2;
		}
	}
	return 3;
}

- (NSUInteger)visibleColumns {
	if (_isExpanded) {
		if (self.view.bounds.size.width > self.view.bounds.size.height) {
			return 3;
		}
	}
	return 2;
}
- (NSUInteger)visibleRows {
	if (_isExpanded) {
		if (self.view.bounds.size.width > self.view.bounds.size.height) {
			return 2;
		}
	}
	return 3;
}

// - (CGSize)preferredContentSize {
// 	if (_isExpanded) {

// 	}
// }



- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return NO;
}

- (MZEConnectivityButtonViewController *)_makeButtonWithClass:(Class)buttonClass {
	MZEConnectivityButtonViewController *controller = [[buttonClass alloc] init];
	if (controller) {
		controller.buttonDelegate = self;
		[self addChildViewController:controller];
		[controller didMoveToParentViewController:self];
		return controller;
	}
	return nil;
}

- (BOOL)canDismissPresentedContent {
	if (_presentedSecondaryViewController) {
		return NO;
	} else return YES;
}
- (void)dismissPresentedContent {
	if (_presentedSecondaryViewController) {
		[_presentedSecondaryViewController dismissViewControllerAnimated:YES completion:nil];
		_presentedSecondaryViewController = nil;
	}
}


- (void)buttonViewController:(MZEConnectivityButtonViewController *)buttonController willPresentSecondaryViewController:(UIViewController *)secondaryViewController {
	_presentedSecondaryViewController = secondaryViewController;
}

- (void)buttonViewController:(MZEConnectivityButtonViewController *)buttonController didDismissSecondaryViewController:(UIViewController *)secondaryViewController {
	if (secondaryViewController == _presentedSecondaryViewController) {
		_presentedSecondaryViewController = nil;
	}
}

+ (NSArray *)defaultButtonClasses {
	NSMutableArray *buttonClasses = [NSMutableArray new];
	[buttonClasses addObject:@"MZEConnectivityAirplaneViewController"];
	[buttonClasses addObject:@"MZEConnectivityCellularDataViewController"];
	[buttonClasses addObject:@"MZEConnectivityWiFiViewController"];
	[buttonClasses addObject:@"MZEConnectivityBluetoothViewController"];
	[buttonClasses addObject:@"MZEConnectivityAirDropViewController"];
	[buttonClasses addObject:@"MZEConnectivityHotspotViewController"];
	return [buttonClasses copy];
}
@end