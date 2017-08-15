#import "MZEBreatheGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MZEContentModuleContainerViewController.h"

@implementation MZEBreatheGestureRecognizer
- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        // Use default value for allowableMovement before touches begin
        _allowableMovementAfterBegan = self.allowableMovement;
    }
    return self;
}

- (void)reset {
    [super reset];      
    initialPoint = CGPointZero;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];   
    initialPoint = [self locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if (!CGPointEqualToPoint(initialPoint, CGPointZero)) {
        CGPoint currentPoint = [self locationInView:self.view];

        CGFloat distance = hypot(initialPoint.x - currentPoint.x, initialPoint.y - currentPoint.y);
        if (distance > self.allowableMovementAfterBegan) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}
@end