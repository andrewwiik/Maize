@interface MZEMenuModuleItemView : UIControl
{
    UILabel *_titleLabel;
    UIImage *_glyphImage;
    UIView *_separatorView;
    UIImageView *_glyphImageView;
    UIView *_highlightedBackgroundView;
    BOOL _separatorVisible;
    CDUnknownBlockType _handler;
}

@property(readonly, copy, nonatomic) CDUnknownBlockType handler;
@property(nonatomic) BOOL separatorVisible;

- (id)initWithTitle:(NSString *)title glyphImage:(UIImage *)glyphImage handler:(CDUnknownBlockType)arg3;
- (CGSize)sizeThatFits:(CGSize)arg1;
- (CGSize)intrinsicContentSize;
- (void)layoutSubviews;
- (void)setHighlighted:(BOOL)arg1;
- (void)setSelected:(BOOL)arg1;
- (void)setEnabled:(BOOL)arg1;
- (void)_setContinuousCornerRadius:(CGFloat)arg1;
- (void)_touchDown:(UIControl *)control;
- (void)_touchUpInside:(UIControl *)control;
- (void)_touchUpOutside:(UIControl *)control;
- (void)_dragEnter:(UIControl *)control;
- (void)_dragExit:(UIControl *)control;
- (void)_updateForStateChange;
@end