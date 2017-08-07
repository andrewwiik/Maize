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
@property (nonatomic, retain) MZEModularControlCenterViewController *mze_viewController;
- (BOOL)isPresented;
@end


@interface CALayer (MZE)
@property (nonatomic, assign) BOOL allowsGroupBlending;
@end

static BOOL hasCalled = NO;

%hook CCUIControlCenterViewController
%property (nonatomic, retain) MZEModularControlCenterViewController *mze_viewController;

-(void)setRevealPercentage:(CGFloat)revealPercentage {

  if (!self.mze_viewController) {
    self.mze_viewController = [[MZEModularControlCenterOverlayViewController alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.mze_viewController.view];
    [self addChildViewController:self.mze_viewController];
    [self.mze_viewController didMoveToParentViewController:self];

    // [self.mze_viewController loadView];
    // [self.mze_viewController viewDidLoad];
    // [self.mze_viewController viewWillLayoutSubviews];
   // self.mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    // [self.view addSubview:self.mze_viewController.view];
    //self.mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  }

  %orig;

  if (!self.presented && !hasCalled) {
    [self.mze_viewController willBecomeActive];
  }

  self.mze_viewController.view.userInteractionEnabled = YES;
  hasCalled = YES;

 // self.mze_viewController.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);

  // [self.mze_viewController ]
  // if (!self.mze_animatedBlurView) {

  //   self.luminanceViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
  //   self.luminanceViewHolder.layer.allowsGroupBlending = NO;
  //   [self.view addSubview:self.luminanceViewHolder];
  // 	self.mze_lumnianceView = [[_MZEBackdropView alloc] init];
  // 	self.mze_lumnianceView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
  // 	self.mze_lumnianceView.luminanceAlpha = 1.0f;
  //   //self.mze_lumnianceView.alpha = 0.45;
  // 	[self.luminanceViewHolder addSubview:self.mze_lumnianceView];
  // 	self.mze_animatedBlurView = [[MZEAnimatedBlurView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
  // 	self.mze_animatedBlurView.backdropSettings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:-2];
  // 	self.mze_animatedBlurView.backdropSettings.blurRadius = 30.0f;
  // 	self.mze_animatedBlurView.backdropSettings.saturationDeltaFactor = 1.9f;
  //   self.mze_animatedBlurView.backdropSettings.grayscaleTintAlpha = 0;
  //   self.mze_animatedBlurView.backdropSettings.colorTintAlpha = 0;
  //   self.mze_animatedBlurView.backdropSettings.grayscaleTintLevel = 0;
  //   self.mze_animatedBlurView.backdropSettings.usesGrayscaleTintView = NO;
  //   self.mze_animatedBlurView.backdropSettings.usesColorTintView = NO;

  // 	[self.view addSubview:self.mze_animatedBlurView];
  // 	[self.view bringSubviewToFront:self.mze_animatedBlurView];
  // }

  // if (!self.moduleViewHolder) {
  //   self.moduleViewHolder = [[MZEModuleCollectionViewController alloc] initWithFrame:self.view.frame];
  //   [self.view addSubview:self.moduleViewHolder.view];
  //   //[self.view bringSubviewToFront:self.mod]
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
  //   self.moduleViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
  //   [self.view addSubview:self.moduleViewHolder];
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

  for (UIView *subview in self.view.subviews) {
  	if (subview != self.mze_viewController.view) {
  		subview.alpha = 0;
  		subview.hidden = YES;
  	}
  }



  [self.mze_viewController revealWithProgress:revealPercentage];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch {
  if ([recognizer isKindOfClass:NSClassFromString(@"UITapGestureRecognizer")] || [recognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]) {
    if ([NSClassFromString(@"MZECurrentActions") isSliding]) {
      return NO;
    } else {
      return %orig;
    }
  } else {
    return YES;
  }
}

// -(BOOL)gestureRecognizerShouldBegin:(id)arg1 {

// }

// -(void)controlCenterWillPresent {
//   %orig;
//   if (self.mze_viewController) {
//     [self.mze_viewController willBecomeActive];
//   }
// }

// -(void)controlCenterDidDismiss {
//   %orig;
//   if (self.mze_viewController) {
//     [self.mze_viewController willResignActive];
//   }
// }

// -(void)controlCenterWillBeginTransition {
//   if (![self isPresented]) {
//     if (self.mze_viewController) {
//       [self.mze_viewController willBecomeActive];
//     }
//   }
// }
// -(void)controlCenterDidFinishTransition {
//   %orig;
//   if ([self isPresented]) {
//     if (self.mze_viewController) {
//       [self.mze_viewController willResignActive];
//     }
//   }
// }

// -(void)_handlePan:(UIPanGestureRecognizer *)recognizer {
//   if (recognizer.state == UIGestureRecognizerStateBegan) {
//     if (!self.mze_viewController) {
//       self.mze_viewController = [[MZEModularControlCenterViewController alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
//       [self.mze_viewController loadView];
//       self.mze_viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//       [self.view addSubview:self.mze_viewController.view];
//     }

//     if (!self.presented) {
//       [self.mze_viewController willBecomeActive];
//     }
//   }

//   %orig;

// }

- (void)setPresented:(BOOL)presented {
  if (!presented && self.mze_viewController && self.presented && hasCalled) {
    [self.mze_viewController willResignActive];
    self.mze_viewController.view.userInteractionEnabled = YES;
    hasCalled = NO;
  }
  %orig;
}
-(void)controlCenterWillFinishTransitionOpen:(BOOL)arg1 withDuration:(NSTimeInterval)arg2 {
  if (!arg1) {
    if (self.mze_viewController && hasCalled) {
      hasCalled = NO;
      [self.mze_viewController willResignActive];
      self.mze_viewController.view.userInteractionEnabled = YES;
    }
  }
  if (self.mze_viewController) {
    self.mze_viewController.view.userInteractionEnabled = YES;
  }
  %orig;
}

-(void)controlCenterDidDismiss {
  %orig;
  if (self.mze_viewController && hasCalled) {
      hasCalled = NO;
      [self.mze_viewController willResignActive];
    }
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

// %new
// - (void)doGradientThing {
//   CAGradientLayer *gradient = [CAGradientLayer layer];
//   gradient.frame = view.bounds;

// }

// %new
// - (id)binPackingTest {
// 	BinPackingFactory2D *binPackingFactory2D = [[BinPackingFactory2D alloc] initWithStorageWidth:4 
//                                                                                    storageHeight:6 
//                                                                            	storageHeightLimited:NO];

// 	NSMutableArray *inputRectangles = [NSMutableArray new];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,2,2)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,2,1)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,1,1)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,2,2)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,2,1)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,1,1)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,1,1)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,1,1)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,1,1)]];
// 	[inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,1,1)]];

// 	[binPackingFactory2D shelfNextFitDecreasingAlgorithm2DForGivenRectangles:inputRectangles];
//     [binPackingFactory2D showStorageUsageDetails];
//     return binPackingFactory2D;
// }
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

