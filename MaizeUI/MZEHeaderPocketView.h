#import "MZEMaterialView.h"
#import <SpringBoardUI/SBUIChevronView.h>

@interface MZEHeaderPocketView : UIView {
    MZEMaterialView *_headerBackgroundView;
    UIView *_headerLineView;
    SBUIChevronView *_headerChevronView;
    CGFloat _backgroundAlpha;
}

@property(nonatomic) CGFloat backgroundAlpha;
@property(nonatomic, getter=isChevronPointingDown) BOOL chevronPointingDown;
@property(nonatomic) CGFloat chevronAlpha;
- (void)layoutSubviews;
- (CGSize)intrinsicContentSize;
- (CGSize)sizeThatFits:(CGSize)size;
- (id)initWithFrame:(CGRect)frame;

@end
