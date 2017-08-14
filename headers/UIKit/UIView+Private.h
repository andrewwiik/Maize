#import <ControlCenterUI/CCUIControlCenterPagePlatterView.h>

@interface UIView (Private)
@property (assign,setter=_setContinuousCornerRadius:,nonatomic) CGFloat _continuousCornerRadius; 
@property (nonatomic, retain) NSObject *delegate;
- (BOOL)shouldForwardSelector:(SEL)aSelector;
- (void)_setContinuousCornerRadius:(CGFloat)radius;
- (void)nc_applyVibrantStyling:(id)styling;
- (UIImage *)_imageFromRect:(CGRect)rect;
- (void)nc_removeAllVibrantStyling;
- (CCUIControlCenterPagePlatterView *)ccuiPunchOutMaskedContainer;
- (BOOL)_shouldAnimatePropertyWithKey:(id)key;
- (UIScreen *)_screen;
- (void)setSize:(CGSize)size;


+ (void)_animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options factory:(id)factory animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
@end