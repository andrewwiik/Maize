// #import "MZECAContinuousCornerLayer.h"
// #import <UIKit/UIView+Private.h>


// @implementation MZECAContinuousCornerLayer
// 	@dynamic continuousCorners;


// + (BOOL)needsDisplayForKey:(NSString *)key {
//     // To force animation when our custom properties change
//     BOOL result;
//     if ([key isEqualToString:@"continuousCorners"]) {
//         result = YES;
//     }
//     else {
//         result = [super needsDisplayForKey:key];
//     }
//     return result;
// }


// - (void)display {
// 	if (self.delegate) {
// 		UIView *view = (UIView *)self.delegate;
// 		view._continuousCornerRadius = self.continuousCorners;
// 	}
// 	[super display];
// }


// - (id)initWithLayer:(id)layer {
// 	if (self = [super initWithLayer:layer]) {
// 		if ([layer isKindOfClass:[MZECAContinuousCornerLayer class]]) {
// 			MZECAContinuousCornerLayer *other = (MZECAContinuousCornerLayer *)layer;
// 			self.continuousCorners = other.continuousCorners;
// 		}
// 	}

// 	return self;
// }

// - (id<CAAction>)actionForKey:(NSString *)key
// {
//     if ([key isEqualToString:@"continuousCorners"])
//     {
//         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
//         animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//         animation.fromValue = [[self presentationLayer] valueForKey:key];
//         return animation;
//     }
//     return [super actionForKey:key];
// }
// @end