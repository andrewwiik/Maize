@interface HUSpringAnimationSettings : NSObject
@property (assign,nonatomic) CGFloat mass; 
@property (assign,nonatomic) CGFloat stiffness; 
@property (assign,nonatomic) CGFloat damping; 
@property (assign,nonatomic) CGFloat initialVelocity; 
@property (assign,nonatomic) CGFloat completionEpsilon;  
@end