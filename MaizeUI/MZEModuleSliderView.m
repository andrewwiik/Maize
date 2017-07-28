#import "MZEModuleSliderView.h"

#if __cplusplus
    extern "C" {
#endif
    CGPoint UIPointRoundToViewScale(CGPoint point, UIView *view);
    CGFloat UICeilToViewScale(CGFloat value, UIView *view);
    CGFloat UIRoundToViewScale(CGFloat value, UIView *view);
#if __cplusplus
}
#endif

@implementation MZEModuleSliderView
    @synthesize step=_step;
    @synthesize firstStepIsDisabled=_firstStepIsDisabled;
    @synthesize numberOfSteps=_numberOfSteps;
    @synthesize value=_value;
    @synthesize throttleUpdates=_throttleUpdates;
    @synthesize glyphVisible=_glyphVisible;



- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
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

        _glyphImageView.alpha = _glyphVisible ? : 1.0 : 0.0;

    }
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
    if (_glyphPackage != glyphPackage) {
        _glyphPackage = glyphPackage;
        if (!_glyphPackageView) {
            _glyphPackageView = [[MZECAPackageView alloc] init];
            [_glyphPackageView setStateName:[self glyphState]];
            [_glyphPackageView setAutoResizingMask:0];
            [self addSubview:_glyphPackageView];
        }
        [_glyphPackageView setPackage:_glyphPackage];
    }
}

- (void)setGlyphState:(NSString *)glyphState {
    if (glyphState != _glyphState) {
        _glyphState = glyphState;
        [_glyphPackageView setStateName:_glyphState];
    }

        _glyphPackageView.alpha = _glyphVisible ? : 1.0 : 0.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize bounds = self.bounds.size;

    [self _layoutValueViews];

    CGFloat x = bounds.width*0.5;
    CGFloat y = bounds.height - x;
    CGPoint center = UIPointRoundToViewScale(CGPointMake(x,y), self);
    if (_glyphImageView) {
        _glyphImageView.center = center;
        _glyphImageView.alpha = _glyphVisible ? 1.0 : 0.0;
    }

    if (_glyphPackage) {
        _glyphPackageView.center = center;
        _glyphPackageView.alpha = _glyphVisible ? : 1.0 : 0.0;
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    _startingLocation = touchPoint;
    _startingHeight = CGRectGetHeight([self bounds]);
    _startingValue = _value;

    if (_throttleUpdates && !_updatesCommitTimer) {
        _previousValue = _value;
        _updatesCommitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
            if (_previousValue != _value) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
                _previousValue = _value;
            }
        }]
    }

    if ([self isStepped]) {
        [self _updateValueForTouchLocation:_startingLocation withAbsoluteReference:YES];
    }

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:self];
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
}

- (BOOL)isContentClippingRequired {
    return YES;
}

- (BOOL)isGroupRenderingRequired {
    return _glyphPackage ? YES : NO;
}

- (void)_layoutValueViews {

}

- (CGFloat)_sliderHeight {
    return CGRectGetHeight([self bounds]) * _value;
}

- (CGFloat)_fullStepHeight {
    CGFloat usableHeight = [self _sliderHeight] - (1 * (_numberOfSteps - 1));
    return UIRoundToViewScale(usableHeight/_numberOfSteps + -1, self);
}

- (CGFloat)_heightForStep:(NSUInteger)step {
    if (_numberOfSteps <= 1) {
        return [self _fullStepHeight]*_value;
    }
    return [self _fullStepHeight];
}

- (NSUInteger)_stepFromValue:(float)value {
    if (_numberOfSteps <= 1) {
        return 1;
    } else {
        return ceilf((float)_numberOfSteps * value);
    }
}

- (float)_valueFromStep:(NSUInteger)step {
    return;
}

@end