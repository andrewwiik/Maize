#import "MZELayoutView.h"

@implementation MZELayoutView
	@synthesize layoutSource=_layoutSource;

- (id)initWithLayoutSource:(id<MZELayoutViewLayoutSource>)layoutSource frame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_layoutSource = layoutSource;
		[self setAutoresizesSubviews:NO];
		_shouldLayout = YES;
	}
	return self;
}

- (void)setNeedsLayout {
	[super setNeedsLayout];
	_shouldLayout = YES;
}

- (void)didAddSubview:(UIView *)subview {
	[super didAddSubview:subview];
	[self setNeedsLayout];
}

- (void)willRemoveSubview:(UIView *)subview {
	[super willRemoveSubview:subview];
	[self setNeedsLayout];
}

- (NSArray<UIView *> *)subviewsToLayout {
	return (NSArray<UIView *> *)[self subviews];
}

- (CGSize)sizeThatFits:(CGSize)size {
	if (_layoutSource) {
		CGSize mainLayoutSize = [_layoutSource layoutSizeForLayoutView:self];
		UIEdgeInsets insets = [self edgeInsets];
		mainLayoutSize.height += insets.top + insets.bottom;
		mainLayoutSize.width += insets.left + insets.right;
		return mainLayoutSize;
	} else return CGSizeZero;
}

- (CGSize)intrinsicContentSize {
	return [self sizeThatFits:CGSizeZero];
}

- (void)layoutSubviews {
	if (_shouldLayout) {

		UIEdgeInsets insets = _edgeInsets;
		CGFloat topInset = insets.top;
		CGFloat rightInset = insets.right;

		for (UIView *subview in [self subviewsToLayout]) {
			if (![_layoutSource layoutView:self shouldIgnoreSubview:subview]) {
				CGRect subviewFrame = [_layoutSource layoutView:self layoutRectForSubview:subview];
				subviewFrame.origin.x += rightInset;
				subviewFrame.origin.y += topInset;

				subview.frame = subviewFrame;
			}
		}

		[self setContentSize:[self intrinsicContentSize]];

		_shouldLayout = NO;
	}
}

- (void)setEdgeInsets:(UIEdgeInsets)insets {
	if (insets.top != _edgeInsets.top || insets.bottom != _edgeInsets.bottom || insets.left != _edgeInsets.left || insets.right != _edgeInsets.right) {
		_edgeInsets = insets;
		[self setNeedsLayout];
	}
}

- (UIEdgeInsets)edgeInsets {
	return _edgeInsets;
}
@end