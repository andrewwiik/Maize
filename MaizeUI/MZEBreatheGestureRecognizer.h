@interface MZEBreatheGestureRecognizer : UILongPressGestureRecognizer {
    CGPoint initialPoint;
}
@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CGFloat allowableMovementAfterBegan;
@end