#import <QuartzCore/CAFilter+Private.h>

#import <UIKit/_UIVisualEffectVibrantLayerConfig.h>
#import <UIKit/_UIVisualEffectTintLayerConfig.h>

@interface MZEVibrantStyling : NSObject {
    CGFloat  _alpha;
    NSString * _blendMode;
    UIColor * _burnColor;
    UIColor * _color;
    CAFilter * _composedFilter;
    UIColor * _darkenColor;
    BOOL  _inputReversed;
    NSInteger  _style;
}

@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly, copy) NSString *blendMode;
@property (getter=_burnColor, nonatomic, readonly, copy) UIColor *burnColor;
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly, copy) CAFilter *composedFilter;
@property (getter=_darkenColor, nonatomic, readonly, copy) UIColor *darkenColor;
@property (getter=_inputReversed, nonatomic, readonly) BOOL inputReversed;
@property (nonatomic, readonly) NSInteger style;

- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (_UIVisualEffectLayerConfig *)_layerConfig;
- (CGFloat)alpha;
- (NSString *)blendMode;
- (UIColor *)color;
- (CAFilter *)composedFilter;
- (NSInteger)style;

@end