#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIView+Private.h>

#import "MZEHeaderPocketView.h"
#import "macros.h"


@implementation MZEHeaderPocketView
    @synthesize backgroundAlpha=_backgroundAlpha;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        NSMutableDictionary *materialStyleDictionary = [NSMutableDictionary new];
        materialStyleDictionary[@"saturation"] = [NSNumber numberWithFloat:1.9f];
        materialStyleDictionary[@"blurRadius"] = [NSNumber numberWithFloat:20.0f];

        _headerBackgroundView = [[MZEMaterialView alloc] initWithStyleDict:[materialStyleDictionary copy]];
        _headerBackgroundView.alpha = 0;
        [self addSubview:_headerBackgroundView];

        _headerLineView = [[UIView alloc] init];
        _headerLineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
        _headerLineView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];

        if (!(isPad)) {
            _headerChevronView = [[NSClassFromString(@"SBUIChevronView") alloc] initWithColor:[UIColor colorWithWhite:0 alpha:1]];
            [_headerChevronView configureForLightStyle];
            [_headerChevronView setState:0];
            [_headerChevronView sizeToFit];
            [self addSubview:_headerChevronView];
        }
    }

    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 64.0);
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat headerLineViewHeight = 1.0f/(CGFloat)[self _screen].scale;
    CGRect bounds = [self bounds];
    CGFloat headerBackgroundHeight = CGRectGetHeight(bounds) - headerLineViewHeight;
    CGFloat headerBackgroundWidth = CGRectGetWidth(bounds);
    _headerBackgroundView.frame = CGRectMake(0,0,headerBackgroundWidth, headerBackgroundHeight);
    _headerLineView.frame = CGRectMake(0,headerBackgroundHeight,headerBackgroundWidth,headerLineViewHeight);

    if (_headerChevronView) {
        _headerChevronView.center = UIRectGetCenter(bounds);
    }
}

- (CGFloat)backgroundAlpha {
    return _backgroundAlpha;
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    if (backgroundAlpha != _backgroundAlpha) {
        _backgroundAlpha = backgroundAlpha;
        _headerBackgroundView.alpha = backgroundAlpha;
        _headerLineView.alpha = backgroundAlpha;
    }
}

- (CGFloat)chevronAlpha {
    if (_headerChevronView) {
        return _headerChevronView.alpha;
    } else return 0.0f;
}

- (void)setChevronAlpha:(CGFloat)chevronAlpha {
    if (_headerChevronView) {
        _headerChevronView.alpha = chevronAlpha;
    }
}

- (BOOL)isChevronPointingDown {
    if (_headerChevronView) {
        return [_headerChevronView state] == 1;
    }
    return NO;
}

- (void)setChevronPointingDown:(BOOL)pointingDown {
    if (_headerChevronView) {
        [_headerChevronView setState:pointingDown ? 1 : 0 animated:YES];
    }
}
@end
