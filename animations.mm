//
//  CircleView.m
//  CircleView
//
//  Created by John Coates on 7/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#import "CircleView.h"
@import CoreGraphics;
@import QuartzCore;

// MARK: - Private Animation Class

@interface CircleViewAnimationAction : NSObject <CAAction>

@property CABasicAnimation *pendingAnimation;
@property CGFloat priorCornerRadius;

@end

@implementation CircleViewAnimationAction

- (void)runActionForKey:(NSString *)event
                 object:(id)anObject
              arguments:(nullable NSDictionary *)dict {
    CALayer *layer = anObject;
    CABasicAnimation *pendingAnimation = self.pendingAnimation;
    if (!layer || !pendingAnimation) {
        return;
    }
    
    if (pendingAnimation.isAdditive) {
        pendingAnimation.fromValue = @(self.priorCornerRadius - layer.cornerRadius);
        pendingAnimation.toValue = @0;
    } else {
        pendingAnimation.fromValue = @(self.priorCornerRadius);
        pendingAnimation.toValue = @(layer.cornerRadius);
    }
    [layer addAnimation:pendingAnimation forKey:@"cornerRadius"];
}

@end

// MARK: - Circle View

@implementation CircleView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateCornerRadius];
}

- (void)updateCornerRadius {
    CGSize size = self.bounds.size;
    self.layer.cornerRadius = MIN(size.width, size.height) / 2;
}

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    if ([event isEqualToString:@"cornerRadius"]) {
        CABasicAnimation *boundsAnimation;
        boundsAnimation = (id)[layer animationForKey:@"bounds.size"];
        
        if (boundsAnimation) {
            CABasicAnimation *animation = (id)boundsAnimation.copy;
            animation.keyPath = @"cornerRadius";
            
            CircleViewAnimationAction *action;
            action = [CircleViewAnimationAction new];
            action.pendingAnimation = animation;
            action.priorCornerRadius = layer.cornerRadius;
            return action;
        }
        
    }
    
    return [super actionForLayer:layer forKey:event];
}

@end