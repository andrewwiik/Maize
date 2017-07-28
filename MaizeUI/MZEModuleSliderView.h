
#import "MZECAPackageView.h"

@interface MZEModuleSliderView : UIControl
{
    UIImageView *_glyphImageView;
    MZECAPackageView *_glyphPackageView;
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
}

@property(nonatomic) NSUInteger step;
@property(nonatomic) BOOL firstStepIsDisabled;
@property(nonatomic) NSUInteger numberOfSteps;
@property(nonatomic) float value;
@property(nonatomic) BOOL throttleUpdates;
@property(nonatomic, getter=isGlyphVisible) BOOL glyphVisible;
@property(retain, nonatomic, readwrite) NSString *glyphState;
@property(retain, nonatomic, readwrite) CAPackage *glyphPackage;
@property(retain, nonatomic, readwrite) UIImage *glyphImage;
- (void)_updateStepFromValue:(float)arg1;
- (void)_updateValueForTouchLocation:(CGPoint)arg1 withAbsoluteReference:(BOOL)arg2;
- (float)_valueFromStep:(NSUInteger)arg1;
- (NSUInteger)_stepFromValue:(float)arg1;
- (CGFloat)_sliderHeight;
- (CGFloat)_fullStepHeight;
- (CGFloat)_heightForStep:(NSUInteger)arg1;
- (id)_createSeparatorView;
- (id)_createBackgroundViewForStep:(NSUInteger)arg1;
- (void)_createSeparatorViewsForNumberOfSteps:(NSUInteger)arg1;
- (void)_createStepViewsForNumberOfSteps:(NSUInteger)arg1;
- (void)_layoutValueViews;
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)layoutSubviews;
@property(readonly, nonatomic, getter=isStepped) BOOL stepped;
- (id)initWithFrame:(struct CGRect)arg1;
@end