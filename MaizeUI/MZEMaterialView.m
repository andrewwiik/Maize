#import "MZEMaterialView.h"
#import "CornerRadiusAnimationAction.h"
#import <QuartzCore/CALayer+Private.h>
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

static NSMutableDictionary *darkStyleDict;
static NSMutableDictionary *lightStyleDict;
static NSMutableDictionary *normalStyleDict;

@implementation MZEMaterialView


- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	if (self.backdropView) {
		self.backdropView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
	}
}

+ (instancetype)materialViewWithStyle:(MZEMaterialStyle)style {
	MZEMaterialView *materialView = [[MZEMaterialView alloc] init];

	if (style == MZEMaterialStyleDark) {

		if (!darkStyleDict) {
			darkStyleDict = [NSMutableDictionary new];
			darkStyleDict[@"brightness"] = [NSNumber numberWithFloat:-0.12];
			darkStyleDict[@"saturation"] = [NSNumber numberWithFloat:1.8];

	    	CAColorMatrix darkColorMatrix = {
		        0.5f, 0, 0, 0, 0.125f,
		        0, 0.5f, 0, 0, 0.125f,
		        0, 0, 0.5f, 0, 0.125f,
		        0, 0, 0, 1.0f, 0
	      	};

	      	darkStyleDict[@"forcedColorMatrix"] = [NSValue valueWithCAColorMatrix:darkColorMatrix];
		}

      	[materialView.backdropView setStyleDictionary:[darkStyleDict copy]];
	} else if (style == MZEMaterialStyleLight) {
		if (!lightStyleDict) {
			lightStyleDict = [NSMutableDictionary new];

			lightStyleDict[@"brightness"] = [NSNumber numberWithFloat:0.52];
			lightStyleDict[@"saturation"] = [NSNumber numberWithFloat:1.6];
			lightStyleDict[@"colorAddColor"] = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
		}

		[materialView.backdropView setStyleDictionary:[lightStyleDict copy]];
	} else if (style == MZEMaterialStyleNormal) {
		if (!normalStyleDict) {
			normalStyleDict = [NSMutableDictionary new];

			normalStyleDict[@"brightness"] = [NSNumber numberWithFloat:0.12];
			normalStyleDict[@"saturation"] = [NSNumber numberWithFloat:1.5];
		}

		[materialView.backdropView setStyleDictionary:[normalStyleDict copy]];
	}

	return materialView;
}


- (instancetype)init {
	self = [super init];
	if (self) {
		self.backdropView = [[_MZEBackdropView alloc] init];
		[self.backdropView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		//self.backdropView.translatesAutoresizingMaskIntoConstraints = NO;

		[self addSubview:self.backdropView];

		// [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
  //       [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
  //       [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
  //       [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
       self.layer.allowsGroupBlending = NO;
	}
	return self;
}

- (id)initWithStyleDict:(NSDictionary *)styleDictionary {
	self = [self init];
	if (self) {
		if (self.backdropView) {
			[self.backdropView setStyleDictionary:[styleDictionary copy]];
		}
	}
	return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //[self updateCornerRadius];
}

- (void)setBrightness:(CGFloat)brightness {
	self.backdropView.brightness = brightness;
}

- (CGFloat)brightness {
	return self.backdropView.brightness;
}

- (void)setSaturation:(CGFloat)saturation {
	self.backdropView.saturation = saturation;
}

- (CGFloat)saturation {
	return self.backdropView.saturation;
}

- (void)setLuminanceAlpha:(CGFloat)luminanceAlpha {
	self.backdropView.luminanceAlpha = luminanceAlpha;
}

- (CGFloat)luminanceAlpha {
	return self.backdropView.luminanceAlpha;
}

- (void)setColorMatrixColor:(UIColor *)colorMatrixColor {
	self.backdropView.colorMatrixColor = colorMatrixColor;
}

- (UIColor *)colorMatrixColor {
	return self.backdropView.colorMatrixColor;
}

- (void)setColorAddColor:(UIColor *)colorAddColor {
	self.backdropView.colorAddColor = colorAddColor;
}

- (UIColor *)colorAddColor {
	return self.backdropView.colorAddColor;
}

- (void)setForcedColorMatrix:(NSValue *)forcedColorMatrix {
	self.backdropView.forcedColorMatrix = forcedColorMatrix;
}

- (NSValue *)forcedColorMatrix {
	return self.backdropView.forcedColorMatrix;
}

// - (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
//     if ([event isEqualToString:@"cornerRadius"]) {
//         CABasicAnimation *boundsAnimation;
//         boundsAnimation = (id)[layer animationForKey:@"bounds.size"];
        
//         if (boundsAnimation) {
//             CABasicAnimation *animation = (id)boundsAnimation.copy;
//             animation.keyPath = @"cornerRadius";
            
//             CornerRadiusAnimationAction *action;
//             action = [CornerRadiusAnimationAction new];
//             action.pendingAnimation = animation;
//             action.priorCornerRadius = layer.cornerRadius;
//             return action;
//         }
        
//     }
    
//     return [super actionForLayer:layer forKey:event];
// }

// - (void)updateCornerRadius {
//     CGSize size = self.bounds.size;
//     if (_cornerRadiusInterpolator) {
//     	self.backdropView.layer.cornerRadius = [_cornerRadiusInterpolator valueForReferenceMetric:size.height secondaryReferenceMetric:size.width];
//     }
// }

- (void)setCompactCornerRadius:(CGFloat)compactCornerRadius expandedCornerRadius:(CGFloat)expandedCornerRadius compactSize:(CGSize)compactSize expandedSize:(CGSize)expandedSize {
	_cornerRadiusInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	[_cornerRadiusInterpolator addValue:compactCornerRadius forReferenceMetric:compactSize.height secondaryReferenceMetric:compactSize.width];
	[_cornerRadiusInterpolator addValue:expandedCornerRadius forReferenceMetric:expandedSize.height secondaryReferenceMetric:expandedSize.width];

}

- (BOOL)isUserInteractionEnabled {
	return NO;
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
	[super setUserInteractionEnabled:NO];
}

// - (BOOL)shouldForwardSelector:(SEL)aSelector {
//    // if (aSelector == @selector(setBounds:)) return NO;
//     if (aSelector == @selector(_setContinuousCornerRadius:)) return YES;
//     if (aSelector == @selector(_continuousCornerRadius)) return YES;
//     return [self.layer respondsToSelector:aSelector];
// }

// - (id)forwardingTargetForSelector:(SEL)aSelector {
//     if (aSelector == @selector(_setContinuousCornerRadius:)) return self;
//     if (aSelector == @selector(_continuousCornerRadius)) return self;
//     return (![self respondsToSelector:aSelector] && [self shouldForwardSelector:aSelector]) ? self.layer : self;
// }

// - (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key {
//    return ([self shouldForwardSelector:NSSelectorFromString(key)] || [super _shouldAnimatePropertyWithKey:key]);
// }

// - (void)_setCornerRadius:(CGFloat)cornerRadius {
// 	if (self.backdropView) {
// 		self.backdropView.layer.cornerRadius
// 	}
// }

@end