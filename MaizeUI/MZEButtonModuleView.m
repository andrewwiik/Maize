#import "MZEButtonModuleView.h"
#import "MZELayoutOptions.h"
#import "MZEMaterialView.h"
#import <UIKit/UIView+Private.h>
#import <UIKit/UIImage+Private.h>
#import <QuartzCore/CAFilter+Private.h>

static BOOL isIOS11Mode = YES;

@interface UIImage (CCUIMask)
- (UIImage *)ccuiAlphaOnlyImageForMaskImage;
@end

@implementation MZEButtonModuleView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_highlightedBackgroundView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleLight];
		[_highlightedBackgroundView setFrame:self.bounds];
		//_highlightedBackgroundView._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
		[_highlightedBackgroundView setAlpha:0];
		[self addSubview:_highlightedBackgroundView];
		[_highlightedBackgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		_highlightedBackgroundView._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
		_highlightedBackgroundView.layer.cornerRadius = [MZELayoutOptions regularContinuousCornerRadius];
		_highlightedBackgroundView.layer.cornerContentsCenter = [MZELayoutOptions regularCornerCenter];
		_highlightedBackgroundView.layer.masksToBounds = YES;
		// _highlightedBackgroundView._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
		[self addTarget:self action:@selector(_touchDown:) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[self addTarget:self action:@selector(_touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
		[self addTarget:self action:@selector(_dragEnter:) forControlEvents:UIControlEventTouchDragEnter];
		[self addTarget:self action:@selector(_dragExit:) forControlEvents:UIControlEventTouchDragExit];
		[self addTarget:self action:@selector(_dragExit:) forControlEvents:UIControlEventTouchCancel];
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
		[_glyphPackageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
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
		[_glyphImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[_glyphImageView setFrame:self.bounds];
		[self addSubview:_glyphImageView];
		_glyphImageView.layer.shouldRasterize = YES;
	}
	_glyphImageView.layer.shouldRasterize = NO;
	_glyphImageView.image = [glyphImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	_glyphImageView.layer.shouldRasterize = YES;
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
		if (isIOS11Mode) {
			[self _setGlyphImage:glyphImage];
		} else {
	 		// if (![self isSelected] && ![self isHighlighted] && glyphImage) {
	 		// 	[self _setGlyphImage:[[glyphImage imageWithRenderingMode:0] ccuiAlphaOnlyImageForMaskImage]];
	 		// } else {
	 			[self _setGlyphImage:glyphImage];
	 		//}
		}
		// [self _setGlyphImage:glyphImage];

		CGFloat alpha;
		if ([self isHighlighted] && ![self isSelected]) {
				alpha = 0.25;
		} else {
				alpha = [self isSelected] ? 1.0 : 0;
		}
		// if (alpha > 0) {
		// 	_highlightedBackgroundView.hidden = NO;
		// } else {
		// 	_highlightedBackgroundView.hidden = YES;
		// }
		if (alpha > 0) {
			_highlightedBackgroundView.hidden = NO;
		}
		_highlightedBackgroundView.alpha = alpha;

		if (glyphColor) {
				[_glyphImageView setTintColor:glyphColor];
		}
		else {
			[_glyphImageView setTintColor:[UIColor whiteColor]];
		}

		if (![self isEnabled]) {
	 		alpha = 0.2;
	 	} else {
	 		alpha = 1;
	 	}

	 	if (_glyphImageView) {
	 		_glyphImageView.alpha = alpha;
	 	}

	 	if (_glyphPackageView) {
	 		_glyphPackageView.alpha = alpha;
	 	}

	 	if (!isIOS11Mode) {
	 		if (![self isSelected] && ![self isHighlighted]) {
	 			if (_glyphImageView) {
	 				CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantDark"];
	 				// // [filter setValue:(id)[[UIColor colorWithWhite:0.3 alpha:0.6] CGColor] forKey:@"inputColor0"];
	 				// // [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.15] CGColor] forKey:@"inputColor1"];
	 				// // [filter setValue:(id)[[UIColor colorWithWhite:0.45 alpha:0.7] CGColor] forKey:@"inputColor0"];
	 				// // [filter setValue:(id)[[UIColor colorWithWhite:0.65 alpha:0.3] CGColor] forKey:@"inputColor1"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.4 alpha:0.6] CGColor] forKey:@"inputColor0"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor] forKey:@"inputColor1"];
	 				// [filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
	 				[filter setValue:(id)[[UIColor colorWithWhite:0.4 alpha:0.6] CGColor] forKey:@"inputColor0"];
	 				[filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor] forKey:@"inputColor1"];
	 				[filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
	 				CAFilter *filter2 = [NSClassFromString(@"CAFilter") filterWithType:@"colorBrightness"];
					[filter2 setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputAmount"];
	 				_glyphImageView.layer.filters = [NSArray arrayWithObjects:filter2, nil];
	 				//_glyphImageView.alpha 
	 			}
	 			if (_glyphPackageView) {
	 				CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantDark"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.5 alpha:1.0] CGColor] forKey:@"inputColor0"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.3 alpha:0.3] CGColor] forKey:@"inputColor1"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.4 alpha:1.0] CGColor] forKey:@"inputColor0"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.3] CGColor] forKey:@"inputColor1"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.3 alpha:0.6] CGColor] forKey:@"inputColor0"];
	 				// [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.15] CGColor] forKey:@"inputColor1"];
	 				[filter setValue:(id)[[UIColor colorWithWhite:0.4 alpha:0.6] CGColor] forKey:@"inputColor0"];
	 				[filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor] forKey:@"inputColor1"];
	 				[filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
	 				CAFilter *filter2 = [NSClassFromString(@"CAFilter") filterWithType:@"colorBrightness"];
					[filter2 setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputAmount"];
	 				_glyphPackageView.layer.filters = [NSArray arrayWithObjects:filter2, nil];
	 			}
		 	} else {
	 			if (_glyphImageView) {
	 				_glyphImageView.layer.filters = nil;
	 			}
	 			if (_glyphPackageView) {
	 				_glyphPackageView.layer.filters = nil;
	 			}
		 	} 
	 	}

	 	if (!glyphImage && _glyphImageView) {
	 		_glyphImageView.hidden = YES;
	 	} else if (_glyphImageView) {
	 		_glyphImageView.hidden = NO;
	 	}
	} completion:^(BOOL completed) {
		CGFloat alpha = _highlightedBackgroundView.alpha;
		if (alpha > 0) {
			_highlightedBackgroundView.hidden = NO;
		} else {
			_highlightedBackgroundView.hidden = YES;
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
	//NSLog(@"TOUCHED DOWN YAYYYYY");
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