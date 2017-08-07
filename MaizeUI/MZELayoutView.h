#import "MZELayoutViewLayoutSource-Protcol.h"

@interface MZELayoutView : UIScrollView {
    BOOL _shouldLayout;
    UIEdgeInsets _edgeInsets;
    id <MZELayoutViewLayoutSource> _layoutSource;
}
@property(nonatomic) __weak id <MZELayoutViewLayoutSource> layoutSource;
- (id)initWithLayoutSource:(id<MZELayoutViewLayoutSource>)layoutSource frame:(CGRect)frame;
- (void)setNeedsLayout;
- (void)didAddSubview:(UIView *)subview;
- (void)willRemoveSubview:(UIView *)subview;
- (NSArray<UIView *> *)subviewsToLayout;
- (CGSize)sizeThatFits:(CGSize)size;
- (CGSize)intrinsicContentSize;
- (void)layoutSubviews;
- (UIEdgeInsets)edgeInsets;
- (void)setEdgeInsets:(UIEdgeInsets)insets;
@end