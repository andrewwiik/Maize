#import "MZEMaterialView.h"

@interface MZEContentModuleContentContainerView : UIView
{
    BOOL _expanded;
    BOOL _moduleProvidesOwnPlatter;
    BOOL _clipsContentInCompactMode;
    MZEMaterialView *_moduleMaterialView;
    CADisplayLink *_displayLink;
}

@property(nonatomic, readwrite) BOOL clipsContentInCompactMode; // @synthesize clipsContentInCompactMode=_clipsContentInCompactMode;
@property(nonatomic, readwrite) BOOL moduleProvidesOwnPlatter; // @synthesize moduleProvidesOwnPlatter=_moduleProvidesOwnPlatter;
- (void)layoutSubviews;
- (void)addSubview:(id)arg1;
@property(readonly, nonatomic) MZEMaterialView *moduleMaterialView; // @synthesize moduleMaterialView=_moduleMaterialView;
- (void)_configureModuleMaterialViewIfNecessary;
- (void)transitionToExpandedMode:(BOOL)arg1;
- (void)_transitionToExpandedMode:(BOOL)arg1 force:(BOOL)arg2;
- (id)initWithFrame:(CGRect)arg1;
- (id)init;


#pragma mark stupid corners

@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CGFloat wantedRadius;
@property (nonatomic, assign) CGFloat startRadius;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) CGFloat radiusDiff;
@property (nonatomic, assign) BOOL displayLinkActive;
@property (nonatomic, assign) CGFloat layerCornerRadius;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, retain, readwrite) CADisplayLink *displayLink;
- (void)stopDisplayLink;
- (void)handleDisplayLink:(CADisplayLink *)displayLink;


@end