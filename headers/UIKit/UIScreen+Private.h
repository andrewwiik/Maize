@interface UIScreen (MZE)
@property (nonatomic, readonly) CGRect _referenceBounds;
- (CGRect)_mainSceneBoundsForInterfaceOrientation:(NSInteger)interfaceOrientation;
@end