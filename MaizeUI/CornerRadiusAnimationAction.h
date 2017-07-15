@interface CornerRadiusAnimationAction : NSObject <CAAction>

@property CABasicAnimation *pendingAnimation;
@property CGFloat priorCornerRadius;

@end