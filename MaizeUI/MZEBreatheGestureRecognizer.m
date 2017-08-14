#import "MZEBreatheGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MZEContentModuleContainerViewController.h"

@implementation MZEBreatheGestureRecognizer
    @synthesize percentComplete = _percentComplete;

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        // Use default value for allowableMovement before touches begin
        _allowableMovementAfterBegan = self.allowableMovement; 
    }
    return self;
}

- (void)reset
{
    [super reset];      
    initialPoint = CGPointZero;

    if (_timerRunning) {
        _timerRunning = NO;
        _hasFailed = YES;
       [self.timer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];   
    initialPoint = [self locationInView:self.view];
    _hasFailed = NO;

    if (self.tracksTime) {
        self.percentComplete = 0;
        if (!self.timer) {
             self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        }
        self.startTime = CACurrentMediaTime();
        _timerRunning = YES;
        [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if (!CGPointEqualToPoint(initialPoint, CGPointZero)) {
        CGPoint currentPoint = [self locationInView:self.view];

        CGFloat distance = hypot(initialPoint.x - currentPoint.x, initialPoint.y - currentPoint.y);
        if (distance > self.allowableMovementAfterBegan) {
            self.state = UIGestureRecognizerStateFailed;
            if (_timerRunning) {
                _timerRunning = NO;
                _hasFailed = YES;
                [self.timer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (_timerRunning) {
        _timerRunning = NO;
        _hasFailed = YES;
       [self.timer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)setPercentComplete:(CGFloat)percent {
    _percentComplete =  fminf(fmaxf(percent, 0.0), 1.0);
}

- (void)handleDisplayLink:(CADisplayLink *)timer {
    if (!_hasFailed) {
        CFAbsoluteTime elapsed = CACurrentMediaTime() - self.startTime;
        CGFloat percent = elapsed / self.wantedPressDuration - floor(elapsed / self.wantedPressDuration);
        percent = roundf(100 * percent) / 100;
        if (percent != self.percentComplete) {
            self.percentComplete = percent;
            self.state = UIGestureRecognizerStateChanged;

            if (self.percentComplete >= 1) {
                _timerRunning = NO;
                _hasFailed = YES;
                [timer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            }
        }
    }
}
@end