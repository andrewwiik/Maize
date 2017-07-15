#import "CornerRadiusAnimationAction.h"

@implementation CornerRadiusAnimationAction
- (void)runActionForKey:(NSString *)event
                 object:(id)anObject
              arguments:(nullable NSDictionary *)dict {
    CALayer *layer = anObject;
    CABasicAnimation *pendingAnimation = self.pendingAnimation;
    if (!layer || !pendingAnimation) {
        return;
    }
    
    if (pendingAnimation.isAdditive) {
        pendingAnimation.fromValue = @(self.priorCornerRadius - layer.cornerRadius);
        pendingAnimation.toValue = @0;
    } else {
        pendingAnimation.fromValue = @(self.priorCornerRadius);
        pendingAnimation.toValue = @(layer.cornerRadius);
    }
    [layer addAnimation:pendingAnimation forKey:@"cornerRadius"];
}
@end