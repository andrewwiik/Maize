#import "MZEConnectivityModuleViewController.h"
#import <MPUFoundation/MPULayoutInterpolator.h>
#import "MZEConnectivityLayoutHelper.h"
#import <UIKit/UIScreen+Private.h>


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
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.clipsToBounds = YES;
	for (MZEConnectivityButtonViewController *buttonController in _buttonViewControllers) {
		[self.view addSubview:buttonController.view];
	}
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

- (void)viewWillLayoutSubviews {

	NSUInteger colCount = [self numberOfColumns];
	//NSUInteger rowCount = [self numberOfRows];
	NSUInteger visibleColCount = [self visibleColumns];
	//NSUInteger visibleRowCount = [self visibleRows];

	if (_isExpanded) {

	} else {

		UIEdgeInsets edgeInsets = [MZEConnectivityLayoutHelper compactLayoutInsets];
		CGSize buttonSize = [self _buttonSize];
		CGFloat spacing = self.view.bounds.size.width - (edgeInsets.left * 2) - (buttonSize.width * visibleColCount - 1)/(visibleColCount - 1);
		for (NSUInteger x = 0; x < [_buttonViewControllers count]; x++) {
			NSUInteger row = (x / colCount) + 1;
			NSUInteger col = (x % colCount) + 1;

			CGFloat xOrigin = edgeInsets.left + (spacing * (col  - 1)) + (buttonSize.width * (col - 1));
			CGFloat yOrigin = edgeInsets.top + (spacing * (row - 1)) + (buttonSize.height * (row - 1));
			_buttonViewControllers[x].view.frame = CGRectMake(xOrigin,yOrigin,buttonSize.width,buttonSize.height);

		}
	}
}

- (CGFloat)preferredExpandedContentWidth {
	CGSize containerSize = [[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:[UIDevice currentDevice].orientation].size;
	return [MZEConnectivityLayoutHelper widthForExpandedContainerWithContainerSize:containerSize defaultButtonSize:[self _buttonSize]];
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
	for (MZEConnectivityButtonViewController *buttonController in _buttonViewControllers) {
		[buttonController setLabelsVisible:expanded];
		[buttonController.view setAlpha:1.0];
	}

	for (NSUInteger x = ([self visibleRows] * [self visibleColumns]); x < [_buttonViewControllers count]; x++) {
		_buttonViewControllers[x].view.alpha = _isExpanded ? 1.0 : 0.0;
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


- (CGSize)_buttonSize {
	return [[_buttonViewControllers objectAtIndex:0].buttonContainer sizeThatFits:CGSizeZero];
}

- (NSUInteger)numberOfColumns {
	return 2;
}

- (NSUInteger)numberOfRows {
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
		if (self.view.bounds.size.width < self.view.bounds.size.height) {
			return 3;
		}
	}
	return 2;
}



- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return NO;
}

- (MZEConnectivityButtonViewController *)_makeButtonWithClass:(Class)buttonClass {
	MZEConnectivityButtonViewController *controller = [[buttonClass alloc] init];
	if (controller) {
		[self addChildViewController:controller];
		[controller didMoveToParentViewController:self];
		return controller;
	}
	return nil;
}

+ (NSArray *)defaultButtonClasses {
	NSMutableArray *buttonClasses = [NSMutableArray new];
	[buttonClasses addObject:@"MZEConnectivityAirplaneViewController"];
	[buttonClasses addObject:@"MZEConnectivityCellularDataViewController"];
	[buttonClasses addObject:@"MZEConnectivityWifiViewController"];
	[buttonClasses addObject:@"MZEConnectivityBluetoothViewController"];
	return [buttonClasses copy];
}
@end