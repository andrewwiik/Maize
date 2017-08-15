#import "MZEContentModuleContentContainerView.h"
#import "MZELayoutOptions.h"
#import <UIKit/UIView+Private.h>
#import <MPUFoundation/MPULayoutInterpolator.h>
#import <QuartzCore/CALayer+Private.h>
#import "macros.h"

@interface CALayer (Extra)
@property (assign) CGRect cornerContentsCenter;
@end


MPULayoutInterpolator *interpolator;

// static NSMutableDictionary *storedCornerRadiusExpanded;
// static NSMutableDictionary *storedCornerRadiusRegular;
// static NSMutableDictionary *storedCornerRadiusCenterExpanded;
// static NSMutableDictionary *storedCornerRadiusCenterRegular;


@implementation MZEContentModuleContentContainerView
	@synthesize moduleMaterialView=_moduleMaterialView;
	// @synthesize expandedFrame = _expandedFrame;
	// @synthesize compactFrame = _compactFrame;

// - (void)_setContinuousCornerRadius:(CGFloat)cornerRadius {
// 	if (_moduleMaterialView) {
// 		_moduleMaterialView._continuousCornerRadius = cornerRadius;
// 		_moduleMaterialView.clipsToBounds = cornerRadius > 0 ? YES : NO;
// 	}
// }

- (void)layoutSubviews {

	[self _configureModuleMaterialViewIfNecessary];
	[super layoutSubviews];
	//[storedCornerRadiusExpanded setValue:@16 forKey:@"stuff"];

	// if (!_psuedoView) {
	// 	_psuedoView = [[UIView alloc] initWithFrame:self.bounds];
	// 	_psuedoView._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
	// 	interpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	// 	//self._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
	// 	self.smallRadius = 30;
	// 	self._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
	// 	self.bigRadius = 59;
	// 	self.layer.cornerRadius = self.smallRadius;
	// }

	// [UIView performWithoutAnimation:^{
	// 	_psuedoView.bounds = self.bounds;
	// }]
	//self._continuousCornerRadius = [interpolator valueForReferenceMetric:self.bounds.size.width];
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
		[self addSubview:_moduleMaterialView];
		[_moduleMaterialView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
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

	//if (![storedCornerRadiusExpanded objectForKey:[NSString stringWithFormat:]])

	if (self._continuousCornerRadius < 1.0f) {
		self._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
	}

	CGRect cornerCenter = CGRectZero;

	if (force || _expanded != expanded) {
		_expanded = expanded;
		if (expanded) {
			cornerRadius = [MZELayoutOptions expandedContinuousCornerRadius];
			cornerCenter = [MZELayoutOptions expandedCornerCenter];
		} else {
			cornerRadius = [MZELayoutOptions regularContinuousCornerRadius];
			cornerCenter = [MZELayoutOptions regularCornerCenter];
		}

		self.layer.cornerRadius = cornerRadius;
		self.layer.cornerContentsCenter = cornerCenter;
	}
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
