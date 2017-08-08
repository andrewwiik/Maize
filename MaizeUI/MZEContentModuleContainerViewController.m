#import "MZEContentModuleContainerViewController.h"
#import "MZELayoutOptions.h"
#import <UIKit/UIScreen+Private.h>
#import <QuartzCore/CALayer+Private.h>
#import "_MZEBackdropView.h"
#import "MZEExpandedModulePresentationTransition.h"
#import "MZEExpandedModulePresentationController.h"
#import "MZEExpandedModuleDismissTransition.h"
#import <UIKit/UIViewController+Window.h>
#import "macros.h"

@implementation MZEContentModuleContainerViewController
	@synthesize delegate=_delegate;

- (id)initWithModuleIdentifier:(NSString *)identifier contentModule:(id<MZEContentModule>)contentModule {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_moduleIdentifier = identifier;
		_contentModule = contentModule;
		_contentViewController = [_contentModule contentViewController];

		if ([_contentViewController respondsToSelector:@selector(providesOwnPlatter)]) {
			_contentModuleProvidesOwnPlatter = [_contentViewController providesOwnPlatter];	
		}

		if ([_contentModule respondsToSelector:@selector(backgroundViewController)]) {
			_backgroundViewController = [_contentModule backgroundViewController];
		}

		_didSendContentAppearanceCalls = NO;
    	_didSendContentDisappearanceCalls = NO;
    	_canBubble = YES;

		if ([self respondsToSelector:@selector(setTransitioningDelegate:)]) {
        	self.modalPresentationStyle = UIModalPresentationCustom;
			self.transitioningDelegate = self;
		}
	}
	return self;
}

- (id)init {
	[self doesNotRecognizeSelector:@selector(init)];
	return nil;
}

- (id)initWithCoder:(id)arg1 {
	[self doesNotRecognizeSelector:@selector(initWithCoder:)];
	return nil;
}

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	[self doesNotRecognizeSelector:@selector(initWithNibName:bundle:)];
	return nil;
}

- (void)closeModule {
	if ([_contentViewController respondsToSelector:@selector(canDismissPresentedContent)] && [_contentViewController canDismissPresentedContent]) {
		if (![_contentViewController respondsToSelector:@selector(dismissPresentedContent)]) {
			return;
		}
		[_contentViewController dismissPresentedContent];
	} else {
		[self.previewInteraction cancelInteraction];
	}
	[_delegate contentModuleContainerViewController:self closeExpandedModule:_contentModule];
}

- (MZEContentModuleContainerView *)moduleContainerView {
	return (MZEContentModuleContainerView *)self.view;
}

- (void)willBecomeActive {
	if ([_contentViewController respondsToSelector:@selector(willBecomeActive)]) {
		[_contentViewController willBecomeActive];
		//self.view.backgroundColor = [UIColor redColor];
	} else {
		if ([_contentViewController respondsToSelector:@selector(controlCenterWillPresent)]) {
			[_contentViewController controlCenterWillPresent];
		}
	}
}

- (void)willResignActive {
	if ([self isExpanded]) {
		[self closeModule];
	}
	if ([_contentViewController respondsToSelector:@selector(willResignActive)]) {
		[_contentViewController willResignActive];
	} else {
		if ([_contentViewController respondsToSelector:@selector(controlCenterDidDismiss)]) {
			[_contentViewController controlCenterDidDismiss];
		}
	}
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return NO;
}

- (void)viewDidAppear:(BOOL)didAppear {
	[super viewDidAppear:didAppear];
	if (_didSendContentAppearanceCalls == NO) {
		_originalParentViewController = [self parentViewController];
		_didSendContentAppearanceCalls = YES;
		[_contentViewController beginAppearanceTransition:YES animated:didAppear];
		[_contentViewController endAppearanceTransition];
	}
}

- (void)viewWillMoveToWindow:(UIWindow *)window {
	[super viewWillMoveToWindow:window];
	if (window || [self parentViewController] != _originalParentViewController) {

	} else {
		if (!_didSendContentDisappearanceCalls) {
			_didSendContentDisappearanceCalls = YES;
			[_contentViewController beginAppearanceTransition:NO animated:NO];
			[_contentViewController endAppearanceTransition];
		}
	}
}

- (void)loadView {

	MZEContentModuleContainerView *containerView = [[MZEContentModuleContainerView alloc] initWithModuleIdentifier:self.moduleIdentifier];
	self.view = containerView;
	containerView.viewDelegate = self;

	CGRect frame = CGRectZero;
	if (containerView)
		frame = containerView.bounds;

	_highlightWrapperView = [[UIView alloc] initWithFrame:frame];
	_highlightWrapperView.backgroundColor = [UIColor clearColor];
	_highlightWrapperView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[containerView addSubview:_highlightWrapperView];

	_backgroundView = [[MZEContentModuleBackgroundView alloc] init];
	_backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                           UIViewAutoresizingFlexibleHeight);
	frame = CGRectZero;
	[_highlightWrapperView addSubview:_backgroundView];

	_contentContainerView = [[MZEContentModuleContentContainerView alloc] init];
	[_contentContainerView setModuleProvidesOwnPlatter:_contentModuleProvidesOwnPlatter];

	frame = CGRectZero;
	if (containerView)
		frame = containerView.bounds;

	[_contentContainerView setFrame:frame];
	[_contentContainerView setClipsContentInCompactMode:NO];
	[self _configureForContentModuleGroupRenderingIfNecessary];

	[_highlightWrapperView addSubview:_contentContainerView];
	_contentView = _contentViewController.view;

	[_contentView setAutoresizingMask:18];

	frame = CGRectZero;
	if (_contentContainerView)
		frame = _contentContainerView.bounds;

	[_contentView setFrame:frame];

	[_contentContainerView addSubview:_contentView];
	[self addChildViewController:_contentViewController];
	[_contentViewController didMoveToParentViewController:self];


	//_contentView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

	if (_backgroundViewController) {
		_backgroundViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[_backgroundView addSubview:_backgroundViewController.view];
	}

	_previewInteraction = [[UIPreviewInteraction alloc] initWithView:self.view];
	_previewInteraction.delegate = self;
	_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGestureRecognizer:)];
	_tapRecognizer.delegate = self;
	[_backgroundView addGestureRecognizer:_tapRecognizer];

	_breatheRecognizer = [[MZEBreatheGestureRecognizer alloc] initWithTarget:self action:@selector(handelBubbleGestureRecognizer:)];
	_breatheRecognizer.minimumPressDuration = 0;
	_breatheRecognizer.numberOfTouchesRequired = 1;
	_breatheRecognizer.allowableMovement = 10.0;
	_breatheRecognizer.delegate = self;


	[_breatheRecognizer setCancelsTouchesInView:NO];
	_breatheRecognizer.delaysTouchesEnded = NO;
	[self.view addGestureRecognizer:_breatheRecognizer];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {        
    return YES;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	if ([self isExpanded]) {
		_highlightWrapperView.frame = [self _backgroundFrameForExpandedState];
		_backgroundView.frame = [self _backgroundFrameForExpandedState];
		_contentContainerView.frame = [self _contentFrameForExpandedState];
	} else {
		CGRect frame = CGRectZero;
		if (self.view)
			frame = self.view.bounds;

		_highlightWrapperView.frame = frame;
		_backgroundView.frame = frame;
		_contentContainerView.frame = frame;
	}

	if ([_contentViewController respondsToSelector:@selector(punchOutRootLayer)]) {

		if (!_maskView && _contentContainerView && _contentContainerView.moduleMaterialView) {
			self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
            [_maskView setAutoresizingMask:18];
            _maskView.backgroundColor = [UIColor clearColor];

            UIView *cutoutView = [[UIView alloc] initWithFrame:self.view.bounds];
            [cutoutView setAutoresizingMask:18];
            cutoutView.backgroundColor = [UIColor blackColor];
            [_maskView addSubview:cutoutView];

            _contentContainerView.moduleMaterialView.backdropView.maskView = _maskView;
		}

		if (_maskView && (!_maskLayer || [_contentViewController punchOutRootLayer] != _maskLayer)) {
			if (_maskLayer) {
				[_maskLayer removeFromSuperlayer];
			}

			self.maskLayer = [_contentViewController punchOutRootLayer];
			_maskLayer.compositingFilter = @"destOut";

			[((UIView *)[_maskView subviews][0]).layer addSublayer:_maskLayer];
		}

		if (_maskView) {
			_maskView.frame = _contentContainerView.bounds;
		}
		// if (!_maskView || [_contentViewController punchOutRootLayer] != _maskLayer || !_maskView) {
		// 	if (_maskLayer) {
		// 		[_maskLayer removeFromSuperlayer];
		// 	}
		// 	_maskLayer = nil;
		// 	if (_contentContainerView && _contentContainerView.moduleMaterialView) {
		// 		if ([[_contentContainerView.layer sublayers] count] > 0) {
		// 			_maskLayer = [_contentViewController punchOutRootLayer];
		// 			[_contentContainerView.layer insertSublayer:_maskLayer atIndex:1];
		// 		} else {

		// 		}
		// 	}


			// UIView *maskThing = [[UIView alloc] init];
			// maskThing.frame = self.view.bounds;
			// maskThing.backgroundColor = [UIColor clearColor];
			// _maskView = maskThing;
			// _maskView = [[_MZEBack alloc] initWithFrame:self.view.bounds];
			// _maskView.backgroundColor = [UIColor clearColor];


			// UIView *otherMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
			// otherMaskView.backgroundColor = [UIColor clearColor];


			// UIView *_maskView2 = [[UIView alloc] initWithFrame:self.view.bounds];
			// _maskView2.backgroundColor = [UIColor blackColor];
			// [_maskView2 setAutoresizingMask:18];
			// [otherMaskView addSubview:_maskView2];

			// [_contentViewController punchOutRootLayer].compositingFilter = @"destOut";
			// [_maskView2.layer addSublayer:[_contentViewController punchOutRootLayer]];
			// [_maskView2.layer setAllowsGroupBlending:NO];
			//[self.view addSubview:_maskView];

			// _otherMaskView = otherMaskView;
			// [self.view addSubview:maskThing];
			// maskThing.maskView = _otherMaskView;
			// _maskView = maskThing;
			//[self.view sendSubviewToBack:_maskView];
			//_maskView2.backgroundColor = [UIColor blackColor];
			//_maskView2.layer.fillRule = kCAFillRuleEvenOdd;
			//_maskView.layer.fillRule = kCAFillRuleEvenOdd;
			//self.view.maskView = _maskView;
			//_contentContainerView.moduleMaterialView.maskView = _maskView;
			//[self.view addSubview:_maskView];

			//_contentContainerView.maskView = _maskView;
			// [_contentViewController punchOutRootLayer].compositingFilter = @"destOut";
			// [_maskView.layer addSublayer:[_contentViewController punchOutRootLayer]];
			// _maskView.backgroundColor = [UIColor blackColor];
			// //_maskView.hidden = YES;
			// //_maskView.layer.mask = [_contentViewController punchOutRootLayer];
			// //_maskView.layer.compositingFilter = @"destOut";
			// [_maskView.layer setAllowsGroupBlending:NO];
			//_maskView.userInteractionEnabled = NO;
			// _contentContainerView.maskView = _maskView;
		// }
	}
}

- (void)setAlpha:(CGFloat)alpha {
	if (_contentViewController) {
		_contentViewController.view.alpha = alpha;
	}

	if (_maskView) {
		_maskView.alpha = alpha;
	}
}

- (BOOL)previewInteractionShouldBegin:(UIPreviewInteraction *)previewInteraction {
	if ([self isExpanded]) {
		return NO;
	} else {
		[_delegate contentModuleContainerViewController:self didBeginInteractionWithModule:_contentModule];
		return YES;
	}
}

- (BOOL)_previewInteractionShouldFinishTransitionToPreview:(id)arg1 {
	if ([_contentViewController respondsToSelector:@selector(shouldBeginTransitionToExpandedContentModule)] && ![_contentViewController shouldBeginTransitionToExpandedContentModule]) {
		return NO;
	} else return YES;
}

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdatePreviewTransition:(CGFloat)progress ended:(BOOL)ended {
	if (!ended) {
		[UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
			self.view.transform = CGAffineTransformMakeScale(progress * (0.25 - (_bubbled ? 0.05 : 0)) + 1.0 + (_bubbled ? 0.05 : 0),progress * (0.25 - (_bubbled ? 0.05 : 0)) + 1.0 + (_bubbled ? 0.05 : 0));
		} completion:nil];
	}

	if (ended) {
		_bubbled = NO;
		[_delegate contentModuleContainerViewController:self openExpandedModule:_contentModule];
		[UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
			self.view.transform = CGAffineTransformIdentity;
		} completion:^(BOOL completed) {
		}];
	}
	return;
}

- (void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction {
	_bubbled = NO;
	[UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		self.view.transform = CGAffineTransformIdentity;
	} completion:nil];
	[_delegate contentModuleContainerViewController:self didFinishInteractionWithModule:_contentModule];
}


- (void)_handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
	if ([self isExpanded]) {
		if (recognizer.state == 3) {
			[self closeModule];
		}
	}
}

- (CGRect)_contentFrameForRestState {
	if (_delegate) {
		CGRect frame = [_delegate compactModeFrameForContentModuleContainerViewController:self];
		frame.origin = CGPointZero;
		return frame;
	} else return CGRectZero;
}

- (CGRect)_contentFrameForExpandedState {
	CGRect expandedFrame = CGRectZero;
	expandedFrame.size.width = [MZELayoutOptions defaultExpandedContentModuleWidth];
	if ([_contentViewController respondsToSelector:@selector(preferredExpandedContentWidth)]) {
		expandedFrame.size.width = [_contentViewController preferredExpandedContentWidth];
	}

	expandedFrame.size.height = [_contentViewController preferredExpandedContentHeight];
	CGPoint center = UIRectGetCenter([self _backgroundFrameForExpandedState]);
	expandedFrame.origin.x = center.x - (expandedFrame.size.width*0.5);
	expandedFrame.origin.y = center.y - (expandedFrame.size.height*0.5);
	return expandedFrame;
}

- (CGRect)_backgroundFrameForRestState {
	return [self _contentFrameForRestState];
}

- (CGRect)_backgroundFrameForExpandedState {
	if ([_delegate isLandscape]) {
		return [[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
	} else return [[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:UIInterfaceOrientationPortrait];
}

- (CGRect)_contentBoundsForTransitionProgress:(CGFloat)progress {
	CGRect frame = CGRectZero;
	CGFloat multiplier = progress * 0.25 + 1.0;
	CGRect restFrame = [self _contentFrameForRestState];
	frame.size.width = restFrame.size.width * multiplier;
	frame.size.height = restFrame.size.height * multiplier;
	return frame;
}

- (void)_configureMaskViewIfNecessary {
	return;
}

- (void)_configureForContentModuleGroupRenderingIfNecessary {
	return;
}

- (void)handelBubbleGestureRecognizer:(MZEBreatheGestureRecognizer *)recognizer {
	if (![self isExpanded]) {
		switch (recognizer.state) {
	        case UIGestureRecognizerStateBegan: {
	        	_bubbled = YES;
	            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
					self.view.transform = CGAffineTransformMakeScale(1.05,1.05);
				} completion:nil];
	            break;
	        }

	        case UIGestureRecognizerStateCancelled:
	        case UIGestureRecognizerStateFailed:
	        case UIGestureRecognizerStateEnded: {
	        	_bubbled = NO;
	        	[UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
					self.view.transform = CGAffineTransformIdentity;
				} completion:nil];
	            // do something
	            break;
	        }
	        default: {
	    //     	if (_bubbled) {
	    //     		_bubbled = NO;
	    //     		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
					// 	self.view.transform = CGAffineTransformIdentity;
					// } completion:nil];
	    //     	}
            	break;
	        }
	    }
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	//[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	if (size.height == [self _backgroundFrameForExpandedState].size.height) {
		CGSize expandedContentSize = [self _contentFrameForExpandedState].size;
		[_contentViewController viewWillTransitionToSize:expandedContentSize withTransitionCoordinator:coordinator];
		[_backgroundViewController viewWillTransitionToSize:[self _backgroundFrameForExpandedState].size withTransitionCoordinator:coordinator];
	} else {
		CGSize compactContentSize = [self _contentFrameForExpandedState].size;
		[_contentViewController viewWillTransitionToSize:compactContentSize withTransitionCoordinator:coordinator];
		[_backgroundViewController viewWillTransitionToSize:[self _backgroundFrameForRestState].size withTransitionCoordinator:coordinator];
	}
	// if ([_contentViewController respondsToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) {
	// 	[_contentViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	// }
	// [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
} 

// - (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
// 	if (container == _contentViewController) {
// 		if ([self isExpanded]) {
// 			return [self _contentFrameForExpandedState].size;
// 		} else {
// 			return [self _contentFrameForRestState].size;
// 		}
// 	} else {
// 		return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
// 	}
// }

// - (CGSize)preferredContentSize {
// 	if ([self isExpanded]) {
// 		return [self _contentFrameForExpandedState].size;
// 	} else {
// 		return [self _contentFrameForRestState].size;
// 	}
// }

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	return [[MZEExpandedModulePresentationTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
   return [[MZEExpandedModuleDismissTransition alloc] init];
}

// show the proxy method of the view
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
   return [[MZEExpandedModulePresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}

// -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
// 	HBLogInfo(@"STARTED TOYCHING THINGY");
// 	if (![self isExpanded]) {
// 		UITouch *touch = [[event allTouches] anyObject];
//     	CGPoint touchLocation = [touch locationInView:self.view];
//     	_firstX = touchLocation.x;
//     	_firstY = touchLocation.y;
//     	if (CGAffineTransformEqualToTransform(self.view.transform,CGAffineTransformMakeScale(1.05,1.05))) {
// 			//self.view.transform = CGAffineTransformIdentity;
//     	}
// 		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
// 			self.view.transform = CGAffineTransformMakeScale(1.05,1.05);
// 		} completion:nil];
// 	}
// }

// -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
// 	if (![self isExpanded] && _canBubble && _firstX != -1 && _firstY != 1) {
// 		UITouch *touch = [[event allTouches] anyObject];
//     	CGPoint touchLocation = [touch locationInView:self.view];
//     	if ((_firstX - touchLocation.x >= 10 || _firstX - touchLocation.x <= -10) || (_firstY - touchLocation.y >= 10 || _firstY - touchLocation.y <= -10)) {
//     		_canBubble = NO;
//     		_firstX = 0;
//     		_firstY = 0;
//     		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
// 				self.view.transform = CGAffineTransformIdentity;
// 			} completion:nil];
//     	}
// 	}
// }

// -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
// 	_firstY = -1;
// 	_firstX = -1;
// 	if (![self isExpanded] && _canBubble) {
// 		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
// 			self.view.transform = CGAffineTransformIdentity;
// 		} completion:nil];
// 	}
// 	_canBubble = YES;
// }
@end