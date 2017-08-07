@protocol MZELayoutViewLayoutSource <NSObject>
- (BOOL)layoutView:(MZELayoutView *)layoutView shouldIgnoreSubview:(UIView *)subview;
- (CGRect)layoutView:(MZELayoutView *)arg1 layoutRectForSubview:(UIView *)subview;
- (CGSize)layoutSizeForLayoutView:(MZELayoutView *)layoutView;
@end