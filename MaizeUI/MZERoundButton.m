#import "MZERoundButton.h"
#import <UIKit/UIControl+Private.h>
#import "UIView+MZE.h"
#import "MZELayoutOptions.h"

@implementation MZERoundButton

- (id)initWithHighlightColor:(UIColor *)highlightColor {
	self = [super initWithFrame:CGRectZero];
	if (self) {

		_normalStateBackgroundView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
		[_normalStateBackgroundView setFrame:self.bounds];
		[_normalStateBackgroundView setAutoresizingMask:18];
		[_normalStateBackgroundView setUserInteractionEnabled:NO];
		[self addSubview:_normalStateBackgroundView];

		_highlightStateBackgroundView = [[UIView alloc] initWithFrame:_normalStateBackgroundView.frame];
		[_highlightStateBackgroundView setAutoresizingMask:18];
		[_highlightStateBackgroundView setBackgroundColor:_highlightColor];
		[_highlightStateBackgroundView setUserInteractionEnabled:NO];
		[_highlightStateBackgroundView setAlpha:0.0];
		[self addSubview:_highlightStateBackgroundView];

		[self addTarget:self action:@selector(_touchDown:) forControlEvents:0x1];
		[self addTarget:self action:@selector(_touchUpOutside:) forControlEvents:0x80];
		[self addTarget:self action:@selector(_dragEnter:) forControlEvents:0x10];
		[self addTarget:self action:@selector(_dragExit:) forControlEvents:0x20];
		[self addTarget:self action:@selector(_primaryActionPerformed:) forEvents:0x2000];
		[self addObserver:self forKeyPath:@"enabled" options:0x0 context:0x0];
		[self addObserver:self forKeyPath:@"highlighted" options:0x0 context:0x0];
		[self addObserver:self forKeyPath:@"selected" options:0x0 context:0x0];
	}

	return self;
}

- (id)initWithGlyphPackage:(CAPackage *)glyphPackage highlightColor:(UIColor *)highlightColor {
	self = [self initWithHighlightColor:highlightColor];
	if (self) {
		_glyphPackage = glyphPackage;
		_glyphPackageView = [[MZECAPackageView alloc] init];
		[_glyphPackageView setAutoresizingMask:18];
		[_glyphPackageView setPackage:_glyphPackage];
		[self addSubview:_glyphPackageView];
		[self addObserver:self forKeyPath:@"glyphState" options:0x0 context:0x0];
	}
	return self;
}
- (id)initWithGlyphImage:(UIImage *)glyphImage highlightColor:(UIColor *)highlightColor {
	self = [self initWithHighlightColor:highlightColor];
	if (self) {
		_glyphImage = [glyphImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		_glyphImageView = [[UIImageView alloc] initWithImage:_glyphImage];
		[_glyphImageView setFrame:CGRectZero];
		[_glyphImageView setAutoresizingMask:18];
		[_glyphImageView setContentMode:UIViewContentModeCenter];
		[self addSubview:_glyphImageView];

		_highlightedGlyphView = [[UIImageView alloc] initWithImage:_glyphImage];
		[_highlightedGlyphView setFrame:CGRectZero];
		[_highlightedGlyphView setAutoresizingMask:18];
		[_highlightedGlyphView setContentMode:UIViewContentModeCenter];
		[_highlightedGlyphView setAlpha:0];
		[self addSubview:_highlightedGlyphView];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self _setCornerRadius:[self _cornerRadius]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(id)change context:(void *)context {
	if (object == self) {
		if (![keyPath isEqualToString:@"selected"] && ![keyPath isEqualToString:@"enabled"] && ![keyPath isEqualToString:@"highlighted"]) {
			if ([keyPath isEqualToString:@"glyphState"]) {
				[self _updateForStateChange];
			}
		} else {
			[self _updateForStateChange];
		}
	}

}

- (void)_updateForStateChange {
	[UIView animateWithDuration:0.25 animations:^{
		
		CGFloat alpha = 0;
	 	if (![self isEnabled]) {
	 		alpha = 0.2;
	 	} else {
	 		alpha = 1;
	 	}

	 	if (![self isHighlighted] && ![self isSelected]) {
	 		_highlightStateBackgroundView.alpha = 0;
	 		_highlightedGlyphView.alpha = 0;
	 		_glyphImageView.alpha = alpha;
	 	} else {
	 		_highlightStateBackgroundView.alpha = 1;
	 		_highlightedGlyphView.alpha = alpha;
	 		_glyphImageView.alpha = 0;
	 	}

	 	if (_glyphPackageView) {
	 		[_glyphPackageView setStateName:_glyphState];
	 	}
	}];
}

- (void)_primaryActionPerformed:(id)arg1 {
	[self setHighlighted:NO];
}

- (void)_dragExit:(id)arg1 {
	[self setHighlighted:NO];
}

- (void)_dragEnter:(id)arg1 {
	[self setHighlighted:YES];
}

- (void)_touchUpOutside:(id)arg1 {
	[self setHighlighted:NO];
}

- (void)_touchDown:(id)arg1 {
	[self setHighlighted:YES];
}

- (void)_setCornerRadius:(CGFloat)cornerRadius {
	_highlightStateBackgroundView._cornerRadius = cornerRadius;
	_normalStateBackgroundView._cornerRadius = cornerRadius;
}

- (CGFloat)_cornerRadius {
	return self.bounds.size.width/2;
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	_glyphImage = [glyphImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	_glyphImageView.image = _glyphImage;
	_highlightedGlyphView.image = _glyphImage;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer {
	BOOL returnValue = NO;
	if (recognizer.view != self) {
		returnValue = [recognizer.view isDescendantOfView:self];
	} else {
		returnValue = YES;
	}
	return returnValue;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return CGSizeMake([MZELayoutOptions roundButtonSize],[MZELayoutOptions roundButtonSize]);
}

- (CGSize)intrinsicContentSize {
	return [self sizeThatFits:CGSizeZero];
}

@end