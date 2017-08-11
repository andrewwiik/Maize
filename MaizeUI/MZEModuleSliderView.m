#import "MZEModuleSliderView.h"
#import "MZECurrentActions.h"
#import "MZECAContinuousCornerLayer.h"
#import <UIKit/UIView+Private.h>
#import "macros.h"

@implementation MZEModuleSliderView
    @synthesize step=_step;
    @synthesize firstStepIsDisabled=_firstStepIsDisabled;
    @synthesize numberOfSteps=_numberOfSteps;
    @synthesize value=_value;
    @synthesize throttleUpdates=_throttleUpdates;
    @synthesize glyphVisible=_glyphVisible;



// + (Class) layerClass {
//    return [MZECAContinuousCornerLayer class];
// }

// - (void)setFrame:(CGRect)frame {
//     [super setFrame:frame];
//     [self layoutEverything];
// }

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
             //self.layer.delegate = self;
            _glyphVisible = YES;
            _throttleUpdates = NO;
            _numberOfSteps = 1;
            _firstStepIsDisabled = NO;
            [self _createStepViewsForNumberOfSteps:_numberOfSteps];
            [self setExclusiveTouch:YES];
    }
    return self;
}


- (void)setValue:(float)value {
    if (value != _value) {
        _value = value;
        if ([self isStepped]) {
            _step = [self _stepFromValue:_value];
        }
    }

    [self setNeedsLayout];
}

- (void)setStep:(NSUInteger)step {
    if ([self isStepped]) {
        if (_step != step) {
            _step = step;
            _value = [self _valueFromStep:_step];
            [self setNeedsLayout];
        }
    } else {
        HBLogError(@"Slider tried to step when it isn't a step slider");
    }
}

- (void)setNumberOfSteps:(NSUInteger)numberOfSteps {
    NSUInteger steps = 1;
    if (numberOfSteps > 1) {
        steps = numberOfSteps;
    }

    if (_numberOfSteps != steps) {
        _numberOfSteps = steps;
        [self _createStepViewsForNumberOfSteps:_numberOfSteps];
        [self _createSeparatorViewsForNumberOfSteps:_numberOfSteps];
    }
}

- (void)setFirstStepIsDisabled:(BOOL)isDisabled {
    if (_firstStepIsDisabled != isDisabled) {
        _firstStepIsDisabled = isDisabled;
        [self _createStepViewsForNumberOfSteps:_numberOfSteps];
    }
}

- (BOOL)isStepped {
    return _numberOfSteps > 1;
}

- (void)setGlyphImage:(UIImage *)glyphImage {
    if (_glyphImage != glyphImage) {
        _glyphImage = glyphImage;

        if (!_glyphImageView) {
            _glyphImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_glyphImageView setContentMode:4];
            [_glyphImageView setUserInteractionEnabled:NO];
            [self addSubview:_glyphImageView];
        }

        [_glyphImageView setImage:_glyphImage];
        [_glyphImageView sizeToFit];

        if ([_glyphImage renderingMode] == UIImageRenderingModeAlwaysTemplate) {
            // Apply Styling of the primary type MTVibrantStylingProvider controlCenterPrimaryVibrantStyling
        } else {
            // Remove Styling
        }


        _glyphImageView.alpha = _glyphVisible ? 1.0 : 0.0;

    }
}

- (void)setOtherGlyphPackage:(CAPackage *)otherGlyphPackage {
     if (_otherGlyphPackage != otherGlyphPackage) {
        _otherGlyphPackage = otherGlyphPackage;

        if (!_otherGlyphPackageView) {
            _otherGlyphPackageView = [[MZECAPackageView alloc] init];
            [_otherGlyphPackageView setStateName:[self glyphState]];
            [_otherGlyphPackageView setAutoresizingMask:0];
            _otherGlyphPackageView.layer.compositingFilter = @"destOut";
        }

        [_otherGlyphPackageView setPackage:_otherGlyphPackage];
    }
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
    if (_glyphPackage != glyphPackage) {
        _glyphPackage = glyphPackage;
        if (!_glyphPackageView) {
            _glyphPackageView = [[MZECAPackageView alloc] init];
            [_glyphPackageView setStateName:[self glyphState]];
            [_glyphPackageView setAutoresizingMask:0];
            _glyphPackageView.layer.compositingFilter = @"destOut";

            _glyphMaskView = [[UIView alloc] initWithFrame:self.bounds];
            [_glyphMaskView setAutoresizingMask:0];
            _glyphMaskView.autoresizesSubviews = YES;
            _glyphMaskView.backgroundColor = [UIColor clearColor];

            UIView *cutoutView = [[UIView alloc] initWithFrame:self.bounds];
            cutoutView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                           UIViewAutoresizingFlexibleHeight);
            cutoutView.backgroundColor = [UIColor blackColor];
            [_glyphMaskView addSubview:cutoutView];
            [cutoutView.layer addSublayer:_glyphPackageView.layer];
            //[self addSubview:_glyphPackageView];
        }

        [_glyphPackageView setPackage:_glyphPackage];
    }
}

- (void)setGlyphState:(NSString *)glyphState {
    if (glyphState != _glyphState) {
        _glyphState = glyphState;
        [_glyphPackageView setStateName:_glyphState];
        [_otherGlyphPackageView setStateName:_glyphState];
    }

        _glyphPackageView.alpha = _glyphVisible ? 1.0 : 0.0;
        _otherGlyphPackageView.alpha = _glyphVisible ? 1.0 : 0.0;
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    if (_glyphMaskView) {
        _glyphMaskView.alpha = alpha;
    }
}

- (void)layoutSubviews {

    if (!self.layer.delegate) {
        self.layer.delegate = self;
    }
    [super layoutSubviews];
    CGSize bounds = self.bounds.size;

   [self _layoutValueViews];

    CGFloat x = bounds.width*0.5;
    CGFloat y = bounds.height - x;
    CGPoint center = UIPointRoundToViewScale(CGPointMake(x,y), self);
    if (_glyphImageView) {
        _glyphImageView.center = center;
        _glyphImageView.alpha = _glyphVisible ? 1.0 : 0.01;
    }

    if (_glyphPackage) {
        _glyphPackageView.center = center;
        _otherGlyphPackageView.center = center;
        _glyphPackageView.alpha = _glyphVisible ? 1.0 : 0.01;
        _otherGlyphPackageView.alpha = _glyphVisible ? 1.0 : 0.01;
    }
}

// - (void)displayLayer:(CALayer *)layer {
//     if ([layer isKindOfClass:[MZECAContinuousCornerLayer class]]) {
//         if (((MZECAContinuousCornerLayer *)layer).continuousCorners != self._continuousCornerRadius) {
//             self._continuousCornerRadius = ((MZECAContinuousCornerLayer *)layer).continuousCorners;
//         }
//     }
// }

// - (void)layoutEverything {

//     CGSize bounds = self.bounds.size;
//     [self _layoutValueViews];
//     CGFloat x = bounds.width*0.5;
//     CGFloat y = bounds.height - x;
//     CGPoint center = UIPointRoundToViewScale(CGPointMake(x,y), self);
//     if (_glyphImageView) {
//         _glyphImageView.center = center;
//         _glyphImageView.alpha = _glyphVisible ? 1.0 : 0.0;
//     }

//     if (_glyphPackage) {
//         _glyphPackageView.center = center;
//         _otherGlyphPackageView.center = center;
//         _glyphPackageView.alpha = _glyphVisible ? 1.0 : 0.0;
//         _otherGlyphPackageView.alpha = _glyphVisible ? 1.0 : 0.0;
//     }
// }

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    _startingLocation = touchPoint;
    _startingHeight = CGRectGetHeight([self bounds]);
    _startingValue = _value;

    if (_throttleUpdates && !_updatesCommitTimer) {
        _previousValue = _value;
        _updatesCommitTimer = [NSTimer scheduledTimerWithTimeInterval:.1 repeats:YES block:^(NSTimer *timer) {
            if (_previousValue != _value) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
                _previousValue = _value;
            }
        }];
    }

    if ([self isStepped]) {
        [self _updateValueForTouchLocation:_startingLocation withAbsoluteReference:YES];
    }

    [MZECurrentActions setIsSliding:YES];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectGetHeight([self bounds]) != _startingHeight) {
        _startingLocation = touchPoint;
        _startingHeight = CGRectGetHeight([self bounds]);
        _startingValue = _value;
    }

    [self _updateValueForTouchLocation:touchPoint withAbsoluteReference:[self isStepped]];
    if (!_throttleUpdates) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [_updatesCommitTimer invalidate];
    _updatesCommitTimer = nil;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [MZECurrentActions setIsSliding:NO];
}

- (BOOL)isContentClippingRequired {
    return YES;
}

- (BOOL)isGroupRenderingRequired {
    return _glyphPackage ? YES : NO;
}

- (void)_layoutValueViews {
    if ([self isStepped]) {
        for (NSUInteger x = 0; x < _numberOfSteps; x++) {
            UIView *stepBackgroundView = [_stepBackgroundViews objectAtIndex:x];

            if (x < _numberOfSteps - 1) {
                UIView *separatorView = [_separatorViews objectAtIndex:x];
                CGRect bounds = [self bounds];
                CGFloat separatorOriginY = CGRectGetHeight(bounds) - (([self _fullStepHeight] * (x + 1)) - (x + 1));
                CGRect seperatorFrame = CGRectMake(0,separatorOriginY,CGRectGetWidth(bounds), 1.0);
                separatorView.frame = seperatorFrame;
            }

            if (x < _step) {
                [stepBackgroundView setAlpha:1];
                CGRect bounds = [self bounds];
                //[UIView performWithoutAnimation:^{
                    CGFloat fullStepHeight = [self _fullStepHeight];
                    CGFloat stepOriginY = CGRectGetHeight(bounds) - ((fullStepHeight * x) - [self _heightForStep:(x+1)] - x);
                    CGRect stepFrame = CGRectMake(0,stepOriginY,CGRectGetWidth(bounds),[self _heightForStep:x + 1]);
                    stepBackgroundView.frame = stepFrame;
               // }];
            } else {
                [stepBackgroundView setAlpha:0];
            }
        }

    } else {
        CGRect bounds = self.bounds;
        CGFloat sliderHeight = UICeilToViewScale([self _sliderHeight], self);
        CGRect sliderFrame = CGRectMake(0,CGRectGetHeight(bounds) - sliderHeight, CGRectGetWidth(bounds), sliderHeight);
        [(UIView *)[_stepBackgroundViews objectAtIndex:0] setFrame:sliderFrame];
        if (_glyphMaskView) {
            if ([(MZEMaterialView *)[_stepBackgroundViews objectAtIndex:0] backdropView].maskView == nil) {
                [(MZEMaterialView *)[_stepBackgroundViews objectAtIndex:0] backdropView].maskView = _glyphMaskView;
            }

            _glyphMaskView.frame = CGRectMake(0,0 - (CGRectGetHeight(bounds) - sliderHeight), CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        }
    }
}

- (void)_createStepViewsForNumberOfSteps:(NSUInteger)numberOfSteps {
    NSMutableArray *stepsArray = [NSMutableArray arrayWithCapacity:numberOfSteps];
    if (stepsArray) {
        for (NSUInteger x = 0; x < numberOfSteps; x++) {
            MZEMaterialView *stepView = [self _createBackgroundViewForStep:x+1];
            [self addSubview:stepView];
            [stepsArray addObject:stepView];
            
        }
    }

    for (MZEMaterialView *stepView in _stepBackgroundViews) {
        [stepView removeFromSuperview];
        stepView.backdropView.maskView = nil;
    }

    _stepBackgroundViews = stepsArray;

    if (![self isStepped] && numberOfSteps > 0 && _glyphMaskView) {
        ((MZEMaterialView *)_stepBackgroundViews[0]).backdropView.maskView = _glyphMaskView;
    }
}

- (void)_createSeparatorViewsForNumberOfSteps:(NSUInteger)numberOfSteps {
    if ([self isStepped]) {
        NSMutableArray *separatorsArray = [NSMutableArray arrayWithCapacity:numberOfSteps - 1];
        if (separatorsArray) {
            for (NSUInteger x = 0; x < numberOfSteps - 1; x++) {
                MZEMaterialView *separatorView = [self _createSeparatorView];
                [self addSubview:separatorView];
                [separatorsArray addObject:separatorView];
            }
        }

        for (MZEMaterialView *separatorView in _separatorViews) {
            [separatorView removeFromSuperview];
        }

        _separatorViews = separatorsArray;
    } else {
        _separatorViews = nil;
    }
}

- (MZEMaterialView *)_createBackgroundViewForStep:(NSUInteger)step {
    MZEMaterialView *materialView;
    if (step == 1 && [self isStepped] && [self firstStepIsDisabled]) {
        materialView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
    } else {
        materialView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleLight];
        materialView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }

    [materialView setUserInteractionEnabled:NO];
    return materialView;
}

- (MZEMaterialView *)_createSeparatorView {
    MZEMaterialView *materialView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
    [materialView setUserInteractionEnabled:NO];
    return materialView;
}

- (CGFloat)_sliderHeight {
    return CGRectGetHeight([self bounds]) * _value;
}

- (CGFloat)_fullStepHeight {
    CGFloat usableHeight = [self _sliderHeight] - (1 * (_numberOfSteps - 1));
    return UIRoundToViewScale(usableHeight/_numberOfSteps + -1, self);
}

- (CGFloat)_heightForStep:(NSUInteger)step { // 1
    NSUInteger otherStep = [self _stepFromValue:_value] - 1; // 4
    if (otherStep <= step) { // 4 <= 5
        CGFloat result = 0.0;
        if ((otherStep + 1) == step) {
            CGFloat sliderHeight = [self _sliderHeight];
            CGFloat fullStepHeight = [self _fullStepHeight];
            result = sliderHeight - (fullStepHeight * otherStep);
        } else {
            result = [self _fullStepHeight];
        }
        return result;
    } else {
        return [self _fullStepHeight];
    }
}

- (NSUInteger)_stepFromValue:(float)value {
    if (_numberOfSteps <= 1) {
        return 1;
    } else {
        NSUInteger step = ceilf((float)_numberOfSteps * value);
        if ([self firstStepIsDisabled] && step == 0)
            step = 1;
        return step; 
    }
}

- (float)_valueFromStep:(NSUInteger)step {
    if (step > 0 && _numberOfSteps > 0) {
        return step/_numberOfSteps;
    } else {
        if (step > 0) {
            return 1;
        } else {
            return INFINITY;
        }
    }
}

- (void)_updateValueForTouchLocation:(CGPoint)touchLocation withAbsoluteReference:(BOOL)absoluteReference {
    CGFloat finalValue;
    if (absoluteReference) {
        CGFloat frameHeight = CGRectGetHeight([self bounds]);
        finalValue = (frameHeight - touchLocation.y)/frameHeight;
    } else {
        CGFloat difference = _startingLocation.y - touchLocation.y;
        CGFloat frameHeight = CGRectGetHeight([self bounds]);
        finalValue = (difference/frameHeight) + _startingValue;
    }
    _value = fminf(fmaxf(finalValue, 0.0), 1.0);
    if ([self isStepped]) {
        [self _updateStepFromValue:_value];
    } else {
        [self _layoutValueViews];
    }
}

- (void)_updateStepFromValue:(float)value {
    _step = [self _stepFromValue:value];
    _value = [self _valueFromStep:_step];

    [UIView animateWithDuration:0.25 animations:^{
        [self _layoutValueViews];
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         [self setNeedsLayout];
         [self layoutIfNeeded];
        // [_sliderView _layoutValueViews];
        // do whatever
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) { 

    }];
}

- (BOOL)isExclusiveTouch {
    return YES;
}

- (void)setGlyphVisible:(BOOL)visible {
    _glyphVisible = visible;
    // [UIView performWithoutAnimation:^{
    //     _glyphImageView.alpha = _glyphVisible ? 1.0 : 0.0;
    //     _glyphPackageView.alpha = _glyphVisible ? 1.0 : 0.0;
    //     _otherGlyphPackageView.alpha = _glyphVisible ? 1.0 : 0.0;
    // }];

}

- (CALayer *)punchOutRootLayer {
    return [_otherGlyphPackageView layer];
}

- (CGFloat)layerCornerRadius {
    return self._continuousCornerRadius;
}

- (void)setLayerCornerRadius:(CGFloat)radius {

    if (self._continuousCornerRadius != radius && !self.displayLinkActive) {
        _startAlpha = 0;
        _wantedAlpha = 1.0;
        self.wantedRadius = radius;
        self.startRadius = self._continuousCornerRadius;
        self.radiusDiff = _wantedRadius - _startRadius;

        if (!_displayLinkActive) {
            self.percent = 0;
            if (!self.displayLink) {
                self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
            
            }
            // self.displayLink.frameInterval = 2;
            self.startTime = CACurrentMediaTime();
            self.displayLinkActive = YES;
            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }



    // ((MZECAContinuousCornerLayer *)self.layer).continuousCorners = radius;
    // [self setNeedsDisplay];
}

- (void)stopDisplayLink {
    if (self.displayLink && _displayLinkActive) {
        self._continuousCornerRadius = _wantedRadius;
        self.wantedRadius = 0;
        self.startRadius = 0;
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        // [self.displayLink invalidate];
        // self.displayLink = nil;
        self.displayLinkActive = NO;
    }
    // [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    // [self.displayLink invalidate];
    // self.displayLink = nil;
    // _displayLinkActive = NO;
    // _wantedRadius = 9999;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    CFAbsoluteTime elapsed = CACurrentMediaTime() - self.startTime;
    self.percent = elapsed / 0.325 - floor(elapsed / 0.325);
   // _percent = _glyphPackageView.alpha;
   // self.backgroundColor = [UIColor colorWithWhite:0 alpha:_startAlpha + ((_wantedAlpha - _startAlpha)*_percent)];
    CGFloat cornerRadius = UIRoundToViewScale(self.startRadius + (self.radiusDiff*self.percent), self);
    if (cornerRadius != self._continuousCornerRadius) {
        //[UIView performWithoutAnimation:^{
             self._continuousCornerRadius = cornerRadius;

             if (cornerRadius == self.wantedRadius) {
                [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                self._continuousCornerRadius = self.wantedRadius;
                self.displayLinkActive = NO;
             }
             // //[self.layer setNeedsDisplay];
             // if (_wantedRadius == 38.0) {
             //   // self.backgroundColor = [UIColor redColor];
             // }
       // }];
    }

    // if (elapsed >= 14.99) {
    //     [self stopDisplayLink];
    // } else if (_percent >= 1.0) {
    //      [self stopDisplayLink];
    // }
}


// - (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
//     if ([event isEqualToString:@"cornerRadius"]) {
//         CABasicAnimation *boundsAnimation;
//         boundsAnimation = (id)[layer animationForKey:@"bounds.size"];
        
//         if (boundsAnimation) {
//             CABasicAnimation *animation = (id)boundsAnimation.copy;
//             animation.keyPath = @"cornerRadius";
            
//             CornerRadiusAnimationAction *action;
//             action = [CornerRadiusAnimationAction new];
//             action.pendingAnimation = animation;
//             action.priorCornerRadius = layer.cornerRadius;
//             return action;
//         }
        
//     }
    
//     return [super actionForLayer:layer forKey:event];
// }




- (BOOL)shouldForwardSelector:(SEL)aSelector {
    if (aSelector == @selector(setBounds:)) return NO;
    if (aSelector == @selector(_setContinuousCornerRadius:)) return YES;
    if (aSelector == @selector(_continuousCornerRadius)) return YES;
    return [self.layer respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
     if (aSelector == @selector(_setContinuousCornerRadius:)) return self;
     if (aSelector == @selector(_continuousCornerRadius)) return self;
    return (![self respondsToSelector:aSelector] && [self shouldForwardSelector:aSelector]) ? self.layer : self;
}

- (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key {
    if (key) {
        //if ([key isEqual:@"_continuousCornerRadius"] || [key isEqual:@"_setContinuousCornerRadius:"]) return YES;
        // if ([key isEqual:@"cornerContentsCenter"] || [key isEqual:@"cornerContents"] || [key isEqual:@"cornerRadius"]) return YES;
        // if ([key isEqual:@"scale"] || [key isEqual:@"anchor"]) return YES;
    }
    //if ([key isEqual:@"_continuousCornerRadius"] || [key isEqual:@"_setContinuousCornerRadius:"]) return YES;
    return ([self shouldForwardSelector:NSSelectorFromString(key)] || [super _shouldAnimatePropertyWithKey:key]);
}
@end