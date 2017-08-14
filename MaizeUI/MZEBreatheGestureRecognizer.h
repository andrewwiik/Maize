@interface MZEBreatheGestureRecognizer : UILongPressGestureRecognizer {
    CGPoint initialPoint;
    CADisplayLink *_timer;
    BOOL _timerRunning;
    CGFloat _percentComplete;
    BOOL _hasFailed;
}
@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CGFloat allowableMovementAfterBegan;
@property (nonatomic, assign) CGFloat percentComplete;
@property (nonatomic, assign) NSTimeInterval wantedPressDuration;
@property (nonatomic, assign) BOOL tracksTime;
@property (nonatomic, retain, readwrite) CADisplayLink *timer;

- (void)handleDisplayLink:(CADisplayLink *)timer;
@end