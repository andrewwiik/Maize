
#import "MZECAPackageView.h"
#import "MZEMaterialView.h"
#import "_MZEBackdropView.h"
#import <QuartzCore/CAPackage+Private.h>
#import <QuartzCore/CABackdropLayer.h>

@interface MZEModuleSliderView : UIControl <CALayerDelegate>
{
    UIImageView *_glyphImageView;
    MZECAPackageView *_glyphPackageView;
    MZECAPackageView *_otherGlyphPackageView;
    NSArray *_stepBackgroundViews;
    NSArray *_separatorViews;
    CGFloat _startingHeight;
    struct CGPoint _startingLocation;
    float _startingValue;
    NSTimer *_updatesCommitTimer;
    float _previousValue;
    BOOL _glyphVisible;
    BOOL _throttleUpdates;
    BOOL _firstStepIsDisabled;
    float _value;
    UIImage *_glyphImage;
    CAPackage *_glyphPackage;
    NSString *_glyphState;
    NSUInteger _numberOfSteps;
    NSUInteger _step;
    UIView *_glyphMaskView;
    CADisplayLink *_displayLink;
    CGFloat _wantedRadius;
    CGFloat _startRadius;
    CGFloat _percent;
    CGFloat _startAlpha;
    CGFloat _wantedAlpha;
    CGFloat _radiusDiff;
    CFAbsoluteTime _startTime;
    BOOL _displayLinkActive;
    BOOL _changingValue;
    BOOL _separatorsHidden;
    _MZEBackdropView *_punchThroughContainer;
}

@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CGFloat wantedRadius;
@property (nonatomic, assign) CGFloat startRadius;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) CGFloat radiusDiff;
@property (nonatomic, assign) BOOL displayLinkActive;
@property(nonatomic) NSUInteger step;
@property(nonatomic) BOOL firstStepIsDisabled;
@property(nonatomic) NSUInteger numberOfSteps;
@property(nonatomic) float value;
@property(nonatomic) BOOL throttleUpdates;
@property(nonatomic, getter=isGlyphVisible) BOOL glyphVisible;
@property (nonatomic) BOOL separatorsHidden;
@property(retain, nonatomic, readwrite) NSString *glyphState;
@property(retain, nonatomic, readwrite) CAPackage *glyphPackage;
@property(retain, nonatomic, readwrite) UIImage *glyphImage;
@property(retain, nonatomic, readwrite) UIView *glyphMaskView;
@property(nonatomic, readonly) CALayer *punchOutRootLayer;
@property (nonatomic, assign) CGFloat layerCornerRadius;
@property (nonatomic, retain, readwrite) CADisplayLink *displayLink;
 
// + (Class)layerClass;

- (void)_updateStepFromValue:(float)arg1;
- (void)_updateValueForTouchLocation:(CGPoint)arg1 withAbsoluteReference:(BOOL)arg2;
- (float)_valueFromStep:(float)arg1;
- (NSUInteger)_stepFromValue:(float)arg1;
- (CGFloat)_sliderHeight;
- (CGFloat)_fullStepHeight;
- (CGFloat)_heightForStep:(NSUInteger)arg1;
- (MZEMaterialView *)_createSeparatorView;
- (MZEMaterialView *)_createBackgroundViewForStep:(NSUInteger)arg1;
- (void)_createSeparatorViewsForNumberOfSteps:(NSUInteger)arg1;
- (void)_createStepViewsForNumberOfSteps:(NSUInteger)arg1;
- (void)_layoutValueViews;
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)layoutSubviews;
- (void)throttleTimerFired:(NSTimer *)timer;
// - (void)layoutEverything;
- (BOOL)isGroupRenderingRequired;
@property(readonly, nonatomic, getter=isStepped) BOOL stepped;
- (id)initWithFrame:(struct CGRect)arg1;


#pragma mark Make Corner Radius Animatable
// - (BOOL)shouldForwardSelector:(SEL)aSelector;
// - (id)forwardingTargetForSelector:(SEL)aSelector;
// - (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key;
- (void)stopDisplayLink;
- (void)handleDisplayLink:(CADisplayLink *)displayLink;

#pragma mark for expanding animation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
@end