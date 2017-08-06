#import "MZEPocketMaterialView.h"

#import "../headers/UIKit/_UIBackdropViewSettings.h"

@interface _UIBackdropView : UIView
@property (nonatomic,copy) NSString *groupName;
- (UIView *)grayscaleTintView;
- (id)initWithPrivateStyle:(int)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (id)initWithStyle:(int)arg1;
+ (instancetype)settingsForPrivateStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2;
- (void)transitionToSettings:(id)arg1;
- (void)computeAndApplySettings:(id)settings;
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3 ;
@end

@implementation MZEPocketMaterialView
-(id)initWithFrame:(CGRect)arg1 {
    self = [super initWithFrame:arg1];

    // TO DO: Fix the use of the alpha fix to match iOS 11, it's about 90% correct but isn't 100%.

    _UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];
    settings.blurRadius = 20;
    settings.saturationDeltaFactor = 1.9f;

    _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
    blurView.alpha = 0.35;
    [self addSubview:blurView];

    return self;
}
@end
