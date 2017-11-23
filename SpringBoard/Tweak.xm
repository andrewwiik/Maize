#import <MaizeUI/MZEAnimatedBlurView.h>
#import <MaizeUI/_MZEBackdropView.h>
#import <MaizeUI/MZELayoutOptions.h>
// #import "BinPackingFactory2D.h"
#import <MaizeUI/MZEModularControlCenterOverlayViewController.h>
#import <MaizeUI/MZEHybridPageViewController.h>
#import <MaizeUI/MZECurrentActions.h>
#import <MaizeUI/MZEOptionsManager.h>
#import <QuartzCore/CAFilter+Private.h>
#import <ControlCenterUI/CCUIControlCenterViewController.h>
#import <UIKit/_UIBackdropViewSettings+Private.h>
#import <SpringBoard/SBControlCenterController+Private.h>

//%config(generator=internal)

struct CAColorMatrix
{
    float m11, m12, m13, m14, m15;
    float m21, m22, m23, m24, m25;
    float m31, m32, m33, m34, m35;
    float m41, m42, m43, m44, m45;
};

typedef struct CAColorMatrix CAColorMatrix;

@interface NSValue (ColorMatrix)
+ (NSValue *)valueWithCAColorMatrix:(CAColorMatrix)t;
- (CAColorMatrix)CAColorMatrixValue;
@end


@interface CCUIControlCenterViewController (MZE)
@property (assign,getter=isPresented,nonatomic) BOOL presented; 
@property (nonatomic, retain) MZEModularControlCenterOverlayViewController *mze_viewController;
- (BOOL)isPresented;
@end


@interface CALayer (MZE)
@property (nonatomic, assign) BOOL allowsGroupBlending;
@end

static BOOL hasCalled = NO;

static BOOL isIOS9 = NO;

static CGPoint initialTransitionPoint;


static MZEModularControlCenterOverlayViewController *sharedController;

static BOOL isLoading = NO;
@interface SBControlCenterController (MZE)
@property (assign,getter=isPresented,nonatomic) BOOL presented;
@end

%hook SBControlCenterController

- (void)updateTransitionWithTouchLocation:(CGPoint)location velocity:(CGPoint)velocity {
    if (NSClassFromString(@"CCUIControlCenterViewController") && sharedController) {
      MSHookIvar<BOOL>(self, "_dismissalPanHasGoneBelowCCTopEdge") = YES;
    }
    %orig;
}

- (CGFloat)_yValueForOpen {
  if (isIOS9 && sharedController) {
    if (!self.presented) {
      return CGRectGetHeight(sharedController.view.bounds) - [sharedController _targetPresentationFrame].origin.y;
    }
    return [sharedController _targetPresentationFrame].origin.y/2;
  } else return %orig;
}

- (CGFloat)_controlCenterHeightForTouchLocation:(CGPoint)touchLocation {
  if (isIOS9 && sharedController && self.presented) {
    if (initialTransitionPoint.x != 0) {
       return (CGRectGetHeight(sharedController.view.bounds) - [sharedController _targetPresentationFrame].origin.y) - (touchLocation.y - initialTransitionPoint.y);
     // [sharedController _targetPresentationFrame].origin.y
      //return initialTransitionPoint.y - touchLocation.y
    }
  }

  return %orig;
}

- (void)_beginTransitionWithTouchLocation:(CGPoint)touchLocation {
  initialTransitionPoint = touchLocation;
  %orig;
}

%end


MZEHybridPageViewController *hybridPageController;

%hook CCUIControlCenterViewControllerRootClass
%property (nonatomic, retain) MZEModularControlCenterViewController *mze_viewController;

-(CGFloat)_scrollviewContentMaxHeight {
  if (((CCUIControlCenterViewController *)self).mze_viewController) {
    return CGRectGetHeight(((CCUIControlCenterViewController *)self).view.bounds) - [((CCUIControlCenterViewController *)self).mze_viewController _targetPresentationFrame].origin.y;
  }
  // 54
  // 16.5
  if ([MZEOptionsManager isHybridMode] && hybridPageController) {
    return [hybridPageController.collectionViewController preferredContentSize].height + 19;
  }
  return %orig;
}

- (CGRect)_frameForChildViewController:(CCUIControlCenterPageContainerViewController *)viewController {
  if (((CCUIControlCenterViewController *)self).mze_viewController) {
    return [((CCUIControlCenterViewController *)self).mze_viewController _targetPresentationFrame];
  } else return %orig;
}

// -(CGFloat)_scrollviewContentMaxHeight {
//   if (((CCUIControlCenterViewController *)self).mze_viewController) {
//    // if (!((CCUIControlCenterViewController *)self).presented) {
//       return [((CCUIControlCenterViewController *)self).mze_viewController _targetPresentationFrame].size.height;
//    // } else {
//     //  return [((CCUIControlCenterViewController *)self).mze_viewController _targetPresentationFrame].size.height;
//     //}
//   }
//   return %orig;
// }

// - (CGRect)_frameForChildViewController:(CCUIControlCenterPageContainerViewController *)viewController {
//   if (((CCUIControlCenterViewController *)self).mze_viewController) {
//    // return ((CCUIControlCenterViewController *)self).view.bounds;
//     if (((CCUIControlCenterViewController *)self).presented) {
//       return ((CCUIControlCenterViewController *)self).view.bounds;
//     }
//     return [((CCUIControlCenterViewController *)self).mze_viewController _targetPresentationFrame];
//   } else return %orig;
// }

- (void)_loadPages {
  if (![MZEOptionsManager isHybridMode]) {
    if (!sharedController) {
     // [self setRevealPercentage:0.0];
      return;
    }
  }
  %orig;
  // MZEHybridPageViewController *hybridPage = [[MZEHybridPageViewController alloc] initWithFrame:CGRectZero];
  // [self _addContentViewController:hybridPage];
}

-(void)setRevealPercentage:(CGFloat)revealPercentage {

  if (!((CCUIControlCenterViewController *)self).mze_viewController && ![MZEOptionsManager isHybridMode]) {
    ((CCUIControlCenterViewController *)self).mze_viewController = [[MZEModularControlCenterOverlayViewController alloc] initWithFrame:CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height)];
    sharedController = ((CCUIControlCenterViewController *)self).mze_viewController;
    [((CCUIControlCenterViewController *)self).view addSubview:((CCUIControlCenterViewController *)self).mze_viewController.view];
    [self addChildViewController:((CCUIControlCenterViewController *)self).mze_viewController];
    [((CCUIControlCenterViewController *)self).mze_viewController didMoveToParentViewController:self];

  }

  if ([MZEOptionsManager isHybridMode] && !hybridPageController) {
    hybridPageController = [[MZEHybridPageViewController alloc] initWithFrame:CGRectZero];
    [self _addContentViewController:hybridPageController];
  }

  %orig(revealPercentage);

  if (![MZEOptionsManager isHybridMode])  {

    if (!((CCUIControlCenterViewController *)self).presented && !hasCalled) {
      [((CCUIControlCenterViewController *)self).mze_viewController willBecomeActive];
    }

    ((CCUIControlCenterViewController *)self).mze_viewController.view.userInteractionEnabled = YES;
    hasCalled = YES;


    for (UIView *subview in ((CCUIControlCenterViewController *)self).view.subviews) {
      if (subview != ((CCUIControlCenterViewController *)self).mze_viewController.view) {
        subview.alpha = 0;
        subview.hidden = YES;
      }
    }
    ((CCUIControlCenterViewController *)self).mze_viewController.view.frame = ((CCUIControlCenterViewController *)self).view.bounds;
    [((CCUIControlCenterViewController *)self).mze_viewController revealWithProgress:revealPercentage];
  }

  isLoading = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch {
  if (((CCUIControlCenterViewController *)self).mze_viewController) return NO;
  else return %orig;
}

-(BOOL)gestureRecognizerShouldBegin:(id)arg1 {
  if (((CCUIControlCenterViewController *)self).mze_viewController) return NO;
  else return %orig;
}

-(void)controlCenterWillPresent {
  %orig;
  if (((CCUIControlCenterViewController *)self).mze_viewController && !hasCalled) {
    [((CCUIControlCenterViewController *)self).mze_viewController willBecomeActive];
    hasCalled = YES;
  }
}

-(void)_noteControlCenterControlDidActivate:(id)arg1 {
  %orig;
  if (((CCUIControlCenterViewController *)self).mze_viewController && !hasCalled) {
    [((CCUIControlCenterViewController *)self).mze_viewController willBecomeActive];
    hasCalled = YES;
  }
}

-(void)_noteControlCenterControlDidDeactivate:(id)arg1 {
  %orig;
  if (((CCUIControlCenterViewController *)self).mze_viewController && hasCalled) {
      hasCalled = NO;
      [((CCUIControlCenterViewController *)self).mze_viewController willResignActive];
      [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
    }
}

// -(void)controlCenterDidDismiss {
//   %orig;
//   if (((CCUIControlCenterViewController *)self).mze_viewController) {
//     [((CCUIControlCenterViewController *)self).mze_viewController willResignActive];
//   }
// }

-(void)controlCenterWillBeginTransition {
  %orig;
  if (((CCUIControlCenterViewController *)self).mze_viewController) {
      [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
    }
}
-(void)controlCenterDidFinishTransition {
  %orig;
    if (((CCUIControlCenterViewController *)self).mze_viewController) {
      [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
    }
}

// -(void)_handlePan:(UIPanGestureRecognizer *)recognizer {
//   if (recognizer.state == UIGestureRecognizerStateBegan) {
//     if (!((CCUIControlCenterViewController *)self).mze_viewController) {
//       ((CCUIControlCenterViewController *)self).mze_viewController = [[MZEModularControlCenterViewController alloc] initWithFrame:CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height)];
//       [((CCUIControlCenterViewController *)self).mze_viewController loadView];
//       ((CCUIControlCenterViewController *)self).mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//       [((CCUIControlCenterViewController *)self).view addSubview:((CCUIControlCenterViewController *)self).mze_viewController.view];
//     }

//     if (!((CCUIControlCenterViewController *)self).presented) {
//       [((CCUIControlCenterViewController *)self).mze_viewController willBecomeActive];
//     }
//   }

//   %orig;

// }

- (void)setPresented:(BOOL)presented {
  if (!presented && ((CCUIControlCenterViewController *)self).mze_viewController && ((CCUIControlCenterViewController *)self).presented && hasCalled) {
    [((CCUIControlCenterViewController *)self).mze_viewController willResignActive];
    [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
    ((CCUIControlCenterViewController *)self).mze_viewController.view.userInteractionEnabled = YES;
    hasCalled = NO;
  } else if (!hasCalled && presented) {
    [((CCUIControlCenterViewController *)self).mze_viewController willBecomeActive];
    hasCalled = YES;
  }
  %orig;
}
-(void)controlCenterWillFinishTransitionOpen:(BOOL)arg1 withDuration:(NSTimeInterval)arg2 {
  if (!arg1) {
    if (((CCUIControlCenterViewController *)self).mze_viewController && hasCalled) {
      hasCalled = NO;
      [((CCUIControlCenterViewController *)self).mze_viewController willResignActive];
      [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
      ((CCUIControlCenterViewController *)self).mze_viewController.view.userInteractionEnabled = YES;
    }
  }
  if (((CCUIControlCenterViewController *)self).mze_viewController) {
    ((CCUIControlCenterViewController *)self).mze_viewController.view.userInteractionEnabled = YES;
  }
  %orig;
}

-(void)controlCenterDidDismiss {
  %orig;
  if (((CCUIControlCenterViewController *)self).mze_viewController && hasCalled) {
      hasCalled = NO;
      [((CCUIControlCenterViewController *)self).mze_viewController willResignActive];
      [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
    }
}
%end

%hook CCUIControlCenterSettings
- (void)setUseNewBounce:(BOOL)useNewBounce {
  %orig(NO);
}

- (BOOL)useNewBounce {
  return NO;
}
%end

%hook SBControlCenterController
-(BOOL)handleMenuButtonTap {
  MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
  if (collectionViewController) {
    if ([collectionViewController handleMenuButtonTap]) return NO;
    //return YES;
  }

  return %orig;
}

// - (BOOL)dismissModalFullScreenIfNeeded {
//   // MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
//   // if (collectionViewController) {
//   //   return ![collectionViewController handleMenuButtonTap];
//   //   //return YES;
//   // }

//   return %orig;
// }

// - (void)dismissAnimated:(BOOL)animated withAdditionalAnimations:(void(^)(void))arg1 completion:(id)arg2 {
//     // MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
//     // if (collectionViewController) {
//     //   do {

//     //   } while ([collectionViewController handleMenuButtonTap] == NO);
//     // }


//     // arg1 = ^{
//     //   MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
//     //   if (collectionViewController) {
//     //     do {

//     //     } while ([collectionViewController handleMenuButtonTap] == NO);
//     //   }
//     // };
//     // if (!isLoading) {
//     //   MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
//     //   if (collectionViewController) {
//     //     do {

//     //     } while ([collectionViewController handleMenuButtonTap] == NO);
//     //   }
//     // }
//   // MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
//   // if (collectionViewController) {
//   //   do {

//   //   } while (![collectionViewController handleMenuButtonTap]);
//   // }
  

//   // MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
//   // if (collectionViewController) {
//   //   if ([collectionViewController handlDoubleMenuButtonTapWithCompletion:^{
//   //     %orig;
//   //   }]) {
//   //     return;
//   //   }
//   // }
//   %orig;
// }

- (BOOL)_shouldShowGrabberOnFirstSwipe {
  return NO;
}
%end


// %hook UIView
// %new
// - (void)addDarkThing {
// 	_MZEBackdropView *thing = [[_MZEBackdropView alloc] init];
// 	thing.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
// 	thing.saturation = 1.7;
// 	thing.brightness = -0.12;
// 	thing.colorMatrixColor = [UIColor colorWithRed:0.196 green:0.196 blue:0.196 alpha:0.5];
// 	[self addSubview:thing];

// }

// %new
// - (void)addDankFilter {

//   NSMutableArray *filters = [NSMutableArray new];
//   CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"luminanceToAlpha"];
//     [filter setValue:[NSNumber numberWithFloat:0.6] forKey:@"inputAmount"];
//     [filters addObject:filter];

//     [self.layer setFilters:[filters copy]];
// }
// %end

// %hook NSObject
// %new
// - (NSString *)inputColorMatrixValue {

//   if ([self valueForKey:@"inputColorMatrix"]) {
//     CAColorMatrix colorMatrix = [(NSValue *)[self valueForKey:@"inputColorMatrix"] CAColorMatrixValue];
//     return [NSString stringWithFormat:@"CAColorMatrix: {{%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}}", colorMatrix.m11, colorMatrix.m12, colorMatrix.m13, colorMatrix.m14, colorMatrix.m15, colorMatrix.m21, colorMatrix.m22, colorMatrix.m23, colorMatrix.m24, colorMatrix.m25, colorMatrix.m31, colorMatrix.m32, colorMatrix.m33, colorMatrix.m34, colorMatrix.m35, colorMatrix.m41, colorMatrix.m42, colorMatrix.m43, colorMatrix.m44, colorMatrix.m45];
//   }
//   return @"";
//   //return [NSString stringWithFormat:@"CAColorMatrix: {{%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}}", colorMatrix.m11, colorMatrix.m12, colorMatrix.m13, colorMatrix.m14, colorMatrix.m15, colorMatrix.m21, colorMatrix.m22, colorMatrix.m23, colorMatrix.m24, colorMatrix.m25, colorMatrix.m31, colorMatrix.m32, colorMatrix.m33, colorMatrix.m34, colorMatrix.m35, colorMatrix.m41, colorMatrix.m42, colorMatrix.m43, colorMatrix.m44, colorMatrix.m45];
    
// }
// %end


%hook CCUIButtonModule
- (id)controlCenterSystemAgent {
  id orig = %orig;
  if (orig) return orig;
  else return [[NSClassFromString(@"SBControlCenterController") sharedInstance] valueForKey:@"_systemAgent"];
}
%end

@interface SBLockScreenDateViewController : UIViewController
- (void)loadMaize;
@end

static BOOL loadedTimer = NO;

%hook SBLockScreenDateViewController
- (void)_startUpdateTimer {
  %orig;
  if (!loadedTimer) {
    loadedTimer = YES;
    [self performSelector:@selector(loadMaize) withObject:nil afterDelay:5.0];
  }
}

%new
- (void)loadMaize {
  if (!sharedController) {
    SBControlCenterController *controller = [NSClassFromString(@"SBControlCenterController") _sharedInstanceCreatingIfNeeded:YES];
    if (controller && [controller valueForKey:@"_viewController"]) {
      isLoading = YES;
      CCUIControlCenterViewController *viewController = [controller valueForKey:@"_viewController"];
      [viewController setRevealPercentage:0.0];
      //isLoading = NO;
    }
  }
  //[self performSelector:@selector(myMethod) withObject:nil afterDelay:3.0];
}
%end

// Preloading the CC so no lag on first swipe open

// %hook SBLockScreenViewController
// - (void)_createLockScreenActionManager {
//   %orig;
//   if (!sharedController) {
//     SBControlCenterController *controller = [NSClassFromString(@"SBControlCenterController") _sharedInstanceCreatingIfNeeded:YES];
//     //UIView *view = controller.view;
//     [controller _updateRevealPercentage:0.0];

//   }
// }
// %end

// %hook SBUIController
// - (BOOL)handleHomeButtonDoublePressDown {
//   // MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
//   // if (collectionViewController) {
//   //   do {

//   //   } while ([collectionViewController handleMenuButtonTap] == NO);
//   // }
//   return %orig;
// }
// %end

%ctor {
  NSString *controlCenterControllerClass;
  if (NSClassFromString(@"CCUIControlCenterViewController")) {
    controlCenterControllerClass = @"CCUIControlCenterViewController";
  } else {
    controlCenterControllerClass = @"SBControlCenterViewController";
    isIOS9 = YES;
  }

  %init(CCUIControlCenterViewControllerRootClass=NSClassFromString(controlCenterControllerClass));
}

