
#import "MZECAPackageView.h"
#import "MZEMaterialView.h"
#import <QuartzCore/CAPackage+Private.h>

@interface MZEModuleSliderView : UIControl
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
    CAPackage *_otherGlyphPackage;
    NSString *_glyphState;
    NSUInteger _numberOfSteps;
    NSUInteger _step;
    UIView *_glyphMaskView;
}

@property(nonatomic) NSUInteger step;
@property(nonatomic) BOOL firstStepIsDisabled;
@property(nonatomic) NSUInteger numberOfSteps;
@property(nonatomic) float value;
@property(nonatomic) BOOL throttleUpdates;
@property(nonatomic, getter=isGlyphVisible) BOOL glyphVisible;
@property(retain, nonatomic, readwrite) NSString *glyphState;
@property(retain, nonatomic, readwrite) CAPackage *glyphPackage;
@property (retain, nonatomic, readwrite) CAPackage *otherGlyphPackage;
@property(retain, nonatomic, readwrite) UIImage *glyphImage;
@property(retain, nonatomic, readwrite) UIView *glyphMaskView;
@property(nonatomic, readonly) CALayer *punchOutRootLayer; 
- (void)_updateStepFromValue:(float)arg1;
- (void)_updateValueForTouchLocation:(CGPoint)arg1 withAbsoluteReference:(BOOL)arg2;
- (float)_valueFromStep:(NSUInteger)arg1;
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
- (void)layoutEverything;
- (BOOL)isGroupRenderingRequired;
@property(readonly, nonatomic, getter=isStepped) BOOL stepped;
- (id)initWithFrame:(struct CGRect)arg1;


#pragma mark Make Corner Radius Animatable
- (BOOL)shouldForwardSelector:(SEL)aSelector;
- (id)forwardingTargetForSelector:(SEL)aSelector;
- (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key;

#pragma mark for expanding animation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
@end