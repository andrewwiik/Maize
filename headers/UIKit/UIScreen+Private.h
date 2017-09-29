@interface UIScreen (MZE)
@property (nonatomic, readonly) CGRect _referenceBounds;
- (CGRect)_mainSceneBoundsForInterfaceOrientation:(NSInteger)interfaceOrientation;
- (UIView *)_snapshotExcludingWindows:(NSArray *)excludedWindows withRect:(CGRect)frame;
- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)updates;
- (UIView *)snapshotView;
@end