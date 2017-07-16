#import "MZEContentModuleContainerViewController.h"

@implementation MZEContentModuleContainerViewController
	@synthesize delegate=_delegate;
	@synthesize originalParentViewController=_originalParentViewController;

- (id)initWithModuleIdentifier:(NSString *)identifier contentModule:(id<MZEContentModule>)contentModule {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_moduleIdentifier = identifier;
		_contentModule = contentModule;
		_contentViewController = [_contentModule contentViewController];

		if ([_contentViewController respodsToSelector:@selector(providesOwnPlatter)]) {
			_contentModuleProvidesOwnPlatter = [_contentViewController providesOwnPlatter];	
		}

		if ([_contentViewController respodsToSelector:@selector(backgroundViewController)]) {
			_backgroundViewController = [_contentViewController backgroundViewController];
		}

		_didSendContentAppearanceCalls = NO;
    	_didSendContentDisappearanceCalls = NO;
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
	if ([_contentViewController respodsToSelector:@selector(canDismissPresentedContent)] && [_contentViewController canDismissPresentedContent]) {
		if (![_contentViewController respodsToSelector:@selector(dismissPresentedContent)]) {
			return;
		}
		[_contentViewController dismissPresentedContent];
	} else {
		[self.previewInteraction cancelInteraction];
	}
}

- (MZEContentModuleContainerView *)moduleContainerView {
	return self.view;
}
- (void)willBecomeActive {
	if ([_contentViewController respodsToSelector:@selector(willBecomeActive)]) {
		[_contentViewController willBecomeActive];
	} else {
		if ([_contentViewController respodsToSelector:@selector(controlCenterWillPresent)]) {
			[_contentViewController controlCenterWillPresent];
		}
	}
}

- (void)willResignActive {
	if ([_contentViewController respodsToSelector:@selector(willResignActive)]) {
		[_contentViewController willResignActive];
	} else {
		if ([_contentViewController respodsToSelector:@selector(controlCenterDidDismiss)]) {
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

	CGRect frame = CGRectZero;
	if (containerView)
		frame = containerView.bounds;

	_highlightWrapperView = [[UIView alloc] initWithFrame:frame];
	[_highlightWrapperView setBackgroundColor:[UIColor clearColor]];
	[_highlightWrapperView setAutoresizingMask:18];
	[_containerView addSubview:_highlightWrapperView];

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


}
- (void)viewWillLayoutSubviews;
- (BOOL)previewInteractionShouldBegin:(UIPreviewInteraction *)previewInteraction;
- (BOOL)_previewInteractionShouldFinishTransitionToPreview:(id)arg1;
- (void)previewInteraction:(UIPreviewInteraction *)arg1 didUpdatePreviewTransition:(CGFloat)arg2 ended:(BOOL)arg3;
- (void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction;
- (id)_previewInteractionHighlighterForPreviewTransition:(id)arg1;
- (id)_previewInteraction:(UIPreviewInteraction *)previewInteraction viewControllerPresentationForPresentingViewController:(UIViewController *)viewController;
- (BOOL)_previewInteractionShouldAutomaticallyTransitionToPreviewAfterDelay:(id)arg1;
- (void)_handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer;
- (CGRect)_contentFrameForRestState;
- (CGRect)_contentFrameForExpandedState;
- (CGRect)_backgroundFrameForRestState;
- (CGRect)_backgroundFrameForExpandedState;
- (CGRect)_contentBoundsForTransitionProgress:(CGFloat)arg1;
- (void)_configureMaskViewIfNecessary;
- (void)_configureForContentModuleGroupRenderingIfNecessary;
@end