@interface UIPanGestureRecognizer (Private)
+ (void)_setPanGestureRecognizersEnabled:(BOOL)enabled;
@property (nonatomic, assign) BOOL fakePossible;
@property (nonatomic, assign) BOOL fakeBegan;
@end
