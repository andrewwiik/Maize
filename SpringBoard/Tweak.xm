#import <MaizeUI/MZEAnimatedBlurView.h>
#import <MaizeUI/_MZEBackdropView.h>
#import <MaizeUI/MZELayoutOptions.h>
// #import "BinPackingFactory2D.h"
#import <MaizeUI/MZEModularControlCenterOverlayViewController.h>
#import <MaizeUI/MZECurrentActions.h>
#import <QuartzCore/CAFilter+Private.h>
#import <ControlCenterUI/CCUIControlCenterViewController.h>
#import <UIKit/_UIBackdropViewSettings+Private.h>

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


@interface SBControlCenterController : UIViewController
@property (assign,getter=isPresented,nonatomic) BOOL presented;
@end

%hook SBControlCenterController

- (void)updateTransitionWithTouchLocation:(CGPoint)location velocity:(CGPoint)velocity {
    if (NSClassFromString(@"CCUIControlCenterViewController")) {
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

%hook CCUIControlCenterViewControllerRootClass
%property (nonatomic, retain) MZEModularControlCenterViewController *mze_viewController;

-(CGFloat)_scrollviewContentMaxHeight {
  if (((CCUIControlCenterViewController *)self).mze_viewController) {
    return CGRectGetHeight(((CCUIControlCenterViewController *)self).view.bounds) - [((CCUIControlCenterViewController *)self).mze_viewController _targetPresentationFrame].origin.y;
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
  return;
}
//    if (!((CCUIControlCenterViewController *)self).mze_viewController) {
//     ((CCUIControlCenterViewController *)self).mze_viewController = [[MZEModularControlCenterOverlayViewController alloc] initWithFrame:CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height)];
//     [((CCUIControlCenterViewController *)self).view addSubview:((CCUIControlCenterViewController *)self).mze_viewController.view];
//     [self addChildViewController:((CCUIControlCenterViewController *)self).mze_viewController];
//     [((CCUIControlCenterViewController *)self).mze_viewController didMoveToParentViewController:self];

//     // [((CCUIControlCenterViewController *)self).mze_viewController loadView];
//     // [((CCUIControlCenterViewController *)self).mze_viewController viewDidLoad];
//     // [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
//    // ((CCUIControlCenterViewController *)self).mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//     // [((CCUIControlCenterViewController *)self).view addSubview:((CCUIControlCenterViewController *)self).mze_viewController.view];
//     //((CCUIControlCenterViewController *)self).mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//   }
// }

-(void)setRevealPercentage:(CGFloat)revealPercentage {

  if (!((CCUIControlCenterViewController *)self).mze_viewController) {
    ((CCUIControlCenterViewController *)self).mze_viewController = [[MZEModularControlCenterOverlayViewController alloc] initWithFrame:CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height)];
    sharedController = ((CCUIControlCenterViewController *)self).mze_viewController;
    [((CCUIControlCenterViewController *)self).view addSubview:((CCUIControlCenterViewController *)self).mze_viewController.view];
    [self addChildViewController:((CCUIControlCenterViewController *)self).mze_viewController];
    [((CCUIControlCenterViewController *)self).mze_viewController didMoveToParentViewController:self];

    // [((CCUIControlCenterViewController *)self).mze_viewController loadView];
    // [((CCUIControlCenterViewController *)self).mze_viewController viewDidLoad];
    // [((CCUIControlCenterViewController *)self).mze_viewController viewWillLayoutSubviews];
   // ((CCUIControlCenterViewController *)self).mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    // [((CCUIControlCenterViewController *)self).view addSubview:((CCUIControlCenterViewController *)self).mze_viewController.view];
    //((CCUIControlCenterViewController *)self).mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  }

  // if (((CCUIControlCenterViewController *)self).mze_viewController && ((CCUIControlCenterViewController *)self).presented) {
  //   revealPercentage = revealPercentage * (((CCUIControlCenterViewController *)self).view.bounds.size.height/(CGRectGetHeight(((CCUIControlCenterViewController *)self).view.bounds) - [((CCUIControlCenterViewController *)self).mze_viewController _targetPresentationFrame].origin.y));
  //   //revealPercentage = fmaxf(fminf(revealPercentage, 1.0), 0.0);
  // }
  %orig(revealPercentage);

  if (!((CCUIControlCenterViewController *)self).presented && !hasCalled) {
    [((CCUIControlCenterViewController *)self).mze_viewController willBecomeActive];
  }

  ((CCUIControlCenterViewController *)self).mze_viewController.view.userInteractionEnabled = YES;
  hasCalled = YES;

 // ((CCUIControlCenterViewController *)self).mze_viewController.frame = CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height);

  // [((CCUIControlCenterViewController *)self).mze_viewController ]
  // if (!self.mze_animatedBlurView) {

  //   self.luminanceViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height)];
  //   self.luminanceViewHolder.layer.allowsGroupBlending = NO;
  //   [((CCUIControlCenterViewController *)self).view addSubview:self.luminanceViewHolder];
  // 	self.mze_lumnianceView = [[_MZEBackdropView alloc] init];
  // 	self.mze_lumnianceView.frame = CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height);
  // 	self.mze_lumnianceView.luminanceAlpha = 1.0f;
  //   //self.mze_lumnianceView.alpha = 0.45;
  // 	[self.luminanceViewHolder addSubview:self.mze_lumnianceView];
  // 	self.mze_animatedBlurView = [[MZEAnimatedBlurView alloc] initWithFrame:CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width,((CCUIControlCenterViewController *)self).view.frame.size.height)];
  // 	self.mze_animatedBlurView.backdropSettings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:-2];
  // 	self.mze_animatedBlurView.backdropSettings.blurRadius = 30.0f;
  // 	self.mze_animatedBlurView.backdropSettings.saturationDeltaFactor = 1.9f;
  //   self.mze_animatedBlurView.backdropSettings.grayscaleTintAlpha = 0;
  //   self.mze_animatedBlurView.backdropSettings.colorTintAlpha = 0;
  //   self.mze_animatedBlurView.backdropSettings.grayscaleTintLevel = 0;
  //   self.mze_animatedBlurView.backdropSettings.usesGrayscaleTintView = NO;
  //   self.mze_animatedBlurView.backdropSettings.usesColorTintView = NO;

  // 	[((CCUIControlCenterViewController *)self).view addSubview:self.mze_animatedBlurView];
  // 	[((CCUIControlCenterViewController *)self).view bringSubviewToFront:self.mze_animatedBlurView];
  // }

  // if (!self.moduleViewHolder) {
  //   self.moduleViewHolder = [[MZEModuleCollectionViewController alloc] initWithFrame:((CCUIControlCenterViewController *)self).view.frame];
  //   [((CCUIControlCenterViewController *)self).view addSubview:self.moduleViewHolder.view];
  //   //[((CCUIControlCenterViewController *)self).view bringSubviewToFront:self.mod]
  // }

  // if (!self.animator && self.moduleViewHolder && self.moduleViewHolder.view) {


  //   self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveLinear animations:^{
  //     self.moduleViewHolder.view.frame = self.moduleViewHolder.openFrame;
  //   }];
  // }

  // if (self.animator) {
  //   self.animator.fractionComplete = revealPercentage;
  // }



  // if (!self.moduleViewHolder) {
  //   self.moduleViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0,((CCUIControlCenterViewController *)self).view.frame.size.width, ((CCUIControlCenterViewController *)self).view.frame.size.height)];
  //   [((CCUIControlCenterViewController *)self).view addSubview:self.moduleViewHolder];
  //   CGFloat moduleSize = [MZELayoutOptions edgeSize];
  //   CGFloat moduleSpacing = [MZELayoutOptions itemSpacingSize];
  //   CGFloat edgeInset = [MZELayoutOptions edgeInsetSize];
  //   CGFloat cornerRadius = 19.0f;

  //   NSMutableArray *inputRectangles = [NSMutableArray new];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,2,2)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(2,0,2,2)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,2,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(1,2,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(2,2,1,2)]]; //
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(3,2,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,3,2,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(3,3,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,4,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(1,4,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(2,4,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(3,4,1,1)]];
  //   [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,5,1,1)]];

  //   for (NSValue *placement in inputRectangles) {
  //     CGRect placementRect = [placement CGRectValue];
  //     int x = placementRect.origin.x+1;
  //     int y = placementRect.origin.y+1;
  //     int w = placementRect.size.width;
  //     int h = placementRect.size.height;

  //     CGFloat xOrigin = edgeInset+((x-1)*moduleSize)+((x-1)*moduleSpacing);
  //     CGFloat yOrigin = 0 + (moduleSize*(y-1)) + (moduleSpacing*(y-1));

  //     CGFloat height = (moduleSize*h)+(moduleSpacing*(h-1));
  //     CGFloat width = (moduleSize*w)+(moduleSpacing*(w-1));

  //     UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin,yOrigin,width,height)];
  //     [self.moduleViewHolder addSubview:firstView];
  //     // firstView.cornerRadius = cornerRadius;
  //     // firstView.clipsToBounds = YES;

  //     UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)];
  //     secondView.layer.allowsGroupBlending = NO;
  //     [firstView addSubview:secondView];

  //     _MZEBackdropView *dark = [[_MZEBackdropView alloc] initWithFrame:CGRectMake(0,0,width,height)];
  //     dark.layer.cornerRadius = cornerRadius;
  //     dark.clipsToBounds = YES;

  //     dark.saturation = 1.8;

  //     CAColorMatrix darkColorMatrix = {
  //       0.5f, 0, 0, 0, 0.058f,
  //       0, 0.5f, 0, 0, 0.058f,
  //       0, 0, 0.5f, 0, 0.058f,
  //       0, 0, 0, 1.0f, 0
  //     };

  //     dark.forcedColorMatrix = [NSValue valueWithCAColorMatrix:darkColorMatrix];
  //     dark.brightness = -0.12;

  //     [secondView addSubview:dark];


  //   }
    // for (int x = 1; x < 5; x++) {
    //   for (int y = 1; y < 7; y++) {
    //     CGFloat xOrigin = edgeInset+((x-1)*moduleSize)+((x-1)*moduleSpacing);
    //     CGFloat yOrigin = 0 + (moduleSize*(y-1)) + (moduleSpacing*(y-1));

    //     UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin,yOrigin,moduleSize,moduleSize)];
    //     [self.moduleViewHolder addSubview:firstView];
    //     // firstView.cornerRadius = cornerRadius;
    //     // firstView.clipsToBounds = YES;

    //     UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0,0,moduleSize,moduleSize)];
    //     secondView.layer.allowsGroupBlending = NO;
    //     [firstView addSubview:secondView];

    //     _MZEBackdropView *dark = [[_MZEBackdropView alloc] initWithFrame:CGRectMake(0,0,moduleSize,moduleSize)];
    //     dark.layer.cornerRadius = cornerRadius;
    //     dark.clipsToBounds = YES;

    //     dark.saturation = 1.7;

    //     CAColorMatrix darkColorMatrix = {
    //       0.5f, 0, 0, 0, 0.098f,
    //       0, 0.5f, 0, 0, 0.098f,
    //       0, 0, 0.5f, 0, 0.098f,
    //       0, 0, 0, 1.0f, 0
    //     };

    //     dark.forcedColorMatrix = [NSValue valueWithCAColorMatrix:darkColorMatrix];
    //     dark.brightness = -0.12;

    //     [secondView addSubview:dark];

    //     BOOL makeHighlighted = NO;
    //     if (!(y % 2)) {
    //       if (!(x % 2)) {
    //         makeHighlighted = YES;
    //       }
    //     } else if (y % 2) {
    //       if (x % 2) {
    //         makeHighlighted = YES;
    //       }
    //     }

    //     if (makeHighlighted) {

    //       UIView *thirdView =  [[UIView alloc] initWithFrame:CGRectMake(0,0,moduleSize,moduleSize)];
    //       [firstView addSubview:thirdView];

    //       UIView *fourthView = [[UIView alloc] initWithFrame:CGRectMake(0,0,moduleSize,moduleSize)];
    //       [thirdView addSubview:fourthView];

    //       UIView *fifthView = [[UIView alloc] initWithFrame:CGRectMake(0,0,moduleSize,moduleSize)];
    //       fifthView.layer.allowsGroupBlending = NO;
    //       [fourthView addSubview:fifthView];

    //       _MZEBackdropView *light = [[_MZEBackdropView alloc] initWithFrame:CGRectMake(0,0,moduleSize,moduleSize)];
    //       light.layer.cornerRadius = cornerRadius;
    //       light.clipsToBounds = YES;

    //       light.saturation = 1.6;
    //       light.brightness = 0.52;
    //       light.colorAddColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];

    //       [fifthView addSubview:light];

    //     }
    //   }
    // }
  // }

  for (UIView *subview in ((CCUIControlCenterViewController *)self).view.subviews) {
  	if (subview != ((CCUIControlCenterViewController *)self).mze_viewController.view) {
  		subview.alpha = 0;
  		subview.hidden = YES;
  	}
  }



  [((CCUIControlCenterViewController *)self).mze_viewController revealWithProgress:revealPercentage];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch {
  return NO;
}

-(BOOL)gestureRecognizerShouldBegin:(id)arg1 {
  return NO;
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

%hook SBControlCenterController
-(BOOL)handleMenuButtonTap {
  MZEModuleCollectionViewController *collectionViewController = [MZEModularControlCenterOverlayViewController sharedCollectionViewController];
  if (collectionViewController) {
    if ([collectionViewController handleMenuButtonTap]) {
      return YES;
    }
  }

  return %orig;
}
%end


%hook UIView
%new
- (void)addDarkThing {
	_MZEBackdropView *thing = [[_MZEBackdropView alloc] init];
	thing.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
	thing.saturation = 1.7;
	thing.brightness = -0.12;
	thing.colorMatrixColor = [UIColor colorWithRed:0.196 green:0.196 blue:0.196 alpha:0.5];
	[self addSubview:thing];

}

%new
- (void)addDankFilter {

  NSMutableArray *filters = [NSMutableArray new];
  CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"luminanceToAlpha"];
    [filter setValue:[NSNumber numberWithFloat:0.6] forKey:@"inputAmount"];
    [filters addObject:filter];

    [self.layer setFilters:[filters copy]];
}
%end

%hook NSObject
%new
- (NSString *)inputColorMatrixValue {

  if ([self valueForKey:@"inputColorMatrix"]) {
    CAColorMatrix colorMatrix = [(NSValue *)[self valueForKey:@"inputColorMatrix"] CAColorMatrixValue];
    return [NSString stringWithFormat:@"CAColorMatrix: {{%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}}", colorMatrix.m11, colorMatrix.m12, colorMatrix.m13, colorMatrix.m14, colorMatrix.m15, colorMatrix.m21, colorMatrix.m22, colorMatrix.m23, colorMatrix.m24, colorMatrix.m25, colorMatrix.m31, colorMatrix.m32, colorMatrix.m33, colorMatrix.m34, colorMatrix.m35, colorMatrix.m41, colorMatrix.m42, colorMatrix.m43, colorMatrix.m44, colorMatrix.m45];
  }
  return @"";
  //return [NSString stringWithFormat:@"CAColorMatrix: {{%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}}", colorMatrix.m11, colorMatrix.m12, colorMatrix.m13, colorMatrix.m14, colorMatrix.m15, colorMatrix.m21, colorMatrix.m22, colorMatrix.m23, colorMatrix.m24, colorMatrix.m25, colorMatrix.m31, colorMatrix.m32, colorMatrix.m33, colorMatrix.m34, colorMatrix.m35, colorMatrix.m41, colorMatrix.m42, colorMatrix.m43, colorMatrix.m44, colorMatrix.m45];
    
}
%end


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

