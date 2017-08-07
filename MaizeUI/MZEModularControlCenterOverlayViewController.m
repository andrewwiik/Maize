#import "MZEModularControlCenterOverlayViewController.h"
#import "macros.h"

@implementation MZEModularControlCenterOverlayViewController

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_cachedTargetPresentationFrame = CGRectNull;
		_cachedSourcePresentationFrame = CGRectNull;
		_presentationState = MZEPresentationStateDismissed;
	}
	return self;
}

- (void)viewDidLoad {
	_backgroundView = [[MZEBackgroundView alloc] initWithFrame:[self bounds]];
	_backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	[self.view addSubview:_backgroundView]

	_scrollView = [[MZEScrollView alloc] init];
    [_scrollView setDelegate:self];
    [_scrollView setClipsToBounds:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:_scrollView];

    _headerPocketView = [[MZEHeaderPocketView alloc] init];
    [self.view addSubview:_headerPocketView];

    [super viewDidLoad];

	_headerPocketViewDismissalPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleControlCenterDismissalPanGesture:)];
	[_headerPocketViewDismissalPanGesture setDelegate:self];
	[_headerPocketView addGestureRecognizer:_headerPocketViewDismissalPanGesture];

	_headerPocketViewDismissalTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleControlCenterDismissalTapGesture:)];
	[_headerPocketViewDismissalTapGesture setDelegate:self];
	[_headerPocketView addGestureRecognizer:_headerPocketViewDismissalTapGesture];

	_collectionViewDismissalPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleControlCenterDismissalPanGesture:)];
	[_collectionViewDismissalPanGesture setDelegate:self];
	[_scrollView addGestureRecognizer:_collectionViewDismissalPanGesture];

	_collectionViewDismissalTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleControlCenterDismissalTapGesture:)];
	[_collectionViewDismissalTapGesture setDelegate:self];
	[_scrollView addGestureRecognizer:_collectionViewDismissalTapGesture];

	_collectionViewScrollPanGesture = [_scrollView panGestureRecognizer];
	[_collectionViewScrollPanGesture requireGestureRecognizerToFail:_collectionViewDismissalPanGesture];
}

- (void)viewWillLayoutSubviews {

	[self _makePresentationFramesDirty];
	[super viewWillLayoutSubviews];

	CGRect targetFrame = [self _targetPresentationFrame];
	CGRect bounds = [self.view bounds];
	_backgroundView.frame = bounds;
	_scrollView.frame = bounds;

	CGRect collectionViewFrame = self.moduleCollectionViewController.moduleCollectionView.frame;
	CGSize preferredContentSize = [self.moduleCollectionViewController preferredContentSize];
	CGFloat maxHeight = CGRectGetMinY(targetFrame) + preferredContentSize.height;
	[self.moduleCollectionViewController.moduleCollectionView setSize:preferredContentSize];
	_scrollView.contentSize = CGSizeMake(maxHeight, preferredContentSize.width);
	[self _setCollectionViewOriginYUpdatingRevealPercentage:collectionViewFrame.origin.y];
	[self.moduleCollectionViewController.moduleCollectionView setNeedsLayout];
	[_headerPocketView setNeedsLayout];
	[self _updateHotPocketAnimated:NO];
}

- (void)presentAnimated:(BOOL)animated withCompletionHandler:(id)completionHandler {
	if (animated) {
		[UIView animateWithDuration:1.0f animations:^{
			[self updatePresentationForRevealPercentage:1.0f];
		} completion:completionHandler];
	} else {
		[UIView performWithoutAnimation:^{
			[self updatePresentationForRevealPercentage:1.0f];
		}];
	}
}

- (void)dismissAnimated:(BOOL)animated withCompletionHandler:(id)completionHandler {
	if (animated) {
		[UIView animateWithDuration:1.0f animations:^{
			[self updatePresentationForRevealPercentage:0.0f];
		} completion:completionHandler];
	} else {
		[UIView performWithoutAnimation:^{
			[self updatePresentationForRevealPercentage:0.0f];
		}];
	}
}

- (void)revealWithProgress:(CGFloat)progress {
	[self updatePresentationForRevealPercentage:progress];
}

- (void)updatePresentationForRevealPercentage:(CGFloat)percentage {
	if ([self presentationState] != MZEPresentationStatePresented && [self presentationState] != MZEPresentationStateTransitioning) {
		self.presentationState = percentage >= 1 ? MZEPresentationStatePresented : MZEPresentationStateTransitioning;
	}

	if ([self presentationState] == MZEPresentationStatePresented) {
		[UIView animateWithDuration:]
		[self _beginPresentationAnimated:YES]
	}

	CGFloat sourceYOrigin = [self _sourcePresentationFrame].origin.y;
	CGFloat yOrigin = sourceYOrigin - (sourceYOrigin - [self _targetPresentationFrame].origin.y)*percentage;
	[self _animateSetCollectionViewOriginYUpdatingRevealPercentage:yOrigin];
}

- (CGFloat)_presentationGestureActivationMinimumYOffset {
	return [self _targetPresentationFrame].origin.y * 0.75;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self _updateHotPocketAnimated:YES];
}

- (BOOL)scrollView:(MZEScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer != _collectionViewScrollPanGesture) {
		return YES;
	} else {
		return [self _allowScrollWithPanGesture:gestureRecognizer];
	}
}

- (BOOL)_allowScrollWithPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
	if ([self presentationState] != MZEPresentationStateUnknown && [self presentationState] != MZEPresentationStateTransitioning) {
		if ([self _interfaceOrientation] <= 2) {
			CGPoint point = [gestureRecognizer locationInView:_scrollView];
			UIView *hitView = [_scrollView hitTest:point withEvent:nil];
            return [hitView isExclusiveTouch] == NO;
		}
		return YES;
	}
	return NO;
}

#pragma mark Dismissal Gesture

- (void)_handleControlCenterDismissalPanGesture:(UIPanGestureRecognizer *)recognizer {
	switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
        	[self _beginDismissalWithPanGesture:recognizer];
            break;
        }
        case UIGestureRecognizerStateChanged: {
        	[self _updateDismissalWithPanGesture:recognizer]
            break;
        }
        case UIGestureRecognizerStateEnded: {
        	[self _endDismissalWithPanGesture:recognizer];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
        	[self _cancelDismissalWithPanGesture:recognizer];
            break;
        }
        default: {

        	break;
        }
    }
}

- (void)_beginDismissal {
	if ([self presentationState] != MZEPresentationStateTransitioning) {
		self.presentationState = MZEPresentationStateTransitioning;
	}
}

- (void)_beginDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture {
	[self _beginDismissal];
	_dismissalGestureYOffset = [gesture locationInView:self.view].y;

	[self _updateDismissalWithPanGesture:gesture];
}
- (void)_updateDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture {
	CGFloat locY = [gesture locationInView:self.view].y;
	CGFloat offset = locY - _dismissalGestureYOffset;
	CGFloat presentMinY = CGRectGetMinY([self _targetPresentationFrame]);
	[self _animateSetCollectionViewOriginYUpdatingRevealPercentage:offset+presentMinY];

}

- (void)_endDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture {
	CGFloat locY = [gesture locationInView:self.view].y;
	CGPoint velocity = [gesture velocityInView:self.view];
	BOOL dismiss = NO;

	if (velocity.y > 0) {
		CGFloat offset = locY - _dismissalGestureYOffset;
		dismiss = offset > [self _dismissalGestureActivationMinimumYOffset];
	} else {
		dismiss = locY > 0;
	}

	if (dismiss) {
		[self dismissAnimated:YES withCompletionHandler:nil];
	} else {
		[self presentAnimated:YES withCompletionHandler:nil];
	}
	
}

- (void)_cancelDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture {

}

- (void)_beginPresentationAnimated:(BOOL)animated {
	if ([self presentationState] != MZEPresentationStatePresented) {
		self.view.hidden = NO;

		if ([self presentationState] != MZEPresentationStateDismissed) {
			[self setPresentationState:MZEPresentationStatePresented];
		} else {
			[self _setCollectionViewOriginYUpdatingRevealPercentage:CGRectGetMinY([self _sourcePresentationFrame])];
			_backgroundView.effectProgress = 1.0;
		}
	}
}

- (void)_updateHotPocketAnimated:(BOOL)animated {
	CGFloat alpha = 0;
	if (_scrollView.contentOffset > 0)
		alpha = 1;

	if (animated) {
		[UIView animateWithDuration:0.4f animations:^{
			_headerPocketView.backgroundAlpha = alpha;
		} completion:nil];
	} else {
		[UIView performWithoutAnimation:^{
			_headerPocketView.backgroundAlpha = alpha;
		}];
	}
}

- (UIView *)_moduleCollectionViewContainerView {
	return _scrollView;
}

- (void)_makePresentationFramesDirty {
	_cachedSourcePresentationFrame = CGRectNull;
	_cachedTargetPresentationFrame = CGRectNull;
}

- (void)_animateSetCollectionViewOriginYUpdatingRevealPercentage:(CGFloat)percentage {
	[UIView animateWithDuration:0.05 animations:^{
		[self _setCollectionViewOriginYUpdatingRevealPercentage:percentage];
	} completion:nil];
}

- (void)_setCollectionViewOriginYUpdatingRevealPercentage:(CGFloat)yOrigin {
	CGRect sourceFrame = [self _sourcePresentationFrame];
	CGRect targetFrame = [self _targetPresentationFrame];

	CGFloat sourceMinY = CGRectGetMinY(sourceFrame);

	[self _setCollectionViewOriginY:yOrigin revealPercentage:(yOrigin - sourceMinY)/(CGRectGetMinY(targetFrame) - sourceMinY)];
}

- (void)_setCollectionViewOriginY:(CGFloat)yOrigin revealPercentage:(CGFloat)percentage {
	CGRect targetFrame = [self _targetPresentationFrame];
	CGFloat xOrigin = CGRectGetMinX(targetFrame);
	[self _setCollectionViewOriginAccountingForContentInset:CGPointMake(xOrigin, yOrigin)];
	[_setPocketViewOriginFromCollectionOriginY:yOrigin revealPercentage:percentage];
	_backgroundView.effectProgress = fmaxf(fminf(percentage, 1.0), 0.0);
	// Not gonna implement a delegate method we aren't going to actually use;
}

- (void)_setPocketViewOriginFromCollectionOriginY:(CGFloat)yOrigin revealPercentage:(CGFloat)revealPercentage {

	CGRect targetFrame = [self _targetPresentationFrame];

	CGRect headerPocketSize = [_headerPocketView sizeThatFits:CGSizeMake(CGRectGetWidth(targetFrame),0.0f)];
	CGPoint headerPocketOrigin = CGPointMake(0,yOrigin - headerPocketSize.height);
	_headerPocketView.frame = CGRectMake(headerPocketOrigin.x,headerPocketOrigin.y,headerPocketSize.width,headerPocketSize.height);
	CGFloat alpha = fminf(fmaxf((revealPercentage + -0.88) / 0.07, 0.0), 1.0);
	_headerPocketView.alpha = alpha;
	[_headerPocketView setChevronPointingDown: alpha > 0.95];
}

- (void)_setCollectionViewOriginAccountingForContentInset:(CGPoint)origin {
	CGPoint contentOffset = _scrollView.contentOffset;
	[_scrollView setContentOffset:CGPointZero animated:NO];
	CGRect collectionViewBounds = CGRectZero;
	if (self.moduleCollectionViewController.view)
		collectionViewBounds = self.moduleCollectionViewController.view.bounds;

	collectionViewBounds.origin = origin;

	self.moduleCollectionViewController.view.frame = collectionViewBounds;
}

- (CGRect)_sourcePresentationFrame {
	CGRect cachedFrame = _cachedSourcePresentationFrame;
	if (CGRectIsNull(cachedFrame)) {
		CGRect targetFrame = [self _targetPresentationFrame];
		targetFrame.origin.y = CGRectGetMaxY(targetFrame);
		cachedFrame = targetFrame;
		_cachedSourcePresentationFrame = cachedFrame;
	}
	return cachedFrame;
}

- (CGRect)_targetPresentationFrame {
	CGRect cachedFrame = _cachedTargetPresentationFrame;
	if (CGRectIsNull(cachedFrame)) {
		cachedFrame = CGRectZero;
		CGRect bounds = CGRectZero;
		if (self.view) {
			bounds = self.view.bounds;
		}

		NSInteger orientationSwitch = [self _interfaceOrientation] - 1;
		MZEModuleCollectionViewController *collectionController = [[self class] sharedCollectionViewController];
		CGSize collectionViewSize = [collectionController preferredContentSize];
		CGFloat collectionViewHeight = collectionViewSize.height;

		if (![self isLandscape]) {
			CGFloat boundsHeight = CGRectGetHeight(bounds);
			CGFloat pocketViewHeight = [_headerPocketView intrinsicContentSize].height;
			CGFloat maxHeight = boundsHeight - pocketViewHeight;
			CGFloat yOrigin = boundsHeight - collectionViewHeight;
			if (collectionViewHeight > maxHeight) {
				yOrigin = pocketViewHeight;
			}
			cachedFrame = CGRectMake(0,yOrigin, collectionViewHeight, CGRectGetWidth(bounds));
		} else {
			CGFloat yOrigin = CGRectGetMidY(bounds) - (collectionViewHeight*0.5);
			cachedFrame = CGRectMake(0,yOrigin, collectionViewHeight, CGRectGetWidth(bounds));
		}
		_cachedTargetPresentationFrame = cachedFrame;


	}
	return cachedFrame;
}
// CGRectIsNull
@end