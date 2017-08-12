#import "MZEContentModuleContentContainerView.h"
#import "MZELayoutOptions.h"
#import <UIKit/UIView+Private.h>
#import "macros.h"

@implementation MZEContentModuleContentContainerView
	@synthesize moduleMaterialView=_moduleMaterialView;

// - (void)_setContinuousCornerRadius:(CGFloat)cornerRadius {
// 	if (_moduleMaterialView) {
// 		_moduleMaterialView._continuousCornerRadius = cornerRadius;
// 		_moduleMaterialView.clipsToBounds = cornerRadius > 0 ? YES : NO;
// 	}
// }

- (void)layoutSubviews {
	[self _configureModuleMaterialViewIfNecessary];
	[super layoutSubviews];
}

- (void)addSubview:(UIView *)subview {
	[super addSubview:subview];
	[self _transitionToExpandedMode:_expanded force:YES];
}

- (MZEMaterialView *)moduleMaterialView {
	[self _configureModuleMaterialViewIfNecessary];
	return _moduleMaterialView;
}

- (void)setModuleProvidesOwnPlatter:(BOOL)providesOwnPlatter {
	_moduleProvidesOwnPlatter = providesOwnPlatter;
	if (providesOwnPlatter) {
		[_moduleMaterialView removeFromSuperview];
		_moduleMaterialView = nil;
	} else {
		[self _configureModuleMaterialViewIfNecessary];
	}
}

- (void)_configureModuleMaterialViewIfNecessary {
	if (!_moduleMaterialView && !_moduleProvidesOwnPlatter) {
		_moduleMaterialView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
		[_moduleMaterialView setFrame:[self bounds]];
		[_moduleMaterialView setAutoresizingMask:18];
		[self addSubview:_moduleMaterialView];
		[self sendSubviewToBack:_moduleMaterialView];
		[self setNeedsLayout];
	}
}

- (void)transitionToExpandedMode:(BOOL)expandedMode {
	[self _transitionToExpandedMode:expandedMode force:NO];
}

- (void)_transitionToExpandedMode:(BOOL)expanded force:(BOOL)force {
	self.clipsToBounds = YES;
	CGFloat cornerRadius = 0;
	if (force || _expanded != expanded) {
		_expanded = expanded;
		if (expanded) {
			self.animationDuration = 0.1;
			self.animationDelay = 0.15;
			cornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
		} else {
			self.animationDuration = 0.215;
			self.animationDelay = 0;
			cornerRadius = [MZELayoutOptions regularCornerRadius];
		}
		if (force) {
			self._continuousCornerRadius = cornerRadius;
		} else {
			self.layerCornerRadius = cornerRadius;
		}
	}
}

- (CGFloat)layerCornerRadius {
    return self._continuousCornerRadius;
}

- (void)setLayerCornerRadius:(CGFloat)radius {

    if (self._continuousCornerRadius != radius && !self.displayLinkActive) {
        self.wantedRadius = radius;
        self.startRadius = self._continuousCornerRadius;
        self.radiusDiff = self.wantedRadius - self.startRadius;

        if (!_displayLinkActive) {
            self.percent = 0;
            if (!self.displayLink) {
                self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
            
            }
            // self.displayLink.frameInterval = 2;
            self.startTime = CACurrentMediaTime();
            self.displayLinkActive = YES;
            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }



    // ((MZECAContinuousCornerLayer *)self.layer).continuousCorners = radius;
    // [self setNeedsDisplay];
}

- (void)stopDisplayLink {
    if (self.displayLink && _displayLinkActive) {
        self._continuousCornerRadius = _wantedRadius;
        self.wantedRadius = 0;
        self.startRadius = 0;
        self.percent = 0;
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        // [self.displayLink invalidate];
        // self.displayLink = nil;
        self.displayLinkActive = NO;
    }
    // [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    // [self.displayLink invalidate];
    // self.displayLink = nil;
    // _displayLinkActive = NO;
    // _wantedRadius = 9999;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    CFAbsoluteTime elapsed = CACurrentMediaTime() - self.startTime;
    if (elapsed < self.animationDelay) return;
    CGFloat newPercent = elapsed / self.animationDuration - floor(elapsed / self.animationDuration);
	newPercent = fminf(fmaxf(newPercent, 0.0), 1.0);
	if (self.percent > newPercent) {
		[self stopDisplayLink];
		return;
	}
	self.percent = newPercent;
	// _percent = _glyphPackageView.alpha;
	// self.backgroundColor = [UIColor colorWithWhite:0 alpha:_startAlpha + ((_wantedAlpha - _startAlpha)*_percent)];
	CGFloat cornerRadius = roundf(self.startRadius + (self.radiusDiff*self.percent));
	if (cornerRadius != self._continuousCornerRadius && self.percent > 0) {
	    //[UIView performWithoutAnimation:^{
			// [CATransaction begin];
	  //       [CATransaction setDisableActions:YES];
	        self._continuousCornerRadius = cornerRadius;
	        // [CATransaction commit];

	         if (cornerRadius == self.wantedRadius) {
	            [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	            self._continuousCornerRadius = self.wantedRadius;
	            self.displayLinkActive = NO;
	            self.percent = 0;
	         }
	         // //[self.layer setNeedsDisplay];
	         // if (_wantedRadius == 38.0) {
	         //   // self.backgroundColor = [UIColor redColor];
	         // }
	   // }];
	}

    // if (elapsed >= 14.99) {
    //     [self stopDisplayLink];
    // } else if (_percent >= 1.0) {
    //      [self stopDisplayLink];
    // }
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setOpaque:NO];
		[self _transitionToExpandedMode:NO force:YES];
	}
	return self;
}

- (id)init {
	return [self initWithFrame:CGRectZero];
}

- (BOOL)shouldForwardSelector:(SEL)aSelector {
    return [self.layer respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return (![self respondsToSelector:aSelector] && [self shouldForwardSelector:aSelector]) ? self.layer : self;
}

- (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key {
    //if ([key isEqual:@"_continuousCornerRadius"] || [key isEqual:@"_setContinuousCornerRadius:"]) return YES;
    return ([self shouldForwardSelector:NSSelectorFromString(key)] || [super _shouldAnimatePropertyWithKey:key]);
}
@end