#import "_MZEBackdropView.h"
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIView+Private.h>

struct CAColorMatrix
{
    float m11, m12, m13, m14, m15;
    float m21, m22, m23, m24, m25;
    float m31, m32, m33, m34, m35;
    float m41, m42, m43, m44, m45;
};

typedef struct CAColorMatrix CAColorMatrix;

@interface NSValue (ColorMatrix)
+ (NSValue *)valueWithCAColorMatrix:(CAColorMatrix)t;
- (CAColorMatrix)CAColorMatrixValue;
@end

@implementation _MZEBackdropView
+ (Class)layerClass {
	return NSClassFromString(@"CABackdropLayer");
}

- (id)init {
	self = [super init];
	if (self) {
		_saturation = 1.0f;
		_brightness = 0.0f;
		// if (self.layer) {
		// 	//CAFilter *brightnessFilter = [NSClassFromString(@"CAFilter") alloc]
		// 	CAFilter *blurFilter = [NSClassFromString(@"CAFilter") filterWithType:@"luminanceToAlpha"];
		// 	//[blurFilter setValue:[NSNumber numberWithFloat:-0.5] forKey:@"inputAmount"];
		// 	[self.layer setFilters:[NSArray arrayWithObjects:blurFilter,nil]];
		// }
	}
	return self;
}

- (id)initWithStyleDictionary:(NSDictionary *)styleDictionary {
	self = [super init];
	if (self) {
		if (styleDictionary) {
			if (styleDictionary[@"brightness"]) {
				_brightness = [(NSNumber *)styleDictionary[@"brightness"] floatValue];
			}
			if (styleDictionary[@"saturation"]) {
				_saturation = [(NSNumber *)styleDictionary[@"saturation"] floatValue];
			}
			if (styleDictionary[@"luminanceAlpha"]) {
				_saturation = [(NSNumber *)styleDictionary[@"luminanceAlpha"] floatValue];
			}

			if (styleDictionary[@"colorMatrixColor"]) {
				_colorMatrixColor = (UIColor *)styleDictionary[@"colorMatrixColor"];
			}

			if (styleDictionary[@"colorAddColor"]) {
				_colorAddColor = (UIColor *)styleDictionary[@"colorAddColor"];
			}

			if (styleDictionary[@"forcedColorMatrix"]) {
				_forcedColorMatrix = (NSValue *)styleDictionary[@"forcedColorMatrix"];
			}

			[self recomputeFilters];
		}
	}
	return self;
}

- (void)setStyleDictionary:(NSDictionary *)styleDictionary {
	if (styleDictionary) {
			if (styleDictionary[@"brightness"]) {
				_brightness = [(NSNumber *)styleDictionary[@"brightness"] floatValue];
			}
			if (styleDictionary[@"saturation"]) {
				_saturation = [(NSNumber *)styleDictionary[@"saturation"] floatValue];
			}
			if (styleDictionary[@"luminanceAlpha"]) {
				_saturation = [(NSNumber *)styleDictionary[@"luminanceAlpha"] floatValue];
			}

			if (styleDictionary[@"colorMatrixColor"]) {
				_colorMatrixColor = (UIColor *)styleDictionary[@"colorMatrixColor"];
			}

			if (styleDictionary[@"colorAddColor"]) {
				_colorAddColor = (UIColor *)styleDictionary[@"colorAddColor"];
			}

			if (styleDictionary[@"forcedColorMatrix"]) {
				_forcedColorMatrix = (NSValue *)styleDictionary[@"forcedColorMatrix"];
			}

			[self recomputeFilters];
		}
}

- (void)setBrightness:(CGFloat)brightness {
	if (brightness != _brightness) {
		_brightness = brightness;
		[self recomputeFilters];
	}
}

- (CGFloat)brightness {
	return _brightness;
}

- (void)setSaturation:(CGFloat)saturation {
	if (saturation != _saturation) {
		_saturation = saturation;
		[self recomputeFilters];
	}
}

- (CGFloat)saturation {
	return _saturation;
}

- (void)setLuminanceAlpha:(CGFloat)luminanceAlpha {
	if (luminanceAlpha != _luminanceAlpha) {
		_luminanceAlpha = luminanceAlpha;
		[self recomputeFilters];
	}
}

- (CGFloat)luminanceAlpha {
	return _luminanceAlpha;
}

- (void)setColorMatrixColor:(UIColor *)colorMatrixColor {
	if (![_colorMatrixColor isEqual:colorMatrixColor]) {
		_colorMatrixColor = colorMatrixColor;
		[self recomputeFilters];
	}
}

- (UIColor *)colorMatrixColor {
	return _colorMatrixColor;
}

- (void)setColorAddColor:(UIColor *)colorAddColor {
	if (![_colorAddColor isEqual:colorAddColor]) {
		_colorAddColor = colorAddColor;
		[self recomputeFilters];
	}
}

- (UIColor *)colorAddColor {
	return _colorAddColor;
}

- (void)setForcedColorMatrix:(NSValue *)forcedColorMatrix {
	_forcedColorMatrix = forcedColorMatrix;
	[self recomputeFilters];
}

- (NSValue *)forcedColorMatrix {
	return _forcedColorMatrix;
}

- (void)recomputeFilters {
	NSMutableArray *filters = [NSMutableArray new];

	if (!_colorAddColor && _colorMatrixColor && !_forcedColorMatrix) {
		CGFloat red, green, blue, alpha;
		if ([_colorMatrixColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
			CAColorMatrix colorMatrix = {
	            (float)alpha, 0, 0, 0, (float)red,
	            0, (float)alpha, 0, 0, (float)green,
	            0, 0, (float)alpha, 0, (float)blue,
	            0, 0, 0, (float)1.0f, 0
	        };

	        CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"colorMatrix"];
	        [filter setValue:[NSValue valueWithCAColorMatrix:colorMatrix] forKey:@"inputColorMatrix"];
	        [filters addObject:filter];

		}
	}

	if (_colorAddColor && !_forcedColorMatrix) {
		CGFloat red, green, blue, alpha;
		if ([_colorAddColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
			CAColorMatrix colorMatrix = {
	            1.0f, 0, 0, 0, red*alpha,
	            0, 1.0f, 0, 0, green*alpha,
	            0, 0, 1.0f, 0, blue*alpha,
	            0, 0, 0, 1.0f, 0
	        };

	        CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"colorMatrix"];
	        [filter setValue:[NSValue valueWithCAColorMatrix:colorMatrix] forKey:@"inputColorMatrix"];
	        [filters addObject:filter];

		}
	}

	if (_forcedColorMatrix) {
		CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"colorMatrix"];
	    [filter setValue:[NSValue valueWithCAColorMatrix:[_forcedColorMatrix CAColorMatrixValue]] forKey:@"inputColorMatrix"];
	    [filters addObject:filter];
	}

	if (_luminanceAlpha != 0) {
		CAFilter *monochrome = [NSClassFromString(@"CAFilter") filterWithType:@"colorMonochrome"];
		[monochrome setValue:(id)[[UIColor whiteColor] CGColor] forKey:@"inputColor"];
		[monochrome setValue:[NSNumber numberWithFloat:_luminanceAlpha] forKey:@"inputAmount"];
		[filters addObject:monochrome];

		// CAColorMatrix colorMatrix = {
  //           0.6f, 0, 0, -0.1f,0.17f,
		// 	0, 0.6f, 0, -0.1f, 0.17f,
		// 	0, 0, 0.6f, -0.1f, 0.17f,
		// 	0, 0, 0, 1.0f, 0.1f
  //       };

		// CAColorMatrix colorMatrix = {
  //           0.75f, 0, 0, -0.14f,0.17f,
		// 	0, 0.75f, 0, -0.14f, 0.17f,
		// 	0, 0, 0.75f, -0.14f, 0.17f,
		// 	0, 0, 0, 1.0f, 0.1f
  //       };

		CAColorMatrix colorMatrix = {
            0.8f, 0, 0, -0.05f,0.1f,
			0, 0.8f, 0, -0.05f, 0.1f,
			0, 0, 0.8f, -0.05f, 0.1f,
			0, 0, 0, 1.0f, 0.1f
        };

		CAFilter *luminance = [NSClassFromString(@"CAFilter") filterWithType:@"colorMatrix"];
		[luminance setValue:[NSValue valueWithCAColorMatrix:colorMatrix] forKey:@"inputColorMatrix"];
	    [filters addObject:luminance];
	}

	if (_saturation != 1.0f) {
		CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"colorSaturate"];
		[filter setValue:[NSNumber numberWithFloat:_saturation] forKey:@"inputAmount"];
		[filters addObject:filter];
	}

	if (_brightness != 0.0f) {
		CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"colorBrightness"];
		[filter setValue:[NSNumber numberWithFloat:_brightness] forKey:@"inputAmount"];
		[filters addObject:filter];
	}

	[self.layer setFilters:[filters copy]];
}

- (BOOL)shouldForwardSelector:(SEL)aSelector {
    return [self.layer respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return (![self respondsToSelector:aSelector] && [self shouldForwardSelector:aSelector]) ? self.layer : self;
}

- (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key {
   return ([self shouldForwardSelector:NSSelectorFromString(key)] || [super _shouldAnimatePropertyWithKey:key]);
}

@end