@interface SBFButton : UIButton

- (BOOL)_drawingAsSelected;
- (void)_touchUpInside;
- (void)_updateForStateChange;
- (void)_updateSelected:(BOOL)selected highlighted:(BOOL)highlighted;
- (id)initWithFrame:(CGRect)frame;
- (void)setHighlighted:(BOOL)highlighted;
- (void)setSelected:(BOOL)selected;

@end