#import "MZEContentModuleContainerViewController.h"
#import "MZELayoutOptions.h"
#import <UIKit/UIScreen+Private.h>

#if __cplusplus
	extern "C" {
#endif
	CGPoint UIRectGetCenter(CGRect);
#if __cplusplus
}
#endif

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
}

- (MZEContentModuleContainerView *)moduleContainerView {
	return (MZEContentModuleContainerView *)self.view;
}

- (void)willBecomeActive {
	if ([_contentViewController respondsToSelector:@selector(willBecomeActive)]) {
		[_contentViewController willBecomeActive];
	} else {
		if ([_contentViewController respondsToSelector:@selector(controlCenterWillPresent)]) {
			[_contentViewController controlCenterWillPresent];
		}
	}
}

- (void)willResignActive {
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
	[_highlightWrapperView setBackgroundColor:[UIColor clearColor]];
	[_highlightWrapperView setAutoresizingMask:18];
	[containerView addSubview:_highlightWrapperView];

	_backgroundView = [[MZEContentModuleBackgroundView alloc] init];
	frame = CGRectZero;
	if (containerView)
		frame = containerView.bounds;

	[_backgroundView setFrame:frame];
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

	_previewInteraction = [[UIPreviewInteraction alloc] initWithView:self.view];
	_previewInteraction.delegate = self;
	_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGestureRecognizer:)];
	_tapRecognizer.delegate = self;
	[_backgroundView addGestureRecognizer:_tapRecognizer];

	_breatheRecognizer = [[MZEBreatheGestureRecognizer alloc] init];
	[_breatheRecognizer setCancelsTouchesInView:NO];
	_breatheRecognizer.delaysTouchesEnded = NO;
	[self.view addGestureRecognizer:_breatheRecognizer];

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
	
	return;
}

- (void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction {
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
		return [_delegate compactModeFrameForContentModuleContainerViewController:self];
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
	return [[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:[UIDevice currentDevice].orientation];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	HBLogInfo(@"STARTED TOYCHING THINGY");
	if (![self isExpanded]) {
		UITouch *touch = [[event allTouches] anyObject];
    	CGPoint touchLocation = [touch locationInView:self.view];
    	_firstX = touchLocation.x;
    	_firstY = touchLocation.y;
    	if (CGAffineTransformEqualToTransform(self.view.transform,CGAffineTransformMakeScale(1.05,1.05))) {
			//self.view.transform = CGAffineTransformIdentity;
    	}
		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.view.transform = CGAffineTransformMakeScale(1.05,1.05);
		} completion:nil];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (![self isExpanded] && _canBubble && _firstX != -1 && _firstY != 1) {
		UITouch *touch = [[event allTouches] anyObject];
    	CGPoint touchLocation = [touch locationInView:self.view];
    	if ((_firstX - touchLocation.x >= 10 || _firstX - touchLocation.x <= -10) || (_firstY - touchLocation.y >= 10 || _firstY - touchLocation.y <= -10)) {
    		_canBubble = NO;
    		_firstX = 0;
    		_firstY = 0;
    		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
				self.view.transform = CGAffineTransformIdentity;
			} completion:nil];
    	}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_firstY = -1;
	_firstX = -1;
	if (![self isExpanded] && _canBubble) {
		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.view.transform = CGAffineTransformIdentity;
		} completion:nil];
	}
	_canBubble = YES;
}
@end