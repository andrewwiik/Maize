#define NSCLeft        NSLayoutAttributeLeft
#define NSCRight       NSLayoutAttributeRight
#define NSCTop         NSLayoutAttributeTop
#define NSCBottom      NSLayoutAttributeBottom
#define NSCLeading     NSLayoutAttributeLeading
#define NSCTrailing    NSLayoutAttributeTrailing
#define NSCWidth       NSLayoutAttributeWidth
#define NSCHeight      NSLayoutAttributeHeight
#define NSCCenterX     NSLayoutAttributeCenterX
#define NSCCenterY     NSLayoutAttributeCenterY
#define NSCBaseline    NSLayoutAttributeBaseline

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define NSCLessThanOrEqual     NSLayoutRelationLessThanOrEqual
#define NSCEqual               NSLayoutRelationEqual
#define NSCGreaterThanOrEqual  NSLayoutRelationGreaterThanOrEqual

#define Constraint(item1, attr1, rel, item2, attr2, con) [NSLayoutConstraint constraintWithItem:(item1) attribute:(attr1) relatedBy:(rel) toItem:(item2) attribute:(attr2) multiplier:1 constant:(con)]
#define VisualConstraints(format, ...) [NSLayoutConstraint constraintsWithVisualFormat:(format) options:0 metrics:nil views:_NSDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)]
#define VisualConstraintWithMetrics(format, theMetrics, ...) [NSLayoutConstraint constraintsWithVisualFormat:(format) options:0 metrics:(theMetrics) views:_NSDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)]
#define ConstantConstraint(item, attr, rel, con) Constraint((item), (attr), (rel), nil, NSLayoutAttributeNotAnAttribute, (con))

#define horizontallyFillSuperview ^(UIView *view, NSUInteger idx, BOOL *stop) {[view.superview addConstraints:VisualConstraints(@"|[view]|", view)];}

#if __cplusplus
    extern "C" {
#endif
    CGPoint UIRectGetCenter(CGRect rect);
	CGFloat UICeilToViewScale(CGFloat value, UIView *view);
	CGFloat UIRoundToViewScale(CGFloat value, UIView *view);
	CGPoint UIPointRoundToViewScale(CGPoint point, UIView *view);
#if __cplusplus
}
#endif