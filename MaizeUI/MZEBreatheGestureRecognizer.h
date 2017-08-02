@interface MZEBreatheGestureRecognizer : UILongPressGestureRecognizer {
    CGPoint initialPoint;
}
@property (nonatomic, assign) CGFloat allowableMovementAfterBegan;
@end