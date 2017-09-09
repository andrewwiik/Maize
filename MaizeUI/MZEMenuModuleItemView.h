
typedef BOOL (^MZEMenuItemBlock)(void);


#import "MZEMaterialView.h"


@interface MZEMenuModuleItemView : UIControl
{
    UILabel *_titleLabel;
    UIImage *_glyphImage;
    MZEMaterialView *_separatorView;
    UIImageView *_glyphImageView;
    UIView *_highlightedBackgroundView;
    BOOL _separatorVisible;
    MZEMenuItemBlock _handler;
}

@property(readonly, copy, nonatomic) MZEMenuItemBlock handler;
@property(nonatomic) BOOL separatorVisible;

- (id)initWithTitle:(NSString *)title glyphImage:(UIImage *)glyphImage handler:(MZEMenuItemBlock)handler;
- (CGSize)sizeThatFits:(CGSize)arg1;
- (CGSize)intrinsicContentSize;
- (void)layoutSubviews;
- (void)setHighlighted:(BOOL)arg1;
- (void)setSelected:(BOOL)arg1;
- (void)setEnabled:(BOOL)arg1;
- (void)_touchDown:(UIControl *)control;
- (void)_touchUpInside:(UIControl *)control;
- (void)_touchUpOutside:(UIControl *)control;
- (void)_dragEnter:(UIControl *)control;
- (void)_dragExit:(UIControl *)control;
- (void)_updateForStateChange;
@end