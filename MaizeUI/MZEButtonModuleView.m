#import "MZEButtonModuleView.h"
#import "MZELayoutOptions.h"
#import "MZEMaterialView.h"
#import <UIKit/UIView+Private.h>

@implementation MZEButtonModuleView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_highlightedBackgroundView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleLight];
		[_highlightedBackgroundView setFrame:self.bounds];
		[_highlightedBackgroundView setAutoresizingMask:18];
		_highlightedBackgroundView._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
		[_highlightedBackgroundView setAlpha:0x12];
		[self addSubview:_highlightedBackgroundView];
		[self addTarget:self action:@selector(_touchDown:) forControlEvents:0x1];
		[self addTarget:self action:@selector(_touchUpInside:) forControlEvents:0x40];
		[self addTarget:self action:@selector(_touchUpOutside:) forControlEvents:0x80];
		[self addTarget:self action:@selector(_dragEnter:) forControlEvents:0x10];
		[self addTarget:self action:@selector(_dragExit:) forControlEvents:0x20];
	}
	return self;
}

- (void)setBounds:(CGRect)bounds {
	if ([self isTracking]) {
		[self cancelTrackingWithEvent:nil];
	}
	[super setBounds:bounds];
}

- (void)setFrame:(CGRect)frame {
	if ([self isTracking]) {
		[self cancelTrackingWithEvent:nil];
	}
	[super setFrame:frame];
}

- (void)setGlyphState:(NSString *)glyphState {
	if (glyphState != _glyphState) {
		_glyphState = glyphState;
		[self _setGlyphState:_glyphState];
	}
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	if (glyphPackage != _glyphPackage) {
		_glyphPackage = glyphPackage;
		[self _setGlyphPackage:_glyphPackage];
	}
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	if (glyphImage != _glyphImage) {
		_glyphImage = glyphImage;
		[self _setGlyphImage:_glyphImage];
	}
}

- (void)_setGlyphState:(NSString *)glyphState {
	[_glyphPackageView setStateName:glyphState];
}

- (void)_setGlyphPackage:(CAPackage *)glyphPackage {
	if (!_glyphPackageView) {
		_glyphPackageView = [[MZECAPackageView alloc] init];
		[_glyphPackageView setStateName:[self glyphState]];
		[_glyphPackageView setAutoresizingMask:18];
		[self addSubview:_glyphPackageView];
	}

	[_glyphPackageView setPackage:_glyphPackage];
}

- (void)_setGlyphImage:(UIImage *)glyphImage {
	if (!_glyphImageView) {
		_glyphImageView = [[UIImageView alloc] init];
		[_glyphImageView setContentMode:UIViewContentModeCenter];
		if (_glyphColor) {
				[_glyphImageView setTintColor:_glyphColor];
		}
		else {
			[_glyphImageView setTintColor:[UIColor whiteColor]];
		}
		[_glyphImageView setAutoresizingMask:18];
		[_glyphImageView setFrame:self.bounds];
		[self addSubview:_glyphImageView];
	}
	_glyphImageView.image = [glyphImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)_updateForStateChange {
	[UIView animateWithDuration:0.25 animations:^{
		UIImage *glyphImage;
		if ([self isSelected]) {
				glyphImage = _selectedGlyphImage;
				if (!_selectedGlyphImage) {
						glyphImage = _glyphImage;
				}
		}
		else {
				glyphImage = _glyphImage;
		}

		UIColor *glyphColor;
		if ([self isSelected]) {
				glyphColor = _selectedGlyphColor;
				if (!_selectedGlyphColor) {
						glyphColor = _glyphColor;
				}
		}
		else {
				glyphColor = _glyphColor;
		}

		[self _setGlyphImage:glyphImage];

		CGFloat alpha;
		if ([self isHighlighted] && ![self isSelected]) {
				alpha = 0.25;
		} else {
				alpha = [self isSelected] ? 1.0 : 0;
		}
		_highlightedBackgroundView.alpha = alpha;

		if (glyphColor) {
				[_glyphImageView setTintColor:glyphColor];
		}
		else {
			[_glyphImageView setTintColor:[UIColor whiteColor]];
		}
	}];
}

- (void)_dragExit:(id)arg1 {
	[self setHighlighted:NO];
}

- (void)_dragEnter:(id)arg1 {
	if (_allowsHighlighting)
		[self setHighlighted:YES];
}

- (void)_touchUpOutside:(id)arg1 {
	[self setHighlighted:NO];
}

- (void)_touchUpInside:(id)arg1 {
	[self setHighlighted:[self isSelected] ? NO : YES];
	// if ([self isSelected] == NO && [self isHighlighted] && _highlightedBackgroundView.alpha == 1.0) {
	// 	[UIView performWithoutAnimation:^{
	// 		_highlightedBackgroundView.alpha = 0.0f;
	// 	}];
	// } else {
	// 	[self setHighlighted:NO];
	// }
}

- (void)willMoveToWindow:(UIWindow *)window {
	[super willMoveToWindow:window];
}

- (void)setCenter:(CGPoint)center {
	[self cancelTrackingWithEvent:nil];
	[super setCenter:center];
}

- (void)_touchDown:(id)arg1 {
	NSLog(@"TOUCHED DOWN YAYYYYY");
	if (_allowsHighlighting) 
		[self setHighlighted:YES];
}

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self _updateForStateChange];
}

- (void)setSelected:(BOOL)selected {
	BOOL updateState = selected != [self isSelected];
	[super setSelected:selected];
	if (updateState)
		[self _updateForStateChange];
}

- (void)setHighlighted:(BOOL)highlighted {
	if (!_allowsHighlighting)
		highlighted = NO;
	[super setHighlighted:highlighted];

	if (!(!highlighted && [self isSelected]))
		[self _updateForStateChange];
}

- (void)setAllowsHighlighting:(BOOL)allowsHighlighting {
	_allowsHighlighting = allowsHighlighting;
	//_highlightedBackgroundView.hidden = YES;
}

@end