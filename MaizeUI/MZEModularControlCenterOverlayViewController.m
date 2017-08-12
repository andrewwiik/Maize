#import "MZEModularControlCenterOverlayViewController.h"
#import <UIKit/UIView+Private.h>
#import <SpringBoard/SBControlCenterController+Private.h>
#import <ControlCenterUI/CCUIControlCenterViewController.h>
#import <UIKit/UIPanGestureRecognizer+Private.h>
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

- (UIViewController *)contentViewController {
	return self;
}

- (void)viewDidLoad {
	_backgroundView = [[MZEBackgroundView alloc] initWithFrame:[self.view bounds]];
	_backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	[self.view addSubview:_backgroundView];

	_scrollView = [[MZEScrollView alloc] init];
    [_scrollView setDelegate:self];
    [_scrollView setClipsToBounds:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    [_scrollView addSubview:self.collectionViewController.view];
    [self.view addSubview:_scrollView];

    _headerPocketView = [[MZEHeaderPocketView alloc] init];
    _headerPocketView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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

- (void)_handleControlCenterDismissalTapGesture:(UITapGestureRecognizer *)gesture {
	return;
	if ([self presentationState] == MZEPresentationStatePresented && !_isInteractingWithModule) {
		[self dismissAnimated:YES withCompletionHandler:nil];
	}
}

- (void)viewWillLayoutSubviews {

	[self _makePresentationFramesDirty];

	if (![self.collectionViewController.view superview]) {
		[_scrollView addSubview:self.collectionViewController.view];
	}
	[super viewWillLayoutSubviews];

	CGRect targetFrame = [self _targetPresentationFrame];
	CGRect bounds = [self.view bounds];
	_backgroundView.frame = bounds;
	_scrollView.frame = bounds;

	CGRect collectionViewFrame = self.moduleCollectionViewController.moduleCollectionView.frame;
	CGSize preferredContentSize = [self.moduleCollectionViewController preferredContentSize];
	CGFloat maxHeight = CGRectGetMinY(targetFrame) + preferredContentSize.height;
	[self.moduleCollectionViewController.moduleCollectionView setSize:preferredContentSize];
	_scrollView.contentSize = CGSizeMake(preferredContentSize.width, maxHeight);
	[self _setCollectionViewOriginYUpdatingRevealPercentage:collectionViewFrame.origin.y];
	[self.moduleCollectionViewController.moduleCollectionView setNeedsLayout];
	[_headerPocketView setNeedsLayout];
	[self _updateHotPocketAnimated:NO];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         [self.view setNeedsLayout];
         [self.view layoutIfNeeded];
        // [_sliderView _layoutValueViews];
        // do whatever
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) { 

    }];
}

- (void)presentAnimated:(BOOL)animated withCompletionHandler:(id)completionHandler {
	[[NSClassFromString(@"SBControlCenterController") sharedInstance] presentAnimated:animated completion:completionHandler];
	// if (animated) {
	// 	[UIView animateWithDuration:1.0f animations:^{
	// 		[self updatePresentationForRevealPercentage:1.0f];
	// 	} completion:completionHandler];
	// } else {
	// 	[UIView performWithoutAnimation:^{
	// 		[self updatePresentationForRevealPercentage:1.0f];
	// 	}];
	// }
}

- (void)dismissAnimated:(BOOL)animated withCompletionHandler:(id)completionHandler {
	[[NSClassFromString(@"SBControlCenterController") sharedInstance] dismissAnimated:animated completion:completionHandler];
	// if (animated) {
	// 	[UIView animateWithDuration:1.0f animations:^{
	// 		[self updatePresentationForRevealPercentage:0.0f];
	// 	} completion:completionHandler];
	// } else {
	// 	[UIView performWithoutAnimation:^{
	// 		[self updatePresentationForRevealPercentage:0.0f];
	// 	}];
	// }
}

- (void)revealWithProgress:(CGFloat)progress {
	_isInteractingWithModule = NO;
	[self updatePresentationForRevealPercentage:progress];
}

- (void)updatePresentationForRevealPercentage:(CGFloat)percentage {
	if ([self presentationState] != MZEPresentationStatePresented) {
		self.presentationState = percentage >= 1 ? MZEPresentationStatePresented : MZEPresentationStateTransitioning;
	}

	if (percentage <= 0 && [self presentationState] == MZEPresentationStateTransitioning) {
		self.presentationState = MZEPresentationStateDismissed;
	}

	if ([self presentationState] == MZEPresentationStatePresented) {
		[self _beginPresentationAnimated:YES];
	}

	CGFloat sourceYOrigin = [self _sourcePresentationFrame].origin.y;
	CGFloat yOrigin = sourceYOrigin - (sourceYOrigin - [self _targetPresentationFrame].origin.y)*percentage;
	[self _animateSetCollectionViewOriginYUpdatingRevealPercentage:fmaxf(yOrigin, CGRectGetMinY([self _targetPresentationFrame]) - (CGRectGetMinY([self _targetPresentationFrame])*0.15))];
}
 
- (CGFloat)_presentationGestureActivationMinimumYOffset {
	return [self _targetPresentationFrame].origin.y * 0.75;
}

- (CGFloat)_dismissalGestureActivationMinimumYOffset {
	return [self _targetPresentationFrame].origin.y * 1.25;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self _updateHotPocketAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture {
	if (gesture == _headerPocketViewDismissalPanGesture) {
		return [self _allowDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture];
	}
	if (gesture == _collectionViewDismissalPanGesture) {
		return [self _allowDismissalWithCollectionPanGesture:(UIPanGestureRecognizer *)gesture];
	}
	if (gesture == _headerPocketViewDismissalTapGesture || gesture == _collectionViewDismissalTapGesture) {
		return [self _allowDismissalWithTapGesture:(UITapGestureRecognizer *)gesture];
	}
	return YES;

}

- (BOOL)scrollView:(MZEScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer != _collectionViewScrollPanGesture) {
		return YES;
	} else {
		return [self _allowScrollWithPanGesture:(UIPanGestureRecognizer *)gestureRecognizer];
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

- (BOOL)_allowDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture {
	if ([gesture translationInView:self.view].y < 0) {
		return NO;
	}
	return YES;
}

- (BOOL)_allowDismissalWithTapGesture:(UITapGestureRecognizer *)gesture {
	if ([self presentationState] != MZEPresentationStateTransitioning && [self presentationState] != MZEPresentationStateDismissed) {
		CGRect targetFrame = [self _targetPresentationFrame];
		CGPoint touchPoint = [gesture locationInView:_scrollView];
		return !CGRectContainsPoint(targetFrame, touchPoint);
	}
	return NO;
}

- (BOOL)_allowDismissalWithCollectionPanGesture:(UIPanGestureRecognizer *)gesture {
	if ([self _allowDismissalWithPanGesture:gesture] && _scrollView.contentOffset.y <= 0) {
		CGPoint point = [gesture locationInView:self.moduleCollectionViewController.view];
		UIView *hitView = [self.moduleCollectionViewController.view hitTest:point withEvent:nil];
		HBLogInfo(@"HIT VIEW: %@", hitView);
		if ([hitView isExclusiveTouch]) {
			// CGPoint velocity = [gesture velocityInView:self.view];
			// velocity.x = velocity.x*0.15;
			// velocity.y = velocity.y*0.15;
			return NO;
		} else {
			return YES;
		}
	}
	return NO;
}

// char __cdecl -[CCUIModularControlCenterOverlayViewController _allowDismissalWithCollectionPanGesture:](struct CCUIModularControlCenterOverlayViewController *self, SEL a2, id a3)
// {
//   id v3; // esi@1
//   int v4; // edx@2
//   struct CCUIScrollView *v5; // eax@3
//   struct CCUIScrollView *v6; // ecx@3
//   unsigned int v7; // edx@3
//   void *v8; // eax@3
//   char *v9; // esi@3
//   void *v10; // eax@4
//   int v11; // ebx@4
//   unsigned int v12; // edx@4
//   float v13; // xmm0_4@4
//   float v14; // xmm0_4@4
//   void *v15; // eax@4
//   int v16; // ebx@4
//   unsigned int v17; // edx@4
//   void *v18; // eax@4
//   const char *v19; // ebx@4
//   char v20; // bl@6
//   const char *v21; // eax@7
//   signed int v23; // [sp-4h] [bp-7Ch]@1
//   void *v24; // [sp+4h] [bp-74h]@1
//   struct CCUIScrollView *v25; // [sp+8h] [bp-70h]@1
//   __int64 v26; // [sp+Ch] [bp-6Ch]@3
//   __int64 v27; // [sp+14h] [bp-64h]@10
//   const char *v28; // [sp+1Ch] [bp-5Ch]@10
//   int v29; // [sp+20h] [bp-58h]@12
//   int v30; // [sp+24h] [bp-54h]@12
//   __int128 v31; // [sp+30h] [bp-48h]@10
//   __int128 v32; // [sp+40h] [bp-38h]@5
//   float v33; // [sp+50h] [bp-28h]@4
//   struct objc_object *v34; // [sp+54h] [bp-24h]@3
//   char *v35; // [sp+58h] [bp-20h]@4
//   const char *v36; // [sp+5Ch] [bp-1Ch]@4
//   const char *v37; // [sp+60h] [bp-18h]@3
//   __int64 v38; // [sp+64h] [bp-14h]@4

//   v23 = 66767;
//   v3 = objc_retain((struct CCUIControlCenterPositionProviderPackingRule *)a3, v24, (struct _NSZone *)v25);
//   v25 = (struct CCUIScrollView *)v3;
//   if ( (unsigned __int8)objc_msgSend(self, selRef__allowDismissalWithPanGesture_, v3)
//     && (objc_msgSend(self->_scrollView, selRef_contentOffset, v25), (unsigned __int8)BSFloatLessThanOrEqualToFloat(
//                                                                                        v4,
//                                                                                        0)) )
//   {
//     v25 = self->_scrollView;
//     v37 = selRef_locationInView_;
//     v34 = v3;
//     v5 = (struct CCUIScrollView *)objc_msgSend(v3, selRef_locationInView_, v25);
//     v6 = self->_scrollView;
//     v26 = v7;
//     v25 = v5;
//     v8 = objc_msgSend(v6, selRef_hitTest_withEvent_, v5, v7, 0);
//     v9 = (char *)objc_retainAutoreleasedReturnValue(v8);
//     if ( (unsigned __int8)objc_msgSend(v9, selRef_isExclusiveTouch, v25, v26) )
//     {
//       v35 = selRef_view;
//       v10 = objc_msgSend(self, selRef_view);
//       v11 = objc_retainAutoreleasedReturnValue(v10);
//       v36 = v9;
//       v3 = v34;
//       v38 = __PAIR__(
//               _mm_cvtsi128_si32(_mm_cvtsi32_si128(v12)),
//               _mm_cvtsi128_si32(_mm_cvtsi32_si128((unsigned int)objc_msgSend(v34, selRef_velocityInView_, v11))));
//       objc_release(v11);
//       v13 = *(float *)&v38 * 0.15;
//       *(float *)&v38 = v13;
//       v14 = *((float *)&v38 + 1) * 0.15;
//       *((float *)&v38 + 1) = v14;
//       v15 = objc_msgSend(self, selRef_view, v11);
//       v16 = objc_retainAutoreleasedReturnValue(v15);
//       v25 = (struct CCUIScrollView *)v16;
//       v33 = COERCE_FLOAT(_mm_cvtsi128_si32(_mm_cvtsi32_si128((unsigned int)objc_msgSend(v34, v37, v16))));
//       *(float *)&v37 = COERCE_FLOAT(_mm_cvtsi128_si32(_mm_cvtsi32_si128(v17)));
//       objc_release(v16);
//       v18 = objc_msgSend(self, selRef_view, v16);
//       v19 = (const char *)objc_retainAutoreleasedReturnValue(v18);
//       if ( v36 )
//         objc_msgSend_stret(&v32, v36, selRef_bounds);
//       else
//         _mm_store_si128((__m128i *)&v32, 0LL);
//       *(float *)&v38 = *(float *)&v38 + v33;
//       *((float *)&v38 + 1) = *((float *)&v38 + 1) + *(float *)&v37;
//       if ( v19 )
//       {
//         v27 = *((_QWORD *)&v32 + 1);
//         v26 = v32;
//         v28 = v36;
//         objc_msgSend_stret(&v31, v19, selRef_convertRect_fromView_, (_QWORD)v32, *((_QWORD *)&v32 + 1));
//       }
//       else
//       {
//         v31 = 0LL;
//       }
//       objc_release(v19);
//       UIRectInsetEdges(&v29, v31, DWORD1(v31), DWORD2(v31), DWORD3(v31), 15, -1056964608, v28);
//       *(_QWORD *)&v24 = *(_QWORD *)((char *)&loc_104D6 + (_DWORD)&v29 - 66766);
//       v20 = CGRectContainsPoint(v29, v30, v24, v25, v38, HIDWORD(v38)) ^ 1;
//       v21 = v36;
//     }
//     else
//     {
//       v20 = 1;
//       v21 = v9;
//       v3 = v34;
//     }
//     objc_release(v21);
//   }
//   else
//   {
//     v20 = 0;
//   }
//   objc_release(v3);
//   return v20;
// }

- (void)_handleControlCenterDismissalPanGesture:(UIPanGestureRecognizer *)recognizer {
	// if (_isInteractingWithModule) {
	// 	return;
	// }
	if (_isInteractingWithModule) {
		//self.view.backgroundColor = [UIColor greenColor];
		recognizer.fakePossible = YES;
		//recognizer.state = UIGestureRecognizerStatePossible;
	} else {
		if (recognizer.fakePossible) {
			recognizer.fakePossible = NO;
			recognizer.fakeBegan = YES;
		} else if (recognizer.fakeBegan) {
			recognizer.fakeBegan = NO;
		}
		//self.view.backgroundColor = [UIColor redColor];
	}
	if ([NSClassFromString(@"SBControlCenterController") sharedInstance]) {
		SBControlCenterController *controller = [NSClassFromString(@"SBControlCenterController") sharedInstance];
		if ([controller valueForKey:@"_viewController"]) {
			[(CCUIControlCenterViewController *)[controller valueForKey:@"_viewController"] _handlePan:recognizer];
			return;
		}
	}

	switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
        	[self _beginDismissalWithPanGesture:recognizer];
            break;
        }
        case UIGestureRecognizerStateChanged: {
        	[self _updateDismissalWithPanGesture:recognizer];
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
	[self _animateSetCollectionViewOriginYUpdatingRevealPercentage:fmaxf(offset+presentMinY, CGRectGetMinY([self _targetPresentationFrame]) - (CGRectGetMinY([self _targetPresentationFrame])*0.15))];

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
	if (_scrollView.contentOffset.y > 0)
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
	[self _setPocketViewOriginFromCollectionOriginY:yOrigin revealPercentage:percentage];
	_backgroundView.effectProgress = fmaxf(fminf(percentage, 1.0), 0.0);
	// Not gonna implement a delegate method we aren't going to actually use;
}

- (void)_setPocketViewOriginFromCollectionOriginY:(CGFloat)yOrigin revealPercentage:(CGFloat)revealPercentage {

	CGRect targetFrame = [self _targetPresentationFrame];

	CGSize headerPocketSize = [_headerPocketView sizeThatFits:CGSizeMake(CGRectGetWidth([self.view bounds]),0.0f)];
	CGFloat headerPocketBetween = CGRectGetHeight([self.view bounds]) - (CGRectGetHeight([self.view bounds]) - targetFrame.origin.y);
	CGPoint headerPocketOrigin = CGPointMake(0,yOrigin - headerPocketBetween);
	_headerPocketView.frame = CGRectMake(headerPocketOrigin.x,headerPocketOrigin.y,headerPocketSize.width,headerPocketSize.height);
	CGFloat alpha = fminf(fmaxf((revealPercentage + -0.88) / 0.07, 0.0), 1.0);
	_headerPocketView.alpha = alpha;
	[_headerPocketView setChevronPointingDown: alpha > 0.95];
}

- (void)_setCollectionViewOriginAccountingForContentInset:(CGPoint)origin {
	[_scrollView setContentOffset:_scrollView.contentOffset animated:NO];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if (gestureRecognizer) {
		if (_isInteractingWithModule && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
			return NO;
		}
	}
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
	if (gestureRecognizer) {
		if (_isInteractingWithModule && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
			return NO;
		}
	}
	return YES;
}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didFinishInteractionWithModule:(id <MZEContentModule>)module {
	_isInteractingWithModule = NO;
	// _collectionViewScrollPanGesture.enabled = YES;
	// _collectionViewDismissalTapGesture.enabled = YES;
	// _collectionViewDismissalPanGesture.enabled = YES;
	// _headerPocketViewDismissalTapGesture.enabled = YES;
	// _headerPocketViewDismissalPanGesture.enabled = YES;
}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didBeginInteractionWithModule:(id <MZEContentModule>)module {
	_isInteractingWithModule = YES;
	// _collectionViewScrollPanGesture.enabled = NO;
	// _collectionViewDismissalTapGesture.enabled = NO;
	// _collectionViewDismissalPanGesture.enabled = NO;
	// _headerPocketViewDismissalTapGesture.enabled = NO;
	// _headerPocketViewDismissalPanGesture.enabled = NO;
}


- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willOpenExpandedModule:(id <MZEContentModule>)module {
	_headerPocketView.alpha = 0;
	_collectionViewScrollPanGesture.enabled = NO;
	_collectionViewDismissalTapGesture.enabled = NO;
	_collectionViewDismissalPanGesture.enabled = NO;
	_headerPocketViewDismissalTapGesture.enabled = NO;
	_headerPocketViewDismissalPanGesture.enabled = NO;
	_isInteractingWithModule = YES;
	[super moduleCollectionViewController:collectionViewController willOpenExpandedModule:module];
}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willCloseExpandedModule:(id <MZEContentModule>)module {
	_headerPocketView.alpha = 1.0;
	[self _updateHotPocketAnimated:YES];
	_isInteractingWithModule = NO;
	_collectionViewScrollPanGesture.enabled = YES;
	_collectionViewDismissalTapGesture.enabled = YES;
	_collectionViewDismissalPanGesture.enabled = YES;
	_headerPocketViewDismissalTapGesture.enabled = YES;
	_headerPocketViewDismissalPanGesture.enabled = YES;
	[super moduleCollectionViewController:collectionViewController willCloseExpandedModule:module];
}
// CGRectIsNull
@end