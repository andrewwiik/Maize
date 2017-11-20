#import "MZEContentModuleContainerViewController.h"
#import "MZELayoutOptions.h"
#import <UIKit/UIScreen+Private.h>
#import <QuartzCore/CALayer+Private.h>
#import "_MZEBackdropView.h"
#import "MZEExpandedModulePresentationTransition.h"
#import "MZEExpandedModulePresentationController.h"
#import "MZEExpandedModuleDismissTransition.h"
#import <UIKit/UIViewController+Window.h>
#import <UIKit/UIPanGestureRecognizer+Private.h>
#import "macros.h"

//static BOOL forceTouchIsSupported;

static BOOL isIOS11Mode = YES;

@implementation MZEContentModuleContainerViewController
	@synthesize delegate=_delegate;

- (id)initWithModuleIdentifier:(NSString *)identifier contentModule:(id<MZEContentModule>)contentModule {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_moduleIdentifier = identifier;
		_psuedoView = [[MZEPsuedoModuleView alloc] initWithIdentifier:_moduleIdentifier];
		_contentModule = contentModule;
		_contentViewController = [_contentModule contentViewController];

		if (!_contentViewController) return nil;

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

- (BOOL)closeModule {
	if ([_contentViewController respondsToSelector:@selector(canDismissPresentedContent)] && [self isExpanded]) {
		if ([_contentViewController canDismissPresentedContent]) {
			[_delegate contentModuleContainerViewController:self closeExpandedModule:_contentModule];
			// _contentContainerView.moduleMaterialView.hidden = YES;
			// _psuedoView.hidden = NO;
			return YES;
		} else {
			if ([_contentViewController respondsToSelector:@selector(dismissPresentedContent)]) {
				[_contentViewController dismissPresentedContent];
			}
			//_contentContainerView.moduleMaterialView.hidden = YES;
			//_psuedoView.hidden = NO;
			return YES;
		}
	} else {
		if ([self isExpanded]) {
			[_delegate contentModuleContainerViewController:self closeExpandedModule:_contentModule];
			// _contentContainerView.moduleMaterialView.hidden = YES;
			// _psuedoView.hidden = NO;
			return YES;
		} else {
			if (self.previewInteraction) {
				[self.previewInteraction cancelInteraction];
				// _contentContainerView.moduleMaterialView.hidden = YES;
				// _psuedoView.hidden = NO;
			}
		}

	}
	_canBubble = YES;
	return YES;
	//[_delegate contentModuleContainerViewController:self closeExpandedModule:_contentModule];
}

// - (BOOL)closeModuleWithCompletion:(void (^)(void))completionBlock {
// 	if ([_contentViewController respondsToSelector:@selector(canDismissPresentedContent)] && [self isExpanded]) {
// 		if ([_contentViewController canDismissPresentedContent]) {
// 			[_delegate contentModuleContainerViewController:self closeExpandedModule:_contentModule];
// 			// _contentContainerView.moduleMaterialView.hidden = YES;
// 			// _psuedoView.hidden = NO;
// 			return YES;
// 		} else {
// 			if ([_contentViewController respondsToSelector:@selector(dismissPresentedContent)]) {
// 				[_contentViewController dismissPresentedContentWithCompletion:completionBlock];
// 			}
// 			//_contentContainerView.moduleMaterialView.hidden = YES;
// 			//_psuedoView.hidden = NO;
// 			return NO;
// 		}
// 	} else {
// 		if ([self isExpanded]) {
// 			[_delegate contentModuleContainerViewController:self closeExpandedModule:_contentModule];
// 			// _contentContainerView.moduleMaterialView.hidden = YES;
// 			// _psuedoView.hidden = NO;
// 			return YES;
// 		} else {
// 			if (self.previewInteraction) {
// 				[self.previewInteraction cancelInteraction];
// 				// _contentContainerView.moduleMaterialView.hidden = YES;
// 				// _psuedoView.hidden = NO;
// 			}
// 		}

// 	}
// 	_canBubble = YES;
// 	return YES;
// }

- (void)expandModule {
	if (![self isExpanded]) {
		if ([self _previewInteractionShouldFinishTransitionToPreview:nil]) {
			[self previewInteraction:nil didUpdatePreviewTransition:1.0f ended:YES];
			return;
		}

		_canBubble = NO;
		if (self.bubblingAnimator) {
			[self.bubblingAnimator stopAnimation:YES];
		}
		if (self.previewInteraction) {
			[self.previewInteraction cancelInteraction];
		}
		_canBubble = YES;
		[UIView animateWithDuration:0.275 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
			self.view.transform = CGAffineTransformIdentity;
		} completion:^(BOOL completed){
			[_delegate contentModuleContainerViewController:self didFinishInteractionWithModule:_contentModule];
			// _contentContainerView.moduleMaterialView.hidden = YES;
			// _psuedoView.hidden = NO;
		}];
	}
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
	_contentContainerView.delegateController = self;
	[_contentContainerView setModuleProvidesOwnPlatter:_contentModuleProvidesOwnPlatter];

	frame = CGRectZero;
	if (containerView)
		frame = containerView.bounds;

	[_contentContainerView setFrame:frame];
	[_contentContainerView setClipsContentInCompactMode:NO];
	[self _configureForContentModuleGroupRenderingIfNecessary];

	// _contentContainerView.expandedFrame = [self _contentFrameForExpandedState];
	// _contentContainerView.compactFrame = [self _contentFrameForRestState];
	[_contentContainerView _transitionToExpandedMode:NO force:YES];
	[_backgroundView _transitionToExpandedMode:NO force:YES];

	[_highlightWrapperView addSubview:_contentContainerView];
	_contentView = _contentViewController.view;

	[_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

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

	if (NSClassFromString(@"UIPreviewInteraction")) {

		self.previewInteraction = [[NSClassFromString(@"UIPreviewInteraction") alloc] initWithView:self.view];
		self.previewInteraction.delegate = self;
	}

	_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGestureRecognizer:)];
	_tapRecognizer.delegate = self;
	[_backgroundView addGestureRecognizer:_tapRecognizer];

	_breatheRecognizer = [[MZEBreatheGestureRecognizer alloc] initWithTarget:self action:@selector(handleBubbleGestureRecognizer:)];
	if ([self.view.gestureRecognizers count] == 0) {

		_longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
		_longPressRecognizer.minimumPressDuration = 0.5;
		_longPressRecognizer.numberOfTouchesRequired = 1;
		[_longPressRecognizer setCancelsTouchesInView:NO];
		_longPressRecognizer.delaysTouchesEnded = NO;
		_longPressRecognizer.allowableMovement = 10.0;
		_longPressRecognizer.delegate = self;
		[self.view addGestureRecognizer:_longPressRecognizer];
	}

	if (self.traitCollection && [self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
		if (self.view.gestureRecognizers.count > 0 && !_longPressRecognizer) {
			if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityUnavailable) {
				_longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
				_longPressRecognizer.minimumPressDuration = 0.5;
				_longPressRecognizer.numberOfTouchesRequired = 1;
				[_longPressRecognizer setCancelsTouchesInView:NO];
				_longPressRecognizer.delaysTouchesEnded = NO;
				_longPressRecognizer.allowableMovement = 10.0;
				_longPressRecognizer.delegate = self;
				[self.view addGestureRecognizer:_longPressRecognizer];
			}
		}
	}

	_breatheRecognizer.minimumPressDuration = 0;
	_breatheRecognizer.numberOfTouchesRequired = 1;
	_breatheRecognizer.allowableMovement = 15.0;
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

- (BOOL)shouldMaskToBounds {
	if (_contentViewController) {
		if ([_contentViewController respondsToSelector:@selector(shouldMaskToBounds)]) {
			return [_contentViewController shouldMaskToBounds];
		}
	}
	return NO;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	// _contentContainerView.expandedFrame = [self _contentFrameForExpandedState];
	// _contentContainerView.compactFrame = [self _contentFrameForRestState];
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

	// if ([_contentViewController respondsToSelector:@selector(punchOutRootLayer)]) {

	// 	if (!_maskView && _contentContainerView && _contentContainerView.moduleMaterialView) {
	// 		self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
 //            [_maskView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
 //            _maskView.backgroundColor = [UIColor clearColor];

 //            UIView *cutoutView = [[UIView alloc] initWithFrame:self.view.bounds];
 //            [cutoutView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
 //            cutoutView.backgroundColor = [UIColor blackColor];
 //            [_maskView addSubview:cutoutView];

 //            _contentContainerView.moduleMaterialView.backdropView.maskView = _maskView;
	// 	}

	// 	if (_maskView && (!_maskLayer || [_contentViewController punchOutRootLayer] != _maskLayer)) {
	// 		if (_maskLayer) {
	// 			[_maskLayer removeFromSuperlayer];
	// 		}

	// 		self.maskLayer = [_contentViewController punchOutRootLayer];
	// 		_maskLayer.compositingFilter = @"destOut";

	// 		[((UIView *)[_maskView subviews][0]).layer addSublayer:_maskLayer];
	// 	}

	// 	if (_maskView) {
	// 		_maskView.frame = _contentContainerView.bounds;
	// 	}
	// 	// if (!_maskView || [_contentViewController punchOutRootLayer] != _maskLayer || !_maskView) {
	// 	// 	if (_maskLayer) {
	// 	// 		[_maskLayer removeFromSuperlayer];
	// 	// 	}
	// 	// 	_maskLayer = nil;
	// 	// 	if (_contentContainerView && _contentContainerView.moduleMaterialView) {
	// 	// 		if ([[_contentContainerView.layer sublayers] count] > 0) {
	// 	// 			_maskLayer = [_contentViewController punchOutRootLayer];
	// 	// 			[_contentContainerView.layer insertSublayer:_maskLayer atIndex:1];
	// 	// 		} else {

	// 	// 		}
	// 	// 	}


	// 		// UIView *maskThing = [[UIView alloc] init];
	// 		// maskThing.frame = self.view.bounds;
	// 		// maskThing.backgroundColor = [UIColor clearColor];
	// 		// _maskView = maskThing;
	// 		// _maskView = [[_MZEBack alloc] initWithFrame:self.view.bounds];
	// 		// _maskView.backgroundColor = [UIColor clearColor];


	// 		// UIView *otherMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
	// 		// otherMaskView.backgroundColor = [UIColor clearColor];


	// 		// UIView *_maskView2 = [[UIView alloc] initWithFrame:self.view.bounds];
	// 		// _maskView2.backgroundColor = [UIColor blackColor];
	// 		// [_maskView2 setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	// 		// [otherMaskView addSubview:_maskView2];

	// 		// [_contentViewController punchOutRootLayer].compositingFilter = @"destOut";
	// 		// [_maskView2.layer addSublayer:[_contentViewController punchOutRootLayer]];
	// 		// [_maskView2.layer setAllowsGroupBlending:NO];
	// 		//[self.view addSubview:_maskView];

	// 		// _otherMaskView = otherMaskView;
	// 		// [self.view addSubview:maskThing];
	// 		// maskThing.maskView = _otherMaskView;
	// 		// _maskView = maskThing;
	// 		//[self.view sendSubviewToBack:_maskView];
	// 		//_maskView2.backgroundColor = [UIColor blackColor];
	// 		//_maskView2.layer.fillRule = kCAFillRuleEvenOdd;
	// 		//_maskView.layer.fillRule = kCAFillRuleEvenOdd;
	// 		//self.view.maskView = _maskView;
	// 		//_contentContainerView.moduleMaterialView.maskView = _maskView;
	// 		//[self.view addSubview:_maskView];

	// 		//_contentContainerView.maskView = _maskView;
	// 		// [_contentViewController punchOutRootLayer].compositingFilter = @"destOut";
	// 		// [_maskView.layer addSublayer:[_contentViewController punchOutRootLayer]];
	// 		// _maskView.backgroundColor = [UIColor blackColor];
	// 		// //_maskView.hidden = YES;
	// 		// //_maskView.layer.mask = [_contentViewController punchOutRootLayer];
	// 		// //_maskView.layer.compositingFilter = @"destOut";
	// 		// [_maskView.layer setAllowsGroupBlending:NO];
	// 		//_maskView.userInteractionEnabled = NO;
	// 		// _contentContainerView.maskView = _maskView;
	// 	// }
	// }
}

- (void)setAlpha:(CGFloat)alpha {
	if (_contentViewController) {
		_contentViewController.view.alpha = alpha;
	}

	// if (_maskView) {
	// 	_maskView.alpha = alpha;
	// }
}

- (BOOL)previewInteractionShouldBegin:(UIPreviewInteraction *)previewInteraction {
	if ([self isExpanded]) {
		return NO;
	} else {
		if (_bubbled) {
			return YES;
		}
		//[_delegate contentModuleContainerViewController:self didBeginInteractionWithModule:_contentModule];
		return NO;
	}
}

- (BOOL)_previewInteractionShouldFinishTransitionToPreview:(id)arg1 {
	if ([_contentViewController respondsToSelector:@selector(shouldBeginTransitionToExpandedContentModule)] && ![_contentViewController shouldBeginTransitionToExpandedContentModule]) {
		return NO;
	} else return YES;
}

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdatePreviewTransition:(CGFloat)progress ended:(BOOL)ended {
	if (_bubbled) {
		if (!ended) {
			_contentContainerView.moduleMaterialView.hidden = NO;
			_psuedoView.hidden = YES;
			[UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
				self.view.transform = CGAffineTransformMakeScale(progress * (0.25 - (_bubbled ? 0.05 : 0)) + 1.0 + (_bubbled ? 0.05 : 0),progress * (0.25 - (_bubbled ? 0.05 : 0)) + 1.0 + (_bubbled ? 0.05 : 0));
			} completion:nil];
		}

		if (ended) {
			self.view.userInteractionEnabled = NO;
			[UIPanGestureRecognizer _setPanGestureRecognizersEnabled:NO];
			_bubbled = NO;
			_canBubble = NO;
			if (self.bubblingAnimator) {
				[self.bubblingAnimator stopAnimation:YES];
			}

			[UIView animateWithDuration:0.125 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
				self.view.transform = CGAffineTransformIdentity;
			} completion:^(BOOL completed) {

				// if (!isIOS11Mode) {
	   //      		[_contentContainerView useFakeVibrantView:NO];
	   //      	}
				//[UIPanGestureRecognizer _setPanGestureRecognizersEnabled:YES];
			}];

			self.view.userInteractionEnabled = YES;
			[_delegate contentModuleContainerViewController:self openExpandedModule:_contentModule];
			[UIPanGestureRecognizer _setPanGestureRecognizersEnabled:YES];
			_canBubble = YES;
		}
	}
	return;
}

- (void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction {
	if (_canBubble) {
		[UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
			self.view.transform = CGAffineTransformIdentity;
		} completion:^(BOOL completed) {
			[_delegate contentModuleContainerViewController:self didFinishInteractionWithModule:_contentModule];
			if (![self isExpanded]) {
				_contentContainerView.moduleMaterialView.hidden = YES;
				_psuedoView.hidden = NO;
			}
			if (!isIOS11Mode) {
        		[_contentContainerView useFakeVibrantView:NO];
        	}

		}];
	}
	//[_delegate contentModuleContainerViewController:self didFinishInteractionWithModule:_contentModule];
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

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {

	if (recognizer.state == UIGestureRecognizerStateBegan) {
		[self expandModule];
	}
}

- (void)handleBubbleGestureRecognizer:(MZEBreatheGestureRecognizer *)recognizer {
	if (![self isExpanded]) {
		switch (recognizer.state) {
	        case UIGestureRecognizerStateBegan: {
	        	_bubbled = YES;
	        	if (!isIOS11Mode) {
	        		[_contentContainerView useFakeVibrantView:YES];
	        	} else {
	        		_contentContainerView.moduleMaterialView.hidden = NO;
					_psuedoView.hidden = YES;
	        	}
	        	[_delegate contentModuleContainerViewController:self didBeginInteractionWithModule:_contentModule];
	        	if ([self forceTouchSupported]) {
	        		[UIView animateWithDuration:0.275 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
						self.view.transform = CGAffineTransformMakeScale(1.05,1.05);
					} completion:nil];
	        	} else {

	        		if (NSClassFromString(@"UIViewPropertyAnimator")) {
	        			self.bubblingAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 curve:UIViewAnimationCurveEaseIn animations:^{
		        			self.view.transform = CGAffineTransformMakeScale(1.25,1.25);
		        		}];

		        		self.bubblingAnimator.interruptible = YES;
		        		self.bubblingAnimator.userInteractionEnabled = YES;
		        		[self.bubblingAnimator startAnimation];
	        		}
	        	}
	            break;
	        }

	        case UIGestureRecognizerStateCancelled:
	        case UIGestureRecognizerStateFailed:
	        case UIGestureRecognizerStateEnded: {
	        	if (_bubbled && _canBubble) {
	        		_canBubble = NO;
	        		if (!isIOS11Mode) {
		        		[_contentContainerView useFakeVibrantView:NO];
		        	}
	        		if (self.bubblingAnimator) {
	        			[self.bubblingAnimator stopAnimation:YES];
	        		}
	        		if (self.previewInteraction) {
	        			[self.previewInteraction cancelInteraction];
	        		}
		        	_canBubble = YES;
		        	[UIView animateWithDuration:0.275 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
						self.view.transform = CGAffineTransformIdentity;
					} completion:^(BOOL completed){
						[_delegate contentModuleContainerViewController:self didFinishInteractionWithModule:_contentModule];
						if (![self isExpanded]) {
							_contentContainerView.moduleMaterialView.hidden = YES;
							_psuedoView.hidden = NO;
						}
					}];
				}
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

	if (size.height > [self _backgroundFrameForRestState].size.height + 2) {
		CGSize expandedContentSize = [self _contentFrameForExpandedState].size;


		// [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
	 //        self.view.transform = CGAffineTransformIdentity;
	 //        // do whatever
	 //    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) { 

	 //    }];
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


- (BOOL)forceTouchSupported {
	if (!NSClassFromString(@"UIPreviewInteraction")) {
		return NO;
	}
	return [[self.view traitCollection] forceTouchCapability] == UIForceTouchCapabilityAvailable;
	// static dispatch_once_t onceToken;
 //    dispatch_once(&onceToken, ^{
 //        forceTouchIsSupported = [[self.view traitCollection] forceTouchCapability] == UIForceTouchCapabilityAvailable;
 //    });
	// return forceTouchIsSupported;
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

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];

	if (self.traitCollection && [self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
		if (self.view.gestureRecognizers.count > 0 && !_longPressRecognizer) {
			if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityUnavailable) {
				_longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
				_longPressRecognizer.minimumPressDuration = 0.5;
				_longPressRecognizer.numberOfTouchesRequired = 1;
				[_longPressRecognizer setCancelsTouchesInView:NO];
				_longPressRecognizer.delaysTouchesEnded = NO;
				_longPressRecognizer.allowableMovement = 10.0;
				_longPressRecognizer.delegate = self;
				[self.view addGestureRecognizer:_longPressRecognizer];
			}
		}
	}
}
@end